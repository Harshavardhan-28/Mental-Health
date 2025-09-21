# src/aura_agent/agent.py
# This file now focuses solely on defining the agents and their orchestration.

# --- ADK Imports for Agents ---
from google.adk.agents import Agent, LlmAgent

# --- Local Tool Imports from our new tools.py file ---
from .tools import (
    guardrail_tool,
    rag_tools,
    academic_calendar_toolset,
    summarizer_tool,
    system_time_tool, # <-- ADDED IMPORT
)

# ==============================================================================
#  AGENT DEFINITIONS
# ==============================================================================

# --- The "Textbook Therapist" Persona Prompt (Updated to remove activity agent) ---
THERAPIST_PERSONA_INSTRUCTION = """
You are "AURA," an empathetic and professional AI mental health assistant. Your personality is calm, supportive, and non-judgmental. Your goal is to provide a safe space for users to express themselves and to offer helpful, evidence-based guidance.
Your workflow is critical. You MUST follow these steps in order:

1.  Safety First (Delegate to Guardrail): Your absolute first priority is user safety. If a user's message contains any hint of suicide, self-harm, or immediate danger, you MUST immediately delegate to the guardrail_agent.
2.  Active Listening & Insight (Delegate to RAG): For all other queries, begin by validating the user's feelings. Then, delegate to the rag_insight_agent to gather context from past conversations and expert texts.
3.  Synthesize and Respond: Once the rag_insight_agent provides insights, synthesize them into a single, cohesive, and empathetic response. Frame the information as a caring therapist would.
4.  Check for Context (Delegate to College Agent): If the user's query or the RAG insights mention college, school, exams, or events, delegate to the college_schedule_agent to get specific, contextual information.
5.  Conclude and Summarize (Delegate to Summarizer): When the conversation feels like it's reaching a natural conclusion, delegate to the summarizer_agent to create a session note.
"""

# --- Specialist Agents ---

guardrail_agent = LlmAgent(
    name="guardrail_agent",
    model="gemini-2.5-flash",
    description="CRITICAL: This agent's only job is to detect if a user is in immediate danger (mentions of suicide, self-harm, crisis) and trigger an emergency contact. It should be the first agent considered for any user input.",
    instruction="Analyze the user's message. If it contains any indication of immediate self-harm or suicidal intent, you MUST call the contact_emergency_support tool. Provide a brief, direct reason. If there is no immediate danger, respond with 'SAFE'.",
    tools=[guardrail_tool]
)

rag_insight_agent = LlmAgent(
    name="rag_insight_agent",
    model="gemini-2.5-pro",
    description="Gathers deep understanding of a user's problem by searching two knowledge bases: one with similar anonymized conversations and another with expert advice from textbooks.",
    instruction="To understand the user's query, you must use BOTH search_similar_conversations AND search_counselor_textbooks. After getting results from both, synthesize them into a single, comprehensive insight.",
    tools=rag_tools
)

# --- MODIFIED AGENT DEFINITION ---
UPDATED_COLLEGE_AGENT_INSTRUCTION = """
You are an expert at answering questions about the academic calendar.
Your process is very strict:
1.  For any user query that involves a date or a time range (like 'today', 'next week', 'what exams are coming up?'), you MUST first call the get_current_datetime tool to get the current date.
2.  Use the date_iso_format value from the output of get_current_datetime as your anchor for "today".
3.  Based on that current date, calculate the required start and end dates for the user's query. For example, if today is 2025-09-15 and the user asks 'what's happening next week?', you calculate the start_date as 2025-09-15 and the end_date as 2025-09-22.
4.  Finally, call the appropriate academic calendar tool (get_events_by_type or get_events_in_duration) with the calculated dates.
"""

college_schedule_agent = LlmAgent(
    name="college_schedule_agent",
    model="gemini-2.5-flash",
    description="Provides specific information about college schedules, exams, and events by connecting to the college's live information API.",
    instruction=UPDATED_COLLEGE_AGENT_INSTRUCTION, # <-- USING NEW INSTRUCTIONS
    tools=[academic_calendar_toolset, system_time_tool] # <-- ADDED NEW TOOL
)
# --- END MODIFICATION ---

summarizer_agent = LlmAgent(
    name="summarizer_agent",
    model="gemini-2.5-flash",
    description="Summarizes the key points of a conversation and saves it as a session note in the TiDB database for continuity.",
    instruction="Create a concise, third-person summary of the conversation, capturing the user's main concerns and the key advice given. Then, you MUST use the save_summary_to_tidb tool to save it.",
    tools=[summarizer_tool]
)

# --- The Root Agent: The Therapist ---
root_agent = LlmAgent(
    name="aura_therapist_agent",
    model="gemini-2.5-pro",
    instruction=THERAPIST_PERSONA_INSTRUCTION,
    description="The primary assistant who orchestrates the therapeutic workflow by delegating tasks to a team of specialist agents.",
    sub_agents=[
        guardrail_agent,
        rag_insight_agent,
        college_schedule_agent,
        summarizer_agent
    ],
)