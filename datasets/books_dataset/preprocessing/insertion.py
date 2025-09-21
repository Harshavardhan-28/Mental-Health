import os
import json
import glob
import hashlib
from google import genai
from google.genai import types
from tidb_vector.integrations import TiDBVectorClient
from dotenv import load_dotenv
import uuid
from pathlib import Path

# Load the connection string from the .env file
load_dotenv()

# Prefer GEMINI_API_KEY; fall back to GOOGLE_API_KEY if available
_api_key = os.environ.get("GEMINI_API_KEY") or os.environ.get("GOOGLE_API_KEY")
client = genai.Client(api_key=_api_key) if _api_key else genai.Client()

def text_to_embedding(text: str, task_type: str = "RETRIEVAL_DOCUMENT"):
    """Generate a vector embedding for the given text using Gemini."""
    result = client.models.embed_content(
        model="gemini-embedding-001",
        contents=text,
        config=types.EmbedContentConfig(task_type=task_type, output_dimensionality=3072),
    )
    [embedding_obj] = result.embeddings
    return list(embedding_obj.values)

def batch_texts_to_embeddings(texts: list[str], task_type: str = "RETRIEVAL_DOCUMENT") -> list[list[float]]:
    """Batch embed a list of strings using Gemini for efficiency."""
    result = client.models.embed_content(
        model="gemini-embedding-001",
        contents=texts,
        config=types.EmbedContentConfig(task_type=task_type, output_dimensionality=3072),
    )
    return [list(e.values) for e in result.embeddings]

def create_short_book_id(book_name: str) -> str:
    """Create a short, unique identifier for book names."""
    # Map long book names to short IDs
    book_mapping = {
        "Diane_Papalia,_Sally_Olds,_Ruth_Feldman_-_Human_Development_(2009,_McGraw-Hill_Education_cleaned": "papalia",
        "Life-Span Human Development_cleaned": "lifespan", 
        "Life-Span_Development,_13th_Edition_by_John_Santrock_(z-lib.org)[1]_cleaned": "santrock"
    }
    
    # Check if we have a predefined mapping
    for long_name, short_id in book_mapping.items():
        if long_name in book_name:
            return short_id
    
    # Fallback: create hash-based short ID
    return hashlib.md5(book_name.encode()).hexdigest()[:8]

