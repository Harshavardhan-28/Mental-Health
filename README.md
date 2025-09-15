# MindEase: An Agentic AI Mental Health Companion

[![Flutter](https://img.shields.io/badge/Frontend-Flutter-blue)](https://flutter.dev)
[![Vertex AI](https://img.shields.io/badge/AI-Google%20Vertex%20AI-green)](https://cloud.google.com/vertex-ai)
[![Firebase](https://img.shields.io/badge/Backend-Firebase-orange)](https://firebase.google.com)
[![TiDB](https://img.shields.io/badge/Vector%20DB-TiDB-red)](https://tidb.cloud)
[![Node.js](https://img.shields.io/badge/MCP%20Server-Node.js-lightgrey)](https://nodejs.org)

An agentic RAG-powered counselor chatbot designed specifically for college students. It provides conversational counseling, personalized activity recommendations, and integrates with a student’s schedule to deliver holistic stress management in a safe and accessible way.

## Table of Contents
- [The Problem](#the-problem)
- [Our Solution](#our-solution)
- [Key Features](#key-features)
- [System Architecture](#system-architecture)
- [Technology Stack](#technology-stack)
- [Agent Workflow](#agent-workflow)
- [Future Scope](#future-scope)
- [Getting Started](#getting-started)
- [Data Sources & Acknowledgments](#data-sources--acknowledgments)

---

## The Problem

College is a transformative but challenging phase. Behind the energy of campus life lies a sobering reality: **1 in 7 youth aged 15–24 experiences a mental health condition**. The American Psychological Association (APA) reports that over 70% of college students face severe stress, yet more than 60% never seek help due to stigma, cost, or lack of accessible resources.

Existing wellness apps often fail because they lack personalization and context. A student juggling exams, deadlines, and social pressures needs more than generic responses—they need a system that understands their journey.

## Our Solution

MindEase is a next-generation mental health companion built on a **multi-agent system** using **Google's Vertex AI Agent Builder (ADK)** and powered by the **Gemini** family of models.

Unlike static RAG systems, our agentic framework provides deeply personalized and context-aware support by integrating three robust data modes:
1.  **APA-approved Datasets:** Trained on ShenLabs' mental health conversations.
2.  **Academic Literature:** Enriched with knowledge from APA-reviewed books on student mental health.
3.  **Live Academic Context:** An MCP server connects to institutional data (exams, timetables, events) to offer situation-aware support.
4.  **Evolving Memory:** Profile-level conversation summaries ensure no context is lost across sessions.

This is not just another chatbot. It is a holistic ecosystem where empathy meets intelligence, designed to reduce stress and build resilience.



## Key Features

-   💬 **Personalized Conversations:** Adaptive dialogue that understands each student’s academic journey and emotional profile.
-   📊 **Mood Logger & Analytics:** Generates a visual **mood map** to track emotional well-being over a semester and identify patterns related to academic events.
-   🧘 **Interactive Activity Agent:** Launches simulated environments like guided breathing, focus rooms, and journaling spaces, rather than just suggesting them.
-   📅 **Smart Academic Context Awareness:** The AI is aware of exam stress points, deadlines, and social events, providing proactive nudges and contextual support.
-   🛡️ **Guardrail Agent (Our USP):** A critical safety layer that:
    -   Blocks unsafe or uncertain LLM responses in high-risk situations.
    -   Delivers pre-generated, APA-approved crisis guidance.
    -   **Notifies trusted contacts** (family, friends) selected by the user via automated alerts.
    -   Instantly shares helplines and counselor resources.
-   🌐 **Community Support via MCP:** Envisioned to connect MCP servers across colleges, enabling a peer-to-peer support ecosystem.

## System Architecture



Our system is designed as a multi-agent ecosystem with distinct, specialized components that work in tandem.

-   **Guardrail Agent (Safety Layer):** The first point of contact. It monitors for high-risk signals, blocks unsafe LLM calls, sends pre-generated safe responses, and alerts trusted contacts.
-   **Agentic AI + RAG Layer:** Retrieves evidence-based resources from our knowledge base (indexed using **TiDB vector search**) and uses contextual reasoning with adaptive memory to formulate responses.
-   **Activity Agent:** Manages interactive environments for stress relief, including guided exercises, focus simulations, and journaling tools.
-   **MCP Server:** An external server (**built in Node.js and deployed on Render**) that provides live, institution-level data like timetables and exam schedules.
-   **Data Sources:** A rich corpus including APA datasets, academic literature, and dynamically generated user profile summaries.

## Technology Stack

-   **AI & LLM Framework:** Google Vertex AI Agent Builder (ADK) with Gemini Models
-   **Database & Vector Search:** TiDB with AgentX for high-performance RAG
-   **Frontend:** Flutter for a cross-platform, native user experience
-   **Backend & Authentication:** Firebase (Auth, Firestore) for user management and data storage
-   **MCP Server:** Node.js server deployed on Render
-   **Core Techniques:** Semantic Chunking & Advanced Prompt Engineering

## Agent Workflow

Our agent processes requests through a carefully orchestrated, safety-first workflow:

1.  **Safety Check (Guardrail Agent):** Before any reasoning, the input is evaluated. If high-risk content is detected, the LLM is blocked and a crisis protocol is engaged.
2.  **Input Capture:** The student initiates a chat or logs their mood.
3.  **Context Retrieval (RAG):** The system retrieves relevant information from our knowledge base using **TiDB vector search**.
4.  **Enrichment via MCP Server:** The agent pulls context like exam dates and deadlines via a live API call to the **MCP server hosted on Render**.
5.  **Agentic Reasoning:** The agent determines the user's intent—whether they need motivation, stress relief, or study assistance.
6.  **Action & Response:** The agent offers a personalized response, recommends an activity, or updates mood logs.
7.  **Long-term Personalization:** The conversation summary is vectorized and stored back in **TiDB**, allowing the agent's memory to evolve and learn from every interaction.

## Future Scope

-   **Advanced Binary Classifier Guardrail:** Evolving our safety system to a fine-tuned binary classifier for more nuanced and accurate detection of critical conditions.
-   **University Partnerships:** Integrate MindEase directly into official student portals and university wellness apps to increase accessibility and trust.
-   **Multilingual Support:** Breaking language barriers for diverse student populations.
-   **VR/AR Integration:** Developing immersive mental wellness environments.
-   **Wearable Integration:** Passively tracking stress signals via sleep and heart rate data.

## Getting Started



### Prerequisites

Ensure you have the following installed on your system:

*   **Flutter SDK:** For running the mobile application.
*   **Python (3.8+):** For running the backend services (data processing, MCP server).
*   **Pip:** Python's package installer.
*   **Firebase Account & CLI:** For backend services, authentication, and database.

### Installation & Setup

Follow these steps in order to get the application running.

**1. Clone the Repository**
```bash
git clone https://github.com/Harshavardhan-28/Mental-Health

```

**2. Setup Firebase Project**
1.  Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
2.  Enable **Firestore Database** and **Firebase Authentication** with the "Email/Password" sign-in method.
3.  Register a new iOS and/or Android app within your Firebase project.
4.  Follow the setup instructions to download the configuration files:
    *   For Android: `google-services.json`
    *   For iOS: `GoogleService-Info.plist`
5.  You will place these files in the Flutter app directory in a later step.


**3. Frontend Setup (Flutter App)**

This is the main mobile application that the user interacts with.

```bash
# Navigate to the main app folder from the root directory

# Add the Firebase configuration files you downloaded in Step 2:
# - Place 'google-services.json' inside the 'android/app/' directory.
# - Place 'GoogleService-Info.plist' inside the 'ios/Runner/' directory.

# Get all the Flutter package dependencies
flutter pub get

# Run the app on a connected device or emulator
flutter run
```


## Data Sources & Acknowledgments

This project would not be possible without access to high-quality, approved datasets and research.
-   **ShenLabs Mental Health Dataset** for conversational training.
-   **American Psychological Association (APA)** for research and student mental health literature.
