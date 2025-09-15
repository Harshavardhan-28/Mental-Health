# ShenLabs Mental Health Dataset for RAG

## 📊 Dataset Overview

**Dataset Name**: Mental Health College Student Support Dataset  
**Version**: 1.0  
**Created**: September 2025  
**Size**: 13,045 therapeutic conversations  
**Domain**: Mental Health Support for College Students  
**Format**: Input-Output Conversational Pairs  

## 🎯 Purpose

This dataset contains therapeutic conversations specifically curated for college students seeking mental health support. Each conversation pair consists of:
- **Input**: Student mental health queries, concerns, and experiences
- **Output**: Professional therapeutic responses using evidence-based approaches

## 📈 Dataset Statistics

- **Total Conversations**: 13,045
- **Average Input Length**: 101 words
- **Average Output Length**: 331 words
- **Coverage**: Anxiety, Depression, Stress, Relationships, Academic Pressure, Caregiving, Grief, Sleep Issues
- **Therapeutic Approaches**: CBT, Mindfulness, Validation, Problem-solving, Psychoeducation

## 🔄 Data Processing Pipeline

### Stage 1: Data Collection & Loading
```python
# Original dataset loaded from CSV
df = pd.read_csv('mental_health_conversations.csv')
print(f"Original dataset size: {len(df)} conversations")
```

### Stage 2: Deduplication
```python
# Remove duplicate conversations
df_deduplicated = df.drop_duplicates(subset=['input', 'output'])
removed_duplicates = len(df) - len(df_deduplicated)
print(f"Removed {removed_duplicates} duplicate conversations")
```

### Stage 3: College Student Relevance Classification
```python
def is_college_relevant(text):
    # Binary classification based on content analysis
    college_keywords = ['college', 'university', 'student', 'academic', 'exam', 'study']
    mental_health_keywords = ['anxiety', 'depression', 'stress', 'overwhelmed']
    
    score = 0
    # Keyword matching + context analysis
    # Therapeutic appropriateness assessment
    # Age-appropriate content verification
    
    return score > threshold
```

### Stage 4: Text Cleaning & Normalization
```python
def clean_text(text):
    # Convert to lowercase
    text = text.lower()
    
    # Remove personal names and identifying information
    text = remove_personal_info(text)
    
    # Remove special symbols while preserving meaning
    text = clean_symbols(text)
    
    # Normalize spacing and punctuation
    text = normalize_formatting(text)
    
    return text
```

### Stage 5: RAG Document Preparation
```python
def prepare_rag_documents(conversations):
    documents = []
    
    for idx, row in conversations.iterrows():
        # Create comprehensive document
        doc = {
            "id": f"conversation_{idx:06d}",
            "content": create_rag_content(row['input'], row['output']),
            "metadata": {
                "themes": extract_themes(row['input']),
                "therapeutic_approach": identify_approach(row['output']),
                "conversation_id": idx,
                "domain": "mental_health",
                "target_audience": "college_students"
            }
        }
        documents.append(doc)
    
    return documents
```

## 🧠 RAG Processing Features

### Theme Extraction
Automatically identifies key themes from student queries:
- **Anxiety**: panic, worry, nervous, anxious
- **Depression**: sad, hopeless, empty, depressed
- **Academic Stress**: exams, grades, pressure, study
- **Relationships**: family, friends, social, isolation
- **Sleep Issues**: insomnia, tired, sleep problems

### Therapeutic Approach Detection
Identifies evidence-based therapeutic techniques:
- **CBT**: Cognitive-behavioral therapy patterns
- **Mindfulness**: Present-moment awareness techniques
- **Validation**: Empathetic acknowledgment responses
- **Problem-solving**: Structured solution approaches
- **Psychoeducation**: Educational therapeutic content

### Document Chunking Strategy
- **Chunk Size**: 800 tokens (optimal for context + retrieval)
- **Overlap**: 100 tokens (maintains conversation continuity)
- **Granularity**: Separate documents for queries and responses
- **Metadata Enrichment**: Themes, approaches, and context tags

## 📁 File Structure

```
shenlabs_dataset/
├── README.md                           # This documentation
├── sample_data.json                    # Sample of 10 conversations
├── data_processing_pipeline.py         # Complete processing code
├── rag_document_examples.json          # RAG-ready document samples
├── statistics_summary.json             # Dataset statistics
└── validation_report.md                # Data quality assessment
```

## 🔍 Quality Assurance

### Data Validation Checks
- ✅ No personal identifying information
- ✅ Therapeutic appropriateness verified
- ✅ College student relevance confirmed
- ✅ Professional language standards maintained
- ✅ Balanced coverage of mental health topics

### Ethical Considerations
- Privacy-first data cleaning
- Professional therapeutic standards
- Crisis detection awareness
- Age-appropriate content
- Cultural sensitivity considerations

## 🚀 RAG System Integration

This dataset is optimized for:
- **Google Vertex AI RAG Engine**
- **Vector similarity search**
- **Semantic retrieval systems**
- **Conversational AI applications**
- **Mental health support chatbots**

## 📊 Sample Data Preview

See `sample_data.json` for example conversations and `rag_document_examples.json` for processed RAG documents.

---

**Prepared by**: ShenLabs AI Research Team  
**Contact**: [Your contact information]  
**License**: [Specify appropriate license for mental health data]  
**Citation**: [How to cite this dataset]