def load_semantic_chunks_from_folder(folder_path: str) -> list[dict]:
    """Load all semantic chunks from JSON files in the specified folder."""
    folder = Path(folder_path)
    documents = []
    
    # Find all JSON files in the folder
    json_files = list(folder.glob("*_semantic_chunks.json"))
    print(f"Found {len(json_files)} semantic chunk JSON files in {folder_path}")
    
    for json_file in json_files:
        try:
            print(f"Processing {json_file.name}...")
            with open(json_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            book_name = data.get("book_name", json_file.stem.replace("_semantic_chunks", ""))
            book_short_id = create_short_book_id(book_name)
            total_chunks = data.get("total_chunks", 0)
            chunking_method = data.get("chunking_method", "semantic")
            
            print(f"  - Book: {book_name}")
            print(f"  - Short ID: {book_short_id}")
            print(f"  - Total chunks: {total_chunks}")
            
            chunks_processed = 0
            chunks_with_text = 0
            
            # Process each chunk
            for i, chunk in enumerate(data.get("chunks", [])):
                chunks_processed += 1
                
                # Handle different possible chunk structures
                chunk_id = chunk.get("chunk_id", i)
                text = chunk.get("text", "")
                word_count = chunk.get("word_count", len(text.split()) if text else 0)
                char_count = chunk.get("char_count", len(text) if text else 0)
                
                # Handle metadata that might be nested
                if "metadata" in chunk:
                    chunk_metadata = chunk["metadata"]
                    original_indices = chunk_metadata.get("original_indices", [])
                    similarity_scores = chunk_metadata.get("similarity_scores", [])
                else:
                    original_indices = chunk.get("original_indices", [])
                    similarity_scores = chunk.get("similarity_scores", [])
                
                # Create a SHORT unique document ID
                doc_id = f"{book_short_id}_c{chunk_id}"
                
                # Prepare metadata - keep original book name in metadata
                metadata = {
                    "book_name": book_name,
                    "book_short_id": book_short_id,
                    "chunk_id": chunk_id,
                    "word_count": word_count,
                    "char_count": char_count,
                    "chunking_method": chunking_method,
                    "source_file": json_file.name
                }
                
                # Add optional fields only if they have data
                if original_indices:
                    metadata["original_indices_count"] = len(original_indices)
                if similarity_scores:
                    metadata["similarity_scores_count"] = len(similarity_scores)
                
                # Only add chunks with meaningful text
                if text and text.strip() and len(text.strip()) > 10:
                    documents.append({
                        "id": doc_id,
                        "text": text.strip(),
                        "metadata": metadata
                    })
                    chunks_with_text += 1
            
            print(f"  - Processed: {chunks_processed} chunks, Valid text: {chunks_with_text}")
                
        except Exception as e:
            print(f"Error processing {json_file}: {e}")
            continue
    
    return documents

def main():
    """Main function to insert semantic chunks into TiDB Vector Database"""
    # Configuration
    semantic_chunks_folder = "semantic_chunks"
    table_name = "semantic_chunks_dataset"

    print("Loading semantic chunks from folder...")
    documents = load_semantic_chunks_from_folder(semantic_chunks_folder)
    print(f"\nPrepared {len(documents)} total documents from semantic chunks")

    if not documents:
        print("No documents found. Please check the folder path and JSON files.")
        return

    # Show summary by book
    book_counts = {}
    for doc in documents:
        book = doc["metadata"]["book_short_id"]
        book_counts[book] = book_counts.get(book, 0) + 1

    print("\nChunks per book:")
    for book_id, count in book_counts.items():
        # Find the full name for display
        full_name = next((doc["metadata"]["book_name"] for doc in documents 
                         if doc["metadata"]["book_short_id"] == book_id), book_id)
        print(f"  - {book_id} ({full_name[:50]}...): {count} chunks")

    # Create vector store with target dimension (3072)
    embed_model_dims = 3072

    print(f"\nConnecting to TiDB and creating table '{table_name}'...")
    vector_store = TiDBVectorClient(
        table_name=table_name,
        connection_string=os.environ.get('TIDB_DATABASE_URL'),
        vector_dimension=embed_model_dims,
        drop_existing_table=True,  # Recreate table to avoid any schema issues
    )

    # Batch-embed and insert in chunks
    batch_size = 10  # Even smaller batches for reliability
    total = len(documents)
    print(f"\nEmbedding and inserting {total} semantic chunks in batches of {batch_size}...")

    successful_inserts = 0
    failed_batches = 0

    for start in range(0, total, batch_size):
        end = min(start + batch_size, total)
        chunk = documents[start:end]
        texts = [d["text"] for d in chunk]
        
        try:
            print(f"Processing batch {start//batch_size + 1}: chunks {start+1}-{end}")
            
            # Check ID lengths before processing
            for doc in chunk:
                if len(doc["id"]) > 50:  # Reasonable limit
                    print(f"  Warning: ID too long: {doc['id']}")
            
            embeddings = batch_texts_to_embeddings(texts, task_type="RETRIEVAL_DOCUMENT")
            vector_store.insert(
                ids=[d["id"] for d in chunk],
                texts=texts,
                embeddings=embeddings,
                metadatas=[d["metadata"] for d in chunk],
            )
            successful_inserts += len(chunk)
            print(f"  ✓ Successfully inserted {len(chunk)} chunks")
            
        except Exception as e:
            print(f"  ✗ Error processing batch {start}-{end}: {e}")
            failed_batches += 1
            continue

    print(f"\nInsertion Summary:")
    print(f"  - Total chunks: {total}")
    print(f"  - Successfully inserted: {successful_inserts}")
    print(f"  - Failed batches: {failed_batches}")

    def print_result(query, result):
        print(f"\nSearch results for: \"{query}\"")
        print("-" * 50)
        for i, r in enumerate(result, 1):
            metadata = r.metadata if hasattr(r, 'metadata') else {}
            book_short_id = metadata.get('book_short_id', 'Unknown')
            book_name = metadata.get('book_name', 'Unknown')
            chunk_id = metadata.get('chunk_id', 'Unknown')
            word_count = metadata.get('word_count', 'Unknown')
            
            print(f"{i}. Book: {book_short_id} | Chunk: {chunk_id} | Words: {word_count}")
            print(f"   Full name: {book_name[:60]}...")
            print(f"   Similarity: {1-r.distance:.4f}")
            print(f"   Text: \"{r.document[:120]}...\"")
            print()

    # Test the semantic search only if we have successful insertions
    if successful_inserts > 0:
        print("\n" + "="*60)
        print("TESTING SEMANTIC SEARCH ON HUMAN DEVELOPMENT CONTENT")
        print("="*60)

        test_queries = [
            "personality development and individual traits",
            "adolescent identity formation and self-concept", 
            "moral reasoning and ethical development"
        ]

        for query in test_queries:
            try:
                query_embedding = text_to_embedding(query, task_type="RETRIEVAL_QUERY")
                search_result = vector_store.query(query_embedding, k=3)
                print_result(query, search_result)
            except Exception as e:
                print(f"Error querying '{query}': {e}")

    print(f"Successfully processed semantic chunks from your books!")
    print(f"Database table: {table_name}")
    print(f"Total documents inserted: {successful_inserts}")

if __name__ == "__main__":
    main()
