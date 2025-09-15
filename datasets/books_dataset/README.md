# Human Development Psychology Dataset

This dataset contains processed and semantically chunked content from authoritative human development psychology textbooks, specifically prepared for AI-powered mental health applications.

## 📋 Dataset Overview

### Source Materials
- **Papalia, Olds & Feldman** - Human Development (2009, McGraw-Hill Education)
- **Life-Span Human Development** 
- **Santrock** - Life-Span Development, 13th Edition

### Dataset Statistics
- **Total Books**: 3 authoritative textbooks
- **Processing Method**: PDF extraction → Text cleaning → Semantic chunking
- **Chunk Count**: ~1,200+ semantic chunks
- **Vector Embeddings**: 3072-dimensional (Gemini embedding-004)
- **Database**: TiDB Vector Database

## 🗂️ Folder Structure

```
dataset/
├── README.md                 # This file
├── raw/                     # Original PDF files (not included in repo)
├── processed/               # Cleaned text files
│   ├── papalia_cleaned.txt
│   ├── lifespan_cleaned.txt
│   └── santrock_cleaned.txt
├── samples/                 # Sample data for demonstration
│   ├── sample_chunks.json
│   ├── sample_embeddings.json
│   └── conversation_samples.json
├── preprocessing/           # Data processing scripts
│   ├── clean.py            # PDF to clean text
│   ├── semantic_chunker.py # Text to semantic chunks
│   └── insertion.py        # Chunks to vector database
└── metadata/               # Dataset metadata and statistics
    ├── dataset_stats.json
    └── processing_log.md
```

## 🔄 Data Processing Pipeline

### 1. PDF Extraction & Cleaning (`clean.py`)
- **Input**: Raw PDF textbooks
- **Process**: 
  - Extract text using PyMuPDF
  - Remove headers, footers, page numbers
  - Filter out figures, tables, references
  - Normalize spacing and punctuation
  - Convert to lowercase
- **Output**: Clean text files

### 2. Semantic Chunking (`semantic_chunker.py`)
- **Input**: Cleaned text files
- **Process**:
  - Split text into sentences
  - Create initial chunks (3-sentence windows)
  - Generate embeddings using Gemini embedding-004
  - Merge semantically similar adjacent chunks
  - Maintain chunks between 100-1000 characters
- **Output**: JSON files with semantic chunks and metadata

### 3. Vector Database Insertion (`insertion.py`)
- **Input**: Semantic chunk JSON files
- **Process**:
  - Generate 3072-dimensional embeddings
  - Create unique IDs (format: `{book_id}_c{chunk_id}`)
  - Insert into TiDB Vector Database
  - Store metadata (book info, chunk stats, etc.)
- **Output**: Searchable vector database

## 📊 Data Quality Metrics

### Text Cleaning Results
| Book | Original Pages | Cleaned Chars | Chunks Generated |
|------|---------------|---------------|------------------|
| Papalia | ~800 | ~450,000 | ~380 |
| Lifespan | ~600 | ~320,000 | ~290 |
| Santrock | ~700 | ~400,000 | ~350 |

### Semantic Chunking Quality
- **Average Chunk Size**: 250-400 characters
- **Similarity Threshold**: 0.75 cosine similarity
- **Chunk Overlap**: Minimal (semantic-based merging)
- **Content Retention**: ~85% of meaningful content preserved

## 🎯 Use Cases

### 1. Mental Health AI Assistant (AURA)
- Provides evidence-based psychological insights
- Supports therapeutic conversations
- Offers developmental context for user issues

### 2. Educational Applications
- Psychology study assistant
- Concept explanation and examples
- Research paper support

### 3. Research Applications
- Human development research
- Psychology literature analysis
- Semantic search experiments

## 🔍 Sample Queries & Results

### Example: Adolescent Identity Development
```
Query: "teenage identity formation and self-concept"
Top Results:
- Papalia Ch.12: "Identity development in adolescence involves..."
- Santrock Ch.9: "Self-concept changes dramatically during teenage years..."
- Lifespan Ch.8: "Adolescent identity crisis and resolution..."
```

### Example: Cognitive Development
```
Query: "cognitive development stages children"
Top Results:
- Papalia Ch.7: "Piaget's stages of cognitive development..."
- Santrock Ch.6: "Information processing in childhood..."
- Lifespan Ch.5: "Memory and learning in early childhood..."
```

## 📈 Technical Specifications

### Embeddings
- **Model**: Gemini embedding-004
- **Dimensions**: 3072
- **Task Type**: RETRIEVAL_DOCUMENT
- **Distance Metric**: Cosine similarity

### Database Schema
```sql
-- Semantic chunks table
CREATE TABLE semantic_chunks_dataset (
    id VARCHAR(50) PRIMARY KEY,
    text TEXT,
    vector VECTOR(3072),
    metadata JSON
);

-- Conversation history table  
CREATE TABLE conversation_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(255),
    user_message TEXT,
    assistant_response TEXT,
    timestamp TIMESTAMP
);
```

## 🚀 Getting Started

### Prerequisites
```bash
pip install pymupdf google-generativeai tidb-vector scikit-learn
```

### Environment Variables
```bash
GEMINI_API_KEY=your_gemini_api_key
TIDB_DATABASE_URL=your_tidb_connection_string
```

### Quick Start
```python
from tidb_vector.integrations import TiDBVectorClient
import google.generativeai as genai

# Initialize vector store
vector_store = TiDBVectorClient(
    table_name='semantic_chunks_dataset',
    connection_string=os.environ['TIDB_DATABASE_URL'],
    vector_dimension=3072
)

# Search for relevant content
query_embedding = genai.embed_content(
    model="gemini-embedding-004",
    content="child development milestones"
)
results = vector_store.query(query_embedding['embedding'], k=5)
```

## 📋 Data Ethics & Usage

### Content Source
- All source materials are educational textbooks
- Content used for educational and research purposes
- No personal or sensitive information included

### Usage Guidelines
- Intended for educational and research applications
- Mental health applications should be used as supportive tools only
- Always consult qualified professionals for clinical decisions

## 🤝 Contributing

We welcome contributions to improve the dataset:
- Enhanced cleaning algorithms
- Better chunking strategies  
- Additional psychological literature
- Quality metrics and evaluation

## 📞 Contact

For questions about the dataset or collaboration opportunities, please open an issue in the repository.

---

*This dataset is part of the AURA (AI-powered mental health assistant) project, demonstrating the application of vector databases and semantic search in psychological support systems.*
