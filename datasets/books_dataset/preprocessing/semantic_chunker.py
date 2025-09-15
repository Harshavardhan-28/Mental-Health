import os
import re
from pathlib import Path
from typing import List, Dict, Optional, Tuple
import numpy as np
import google.generativeai as genai
from sklearn.metrics.pairwise import cosine_similarity
import json
import logging

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class SemanticChunker:
    def __init__(self, cleaned_books_folder: str = "cleaned_books", api_key: str = None):
        self.cleaned_books_folder = Path(cleaned_books_folder)
        self.output_folder = Path("semantic_chunks")
        self.output_folder.mkdir(exist_ok=True)
        
        # Configure Gemini API
        if api_key:
            genai.configure(api_key=api_key)
        else:
            # Try to get API key from environment variable
            api_key = os.getenv('GEMINI_API_KEY')
            if not api_key:
                raise ValueError("Please provide Gemini API key either as parameter or set GEMINI_API_KEY environment variable")
            genai.configure(api_key=api_key)
        
        # Chunking parameters
        self.sentence_window_size = 3  # Number of sentences to combine for initial chunks
        self.similarity_threshold = 0.75  # Threshold for semantic similarity
        self.min_chunk_size = 100  # Minimum characters per chunk
        self.max_chunk_size = 1000  # Maximum characters per chunk
        
    def split_into_sentences(self, text: str) -> List[str]:
        """Split text into sentences using regex patterns"""
        # Improved sentence splitting that handles abbreviations and edge cases
        sentence_endings = r'[.!?]+(?:\s|$)'
        sentences = re.split(sentence_endings, text)
        
        # Clean and filter sentences
        cleaned_sentences = []
        for sentence in sentences:
            sentence = sentence.strip()
            if len(sentence) > 20:  # Filter out very short fragments
                cleaned_sentences.append(sentence)
        
        return cleaned_sentences
    
    def create_initial_chunks(self, sentences: List[str]) -> List[str]:
        """Create initial chunks by combining sentences within a window"""
        chunks = []
        
        for i in range(0, len(sentences), self.sentence_window_size):
            chunk_sentences = sentences[i:i + self.sentence_window_size]
            chunk_text = ' '.join(chunk_sentences)
            
            # Only add chunks that meet size requirements
            if self.min_chunk_size <= len(chunk_text) <= self.max_chunk_size:
                chunks.append(chunk_text)
            elif len(chunk_text) > self.max_chunk_size:
                # Split large chunks further
                sub_chunks = self.split_large_chunk(chunk_text)
                chunks.extend(sub_chunks)
        
        return chunks
    
    def split_large_chunk(self, chunk: str) -> List[str]:
        """Split chunks that are too large"""
        words = chunk.split()
        sub_chunks = []
        
        current_chunk = []
        current_length = 0
        
        for word in words:
            word_length = len(word) + 1  # +1 for space
            
            if current_length + word_length > self.max_chunk_size and current_chunk:
                sub_chunks.append(' '.join(current_chunk))
                current_chunk = [word]
                current_length = word_length
            else:
                current_chunk.append(word)
                current_length += word_length
        
        if current_chunk:
            sub_chunks.append(' '.join(current_chunk))
        
        return sub_chunks
    
    def get_embeddings(self, texts: List[str]) -> np.ndarray:
        """Get embeddings for a list of texts using Gemini"""
        embeddings = []
        
        for i, text in enumerate(texts):
            try:
                # Use Gemini's embedding model
                result = genai.embed_content(
                    model="models/embedding-004",  # Latest Gemini embedding model
                    content=text,
                    task_type="semantic_similarity",
                    title="Text Chunk"
                )
                embeddings.append(result['embedding'])
                
                # Log progress
                if (i + 1) % 50 == 0:
                    logger.info(f"Generated embeddings for {i + 1}/{len(texts)} chunks")
                    
            except Exception as e:
                logger.error(f"Error getting embedding for chunk {i}: {str(e)}")
                # Use zero vector as fallback
                embeddings.append([0.0] * 768)  # Assuming 768-dimensional embeddings
        
        return np.array(embeddings)
    
    def merge_similar_chunks(self, chunks: List[str], embeddings: np.ndarray) -> List[Dict]:
        """Merge semantically similar adjacent chunks"""
        if len(chunks) == 0:
            return []
        
        merged_chunks = []
        current_chunk = chunks[0]
        current_embedding = embeddings[0]
        chunk_metadata = {
            'original_indices': [0],
            'similarity_scores': []
        }
        
        for i in range(1, len(chunks)):
            # Calculate cosine similarity with current chunk
            similarity = cosine_similarity([current_embedding], [embeddings[i]])[0][0]
            
            # If similar enough and combined chunk isn't too large, merge
            combined_text = current_chunk + " " + chunks[i]
            if (similarity > self.similarity_threshold and 
                len(combined_text) <= self.max_chunk_size):
                
                current_chunk = combined_text
                current_embedding = np.mean([current_embedding, embeddings[i]], axis=0)
                chunk_metadata['original_indices'].append(i)
                chunk_metadata['similarity_scores'].append(float(similarity))
                
            else:
                # Save current chunk and start new one
                merged_chunks.append({
                    'text': current_chunk,
                    'metadata': chunk_metadata.copy()
                })
                
                current_chunk = chunks[i]
                current_embedding = embeddings[i]
                chunk_metadata = {
                    'original_indices': [i],
                    'similarity_scores': []
                }
        
        # Don't forget the last chunk
        merged_chunks.append({
            'text': current_chunk,
            'metadata': chunk_metadata
        })
        
        return merged_chunks
    
    def process_book(self, book_path: Path) -> Optional[str]:
        """Process a single cleaned book file"""
        try:
            logger.info(f"Starting semantic chunking of {book_path.name}")
            
            # Read the cleaned text
            with open(book_path, 'r', encoding='utf-8') as f:
                text = f.read()
            
            # Step 1: Split into sentences
            sentences = self.split_into_sentences(text)
            logger.info(f"Split into {len(sentences)} sentences")
            
            # Step 2: Create initial chunks
            initial_chunks = self.create_initial_chunks(sentences)
            logger.info(f"Created {len(initial_chunks)} initial chunks")
            
            if not initial_chunks:
                logger.warning(f"No valid chunks created for {book_path.name}")
                return None
            
            # Step 3: Generate embeddings
            logger.info("Generating embeddings...")
            embeddings = self.get_embeddings(initial_chunks)
            
            # Step 4: Merge similar chunks
            logger.info("Merging semantically similar chunks...")
            semantic_chunks = self.merge_similar_chunks(initial_chunks, embeddings)
            
            # Step 5: Save results
            output_data = {
                'book_name': book_path.stem,
                'total_chunks': len(semantic_chunks),
                'chunks': []
            }
            
            for i, chunk_info in enumerate(semantic_chunks):
                chunk_data = {
                    'chunk_id': i,
                    'text': chunk_info['text'],
                    'word_count': len(chunk_info['text'].split()),
                    'char_count': len(chunk_info['text']),
                    'original_indices': chunk_info['metadata']['original_indices'],
                    'similarity_scores': chunk_info['metadata']['similarity_scores']
                }
                output_data['chunks'].append(chunk_data)
            
            # Save as JSON
            output_path = self.output_folder / f"{book_path.stem}_semantic_chunks.json"
            with open(output_path, 'w', encoding='utf-8') as f:
                json.dump(output_data, f, indent=2, ensure_ascii=False)
            
            # Also save as readable text format
            text_output_path = self.output_folder / f"{book_path.stem}_chunks.txt"
            with open(text_output_path, 'w', encoding='utf-8') as f:
                f.write(f"Semantic Chunks for: {book_path.stem}\n")
                f.write("=" * 50 + "\n\n")
                
                for i, chunk_info in enumerate(semantic_chunks):
                    f.write(f"CHUNK {i + 1} (Words: {len(chunk_info['text'].split())}, "
                           f"Chars: {len(chunk_info['text'])})\n")
                    f.write("-" * 30 + "\n")
                    f.write(chunk_info['text'] + "\n\n")
            
            logger.info(f"Successfully processed {book_path.name}")
            logger.info(f"Created {len(semantic_chunks)} semantic chunks")
            logger.info(f"Results saved to {output_path} and {text_output_path}")
            
            return str(output_path)
            
        except Exception as e:
            logger.error(f"Error processing {book_path.name}: {str(e)}")
            return None
    
    def process_all_books(self) -> List[str]:
        """Process all cleaned books"""
        text_files = list(self.cleaned_books_folder.glob("*.txt"))
        
        if not text_files:
            logger.warning(f"No text files found in {self.cleaned_books_folder}")
            return []
        
        logger.info(f"Found {len(text_files)} cleaned text files to process")
        
        processed_files = []
        for text_path in text_files:
            output_path = self.process_book(text_path)
            if output_path:
                processed_files.append(output_path)
        
        logger.info(f"Successfully processed {len(processed_files)} out of {len(text_files)} books")
        return processed_files

def main():
    """Main function to perform semantic chunking"""
    # Get API key from environment or prompt user
    api_key = os.getenv('GEMINI_API_KEY')
    if not api_key:
        api_key = input("Enter your Gemini API key: ")
    
    chunker = SemanticChunker(api_key=api_key)
    processed_files = chunker.process_all_books()
    
    print(f"\nSemantic chunking complete!")
    print(f"Processed files:")
    for file_path in processed_files:
        print(f"  - {file_path}")
    
    print(f"\nSemantic chunks are saved in the 'semantic_chunks' folder")
    print("JSON files contain detailed metadata, TXT files are human-readable")

if __name__ == "__main__":
    main()
