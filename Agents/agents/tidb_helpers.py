# src/aura_agent/tidb_helpers.py
import os
import pymysql
from typing import List

# <<< CHANGE START 1: Correct the import and configuration pattern >>>
import google.generativeai as genai
# <<< CHANGE END 1 >>>

from tidb_vector.integrations import TiDBVectorClient

# --- Configuration ---
TIDB_CONNECTION_STRING = os.environ.get('TIDB_DATABASE_URL')
EMBED_MODEL = "gemini-embedding-001"
EMBED_DIM = 3072

# <<< CHANGE START 2: Configure the genai library directly >>>
# This is the correct way to initialize the library with your API key.
_api_key = os.environ.get("GEMINI_API_KEY") or os.environ.get("GOOGLE_API_KEY")
if not _api_key:
    raise ValueError("GEMINI_API_KEY or GOOGLE_API_KEY not found in environment variables.")
genai.configure(api_key=_api_key)
# <<< CHANGE END 2 >>>

# --- Vector Store Clients (Unchanged) ---
conversation_vector_store = TiDBVectorClient(
    table_name='conversation_dataset',
    connection_string=TIDB_CONNECTION_STRING,
    vector_dimension=EMBED_DIM,
    distance_strategy="cosine",
    drop_existing_table=False,
)

books_vector_store = TiDBVectorClient(
    table_name='semantic_chunks_dataset',
    connection_string=TIDB_CONNECTION_STRING,
    vector_dimension=EMBED_DIM,
    distance_strategy="cosine",
    drop_existing_table=False,
)

# --- Embedding Function ---
def text_to_embedding(text: str, task_type: str = "RETRIEVAL_DOCUMENT") -> List[float]:
    """Embeds text using the Gemini embedding model."""
    # <<< CHANGE START 3: Call embed_content from the top-level genai module >>>
    result = genai.embed_content(
        model=EMBED_MODEL,
        content=text,
        task_type=task_type,
    )
    # <<< CHANGE END 3 >>>
    return result['embedding']

# --- Summary Storage Functions (Unchanged) ---
def get_db_connection():
    """Establishes a raw connection to TiDB for standard SQL operations."""
    url = pymysql.connections.uri_to_kwargs(TIDB_CONNECTION_STRING)
    return pymysql.connect(**url)

def setup_summary_table():
    """Ensures the session_summaries table exists."""
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
            CREATE TABLE IF NOT EXISTS session_summaries (
                session_id VARCHAR(255) PRIMARY KEY,
                user_id VARCHAR(255) NOT NULL,
                summary TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                INDEX(user_id)
            );
            """)
        conn.commit()
        print("session_summaries table checked/created successfully.")
    finally:
        conn.close()