import os
import re
import fitz  # PyMuPDF
from pathlib import Path
import logging
from typing import List, Dict, Optional

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class PDFCleaner:
    def __init__(self, books_folder: str = "books"):
        self.books_folder = Path(books_folder)
        self.output_folder = Path("cleaned_books")
        self.output_folder.mkdir(exist_ok=True)
        
        # Common academic book headers/footers to remove
        self.header_footer_patterns = [
            r'^Chapter \d+.*$',
            r'^\d+\s*$',  # Page numbers
            r'^Page \d+.*$',
            r'.*Copyright.*$',
            r'.*McGraw-Hill.*$',
            r'.*Education.*$',
            r'.*All rights reserved.*$',
            r'^[A-Z\s]{10,}$',  # Long uppercase headers
            r'^\s*www\..*$',  # Website URLs
            r'^\s*ISBN.*$',
            r'^\s*\d{4}\s*$',  # Years
        ]
        
        # Patterns for irrelevant content
        self.irrelevant_patterns = [
            r'\[Figure \d+.*?\]',
            r'\[Chart \d+.*?\]',
            r'\[Table \d+.*?\]',
            r'\[Image \d+.*?\]',
            r'Figure \d+\.\d+.*',
            r'Table \d+\.\d+.*',
            r'Chart \d+\.\d+.*',
            r'Source:.*',
            r'References\s*$',
            r'Bibliography\s*$',
            r'Index\s*$',
            r'Appendix [A-Z]\s*$',
        ]
        
        # Minimum line length to consider as meaningful content
        self.min_line_length = 20
        
    def extract_text_from_pdf(self, pdf_path: Path) -> List[Dict]:
        """Extract text from PDF with metadata about images and formatting"""
        doc = fitz.open(pdf_path)
        pages_content = []
        
        logger.info(f"Processing {pdf_path.name} - {len(doc)} pages")
        
        for page_num in range(len(doc)):
            page = doc[page_num]
            
            # Get text blocks with position info
            blocks = page.get_text("dict")
            page_text = []
            
            for block in blocks["blocks"]:
                if "lines" in block:  # Text block
                    block_text = ""
                    for line in block["lines"]:
                        line_text = ""
                        for span in line["spans"]:
                            # Skip if font size is too small (likely footnotes/captions)
                            if span["size"] < 8:
                                continue
                            # Skip if font size is very large (likely headers)
                            if span["size"] > 24:
                                continue
                            line_text += span["text"]
                        
                        if line_text.strip():
                            block_text += line_text + " "
                    
                    if block_text.strip():
                        page_text.append(block_text.strip())
            
            # Combine all text blocks for this page
            full_page_text = "\n".join(page_text)
            
            pages_content.append({
                "page_num": page_num + 1,
                "text": full_page_text,
                "images_count": len([b for b in blocks["blocks"] if "lines" not in b])
            })
        
        doc.close()
        return pages_content
    
    def clean_text_content(self, text: str) -> str:
        """Clean and normalize text content"""
        # Remove headers and footers
        lines = text.split('\n')
        cleaned_lines = []
        
        for line in lines:
            line = line.strip()
            
            # Skip empty lines
            if not line:
                continue
                
            # Skip lines that match header/footer patterns
            if any(re.match(pattern, line, re.IGNORECASE) for pattern in self.header_footer_patterns):
                continue
                
            # Skip lines that match irrelevant content patterns
            if any(re.search(pattern, line, re.IGNORECASE) for pattern in self.irrelevant_patterns):
                continue
                
            # Skip very short lines (likely artifacts)
            if len(line) < self.min_line_length:
                continue
                
            # Skip lines with too many numbers (likely data tables)
            if len(re.findall(r'\d', line)) > len(line) * 0.5:
                continue
                
            cleaned_lines.append(line)
        
        # Join lines and clean up spacing
        cleaned_text = ' '.join(cleaned_lines)
        
        # Remove multiple spaces
        cleaned_text = re.sub(r'\s+', ' ', cleaned_text)
        
        # Remove common artifacts
        cleaned_text = re.sub(r'([a-z])([A-Z])', r'\1 \2', cleaned_text)  # Add space before capitals
        cleaned_text = re.sub(r'(\w)(\d)', r'\1 \2', cleaned_text)  # Space before numbers
        cleaned_text = re.sub(r'(\d)(\w)', r'\1 \2', cleaned_text)  # Space after numbers
        
        # Clean up punctuation
        cleaned_text = re.sub(r'\s+([.,;:!?])', r'\1', cleaned_text)  # Remove space before punctuation
        cleaned_text = re.sub(r'([.,;:!?])([A-Za-z])', r'\1 \2', cleaned_text)  # Add space after punctuation
        
        # Convert to lowercase as requested
        cleaned_text = cleaned_text.lower()
        
        return cleaned_text.strip()
    
    def filter_meaningful_content(self, pages_content: List[Dict]) -> str:
        """Filter pages to keep only meaningful content"""
        meaningful_content = []
        
        for page_info in pages_content:
            text = page_info["text"]
            
            # Skip pages with too many images (likely mostly visual)
            if page_info["images_count"] > 5:
                logger.info(f"Skipping page {page_info['page_num']} - too many images ({page_info['images_count']})")
                continue
            
            # Skip very short pages (likely chapter dividers, etc.)
            if len(text.split()) < 50:
                continue
            
            # Clean the text
            cleaned_text = self.clean_text_content(text)
            
            # Only add if there's substantial content after cleaning
            if len(cleaned_text.split()) >= 30:
                meaningful_content.append(cleaned_text)
        
        return '\n\n'.join(meaningful_content)
    
    def process_book(self, pdf_path: Path) -> Optional[str]:
        """Process a single book"""
        try:
            logger.info(f"Starting processing of {pdf_path.name}")
            
            # Extract text from PDF
            pages_content = self.extract_text_from_pdf(pdf_path)
            
            # Filter and clean content
            cleaned_content = self.filter_meaningful_content(pages_content)
            
            if not cleaned_content:
                logger.warning(f"No meaningful content extracted from {pdf_path.name}")
                return None
            
            # Save cleaned content
            output_path = self.output_folder / f"{pdf_path.stem}_cleaned.txt"
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(cleaned_content)
            
            logger.info(f"Successfully processed {pdf_path.name} -> {output_path}")
            logger.info(f"Final content length: {len(cleaned_content)} characters")
            
            return str(output_path)
            
        except Exception as e:
            logger.error(f"Error processing {pdf_path.name}: {str(e)}")
            return None
    
    def process_all_books(self) -> List[str]:
        """Process all PDF books in the books folder"""
        pdf_files = list(self.books_folder.glob("*.pdf"))
        
        if not pdf_files:
            logger.warning(f"No PDF files found in {self.books_folder}")
            return []
        
        logger.info(f"Found {len(pdf_files)} PDF files to process")
        
        processed_files = []
        for pdf_path in pdf_files:
            output_path = self.process_book(pdf_path)
            if output_path:
                processed_files.append(output_path)
        
        logger.info(f"Successfully processed {len(processed_files)} out of {len(pdf_files)} books")
        return processed_files

def main():
    """Main function to clean all books"""
    cleaner = PDFCleaner()
    processed_files = cleaner.process_all_books()
    
    print(f"\nProcessing complete!")
    print(f"Processed files:")
    for file_path in processed_files:
        print(f"  - {file_path}")
    
    print(f"\nCleaned files are saved in the 'cleaned_books' folder")
    print("These files are ready for semantic chunking!")

if __name__ == "__main__":
    main()
