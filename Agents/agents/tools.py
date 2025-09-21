# src/aura_agent/tools.py
# This file centralizes all tool definitions for a clean, modular architecture.

import os
import asyncio
from typing import Dict, List, AsyncGenerator
from datetime import datetime
import pytz

# --- ADK Imports for Tools ---
from google.adk.tools import FunctionTool, LongRunningFunctionTool, ToolContext
from google.adk.tools.openapi_tool.openapi_spec_parser.openapi_toolset import OpenAPIToolset

# --- Local Helper Imports ---
from .tidb_helpers import (
    conversation_vector_store,
    books_vector_store,
    text_to_embedding,
    get_db_connection
)

# ==============================================================================
#  TOOLBOX: All tool functions and instantiations are defined here.
# ==============================================================================

# --- 1. Guardrail Tool ---
def contact_emergency_support(user_id: str, reason: str) -> Dict[str, str]:
    """
    Triggers an emergency alert for a user in distress. In a real app, this
    would send an SMS or email. For the hackathon, it logs a critical alert.
    """
    print(f"\n!!! EMERGENCY ALERT TRIGGERED !!!")
    print(f"User '{user_id}' is in distress. Reason provided by agent: '{reason}'")
    print(f"ACTION: Notifying emergency contact for user {user_id}...\n")
    return {"status": "success", "message": f"Emergency contact for user {user_id} has been notified."}

# We explicitly wrap the function in a FunctionTool for clear exporting.
guardrail_tool = FunctionTool(func=contact_emergency_support)


# --- 2. RAG & Insight Tools ---
def search_similar_conversations(query: str) -> List[str]:
    """Searches the TiDB Shenlabs dataset for similar past conversations to gain empathetic context."""
    print(f"--- Tool: Searching similar conversations for '{query}' ---")
    embedding = text_to_embedding(query, task_type="RETRIEVAL_QUERY")
    results = conversation_vector_store.query(embedding, k=2)
    return [r.metadata.get('output', 'No output found.') for r in results]

def search_counselor_textbooks(query: str) -> List[str]:
    """Searches the TiDB counselor textbook knowledge base for expert advice and strategies."""
    print(f"--- Tool: Searching counselor textbooks for '{query}' ---")
    embedding = text_to_embedding(query, task_type="RETRIEVAL_QUERY")
    results = books_vector_store.query(embedding, k=2)
    return [r.document for r in results]

# We group related tools into a list for easy import.
rag_tools = [
    FunctionTool(func=search_similar_conversations),
    FunctionTool(func=search_counselor_textbooks)
]


# --- 3. College Schedule Tool (from OpenAPI) ---
academic_calendar_api_spec = """
openapi: 3.0.1
info:
  title: Academic Calendar API
  description: An API to retrieve event information from a TiDB database for an academic calendar.
  version: 1.0.0
servers:
  - url: https://tidb-mcp-lk94.onrender.com
paths:
  /get_events_in_duration:
    get:
      summary: Get Events Within A Date Range
      description: Retrieves all academic events scheduled between a start and end date.
      operationId: get_events_in_duration
      parameters:
        - name: start_date
          in: query
          required: true
          schema:
            type: string
            format: date
            example: "2025-09-01"
          description: The start date of the period, in 'YYYY-MM-DD' format.
        - name: end_date
          in: query
          required: true
          schema:
            type: string
            format: date
            example: "2025-09-10"
          description: The end date of the period, in 'YYYY-MM-DD' format.
      responses:
        '200':
          description: A list of events within the specified duration.
  /get_events_by_type:
    get:
      summary: Get Events By Type
      description: Retrieves all academic events of a specific type (e.g., 'exam', 'lecture').
      operationId: get_events_by_type
      parameters:
        - name: event_type
          in: query
          required: true
          schema:
            type: string
            example: "exam"
          description: The type of the event to retrieve.
      responses:
        '200':
          description: A list of events of the specified type.
"""

# The OpenAPIToolset is a tool provider itself.
academic_calendar_toolset = OpenAPIToolset(
    spec_str=academic_calendar_api_spec,
    spec_str_type='yaml'
)


# --- 4. Summarizer Tool ---
def save_summary_to_tidb(session_id: str, user_id: str, summary: str, tool_context: ToolContext) -> Dict[str, str]:
    """Saves the conversation summary to the session_summaries TiDB table."""
    print(f"--- Tool: Saving summary for session {session_id} to TiDB ---")
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            sql = "REPLACE INTO session_summaries (session_id, user_id, summary) VALUES (%s, %s, %s)"
            cursor.execute(sql, (session_id, user_id, summary))
        conn.commit()
        tool_context.state['last_summary'] = summary
        return {"status": "success"}
    except Exception as e:
        print(f"ERROR: Failed to save summary to TiDB: {e}")
        return {"status": "error", "message": str(e)}
    finally:
        conn.close()

summarizer_tool = FunctionTool(func=save_summary_to_tidb)


# --- 5. System Time Tool (NEWLY ADDED) ---
def get_current_datetime() -> Dict[str, str]:
    """
    Gets the current date and time in Indian Standard Time (IST). 
    This tool MUST be called first to resolve any queries involving 
    relative dates like 'today', 'next week', or 'tomorrow'.
    """
    print("--- Tool: Getting current system date and time (IST) ---")
    
    # Get current time in Indian Standard Time
    ist = pytz.timezone('Asia/Kolkata')
    now_ist = datetime.now(ist)
    now_utc = datetime.now(pytz.utc)
    
    return {
        "status": "success",
        "current_ist_datetime": now_ist.isoformat(),
        "current_utc_datetime": now_utc.isoformat(),
        "date_iso_format": now_ist.strftime('%Y-%m-%d'),
        "day_of_week": now_ist.strftime('%A'),
        "timezone": "Asia/Kolkata (IST)"
    }

# We explicitly wrap the function in a FunctionTool for clear exporting.
system_time_tool = FunctionTool(func=get_current_datetime)