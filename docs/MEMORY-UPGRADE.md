# Memory Upgrade: mem0 + Pinecone (Tier 3)

Upgrade from basic memory (MEMORY.md + daily logs) to a full vector memory system with automatic fact extraction, deduplication, and semantic search.

## What You Get

| Feature | Basic (Default) | Upgraded (mem0) |
|---------|----------------|-----------------|
| Persistent facts | MEMORY.md (manual) | Auto-extracted from conversations |
| Session history | Daily logs | Daily logs + vector search |
| Deduplication | Manual | Automatic (ADD/UPDATE/DELETE/NOOP) |
| Search | Read the file | Semantic search (meaning-based) |
| Storage | Local files | Cloud vectors (Pinecone free tier) |
| Cost | $0/month | ~$0.04/month |

## Architecture

```
+----------------------------------------------------------+
|  TIER 1: CORE MEMORY — memory/MEMORY.md                  |
|  Always loaded. Synced from mem0.                        |
+----------------------------------------------------------+
          |
          v
+----------------------------------------------------------+
|  TIER 2: SESSION MEMORY — memory/logs/YYYY-MM-DD.md      |
|  Daily logs. Timeline of events.                         |
+----------------------------------------------------------+
          |
          v
+----------------------------------------------------------+
|  TIER 3: LONG-TERM MEMORY — mem0 + Pinecone              |
|  Every fact as vectors. Semantic search.                  |
|  Auto-dedup. Cloud-stored. 100K vectors free.            |
+----------------------------------------------------------+
```

## How Deduplication Works

```
New fact: "User likes dark mode"
        |
        v
Search Pinecone for similar memories
        |
+--Found similar--+--------Not found--------+
|                  |                          |
v                  v                          v
"User likes        "User prefers             ADD as new
 light mode"        dark themes"              memory
|                  |
v                  v
DELETE             UPDATE
(contradicts)      (refines)
```

Four outcomes per fact:
- **ADD** — Brand new. Store it.
- **UPDATE** — Overlaps. Merge them.
- **DELETE** — Contradicts. Remove the old one.
- **NOOP** — Already captured. Skip.

## Prerequisites

- Python 3.11+ (`brew install python@3.11` on macOS)
- OpenAI API key (for GPT-4.1 Nano extraction + embeddings)
- Pinecone API key (free at pinecone.io)

## Setup

### 1. Install Dependencies

```bash
pip3 install mem0ai pyyaml python-dotenv
```

### 2. Add API Keys to .env

```bash
OPENAI_API_KEY=sk-your-openai-key
PINECONE_API_KEY=your-pinecone-key
```

### 3. Create Configuration

Create `args/mem0_config.yaml`:

```yaml
version: "v1.1"

llm:
  provider: "openai"
  config:
    model: "gpt-4.1-nano"
    temperature: 0.1
    max_tokens: 1500

embedder:
  provider: "openai"
  config:
    model: "text-embedding-3-small"
    embedding_dims: 1536

vector_store:
  provider: "pinecone"
  config:
    collection_name: "ai-os-memory"
    embedding_model_dims: 1536
    serverless_config:
      cloud: "aws"
      region: "us-east-1"

history_db_path: "./data/mem0_history.db"

custom_fact_extraction_prompt: |
  Extract discrete, reusable facts from the conversation.
  EXTRACT: preferences, business facts, technical decisions, relationships, learned behaviors.
  DO NOT EXTRACT: temporary task details, generic knowledge, exact code snippets.
  Return facts as a JSON list of concise strings.

custom_update_memory_prompt: |
  Compare the new fact against existing memories. Choose one action:
  - ADD: Completely new information.
  - UPDATE: Refines or extends an existing memory. Provide merged text.
  - DELETE: Directly contradicts an existing memory.
  - NOOP: Already captured or too trivial.
  Prefer UPDATE over ADD when topics overlap.
```

### 4. Create Memory Tools

Create these scripts in `tools/memory/`:

**mem0_client.py** — Shared factory (all tools import this)
**mem0_add.py** — Manual memory addition
**mem0_search.py** — Semantic search
**mem0_list.py** — List all memories
**mem0_delete.py** — Delete memories
**mem0_sync_md.py** — Sync mem0 → MEMORY.md
**daily_log.py** — Daily session logs
**auto_capture.py** — THE hook script (automatic capture)

Full implementations available in the memory-system-build-spec.

### 5. Enable the Stop Hook

Update `.aios/settings.local.json`:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "python3.11 tools/memory/auto_capture.py",
            "async": true
          }
        ]
      }
    ]
  }
}
```

## Usage

```bash
# Search memory
python3.11 tools/memory/mem0_search.py --query "what tools does user prefer"

# Add a memory manually
python3.11 tools/memory/mem0_add.py --content "User prefers Pinecone for vectors"

# Sync to MEMORY.md
python3.11 tools/memory/mem0_sync_md.py

# List all memories
python3.11 tools/memory/mem0_list.py --limit 50
```

## Cost

| Component | Monthly Cost |
|-----------|-------------|
| GPT-4.1 Nano (extraction) | ~$0.03 |
| Embeddings (text-embedding-3-small) | ~$0.006 |
| Pinecone (free tier) | $0.00 |
| SQLite (local) | $0.00 |
| **Total** | **~$0.04** |

## Storage Longevity

```
Pinecone free tier: 100,000 vectors

At 20 facts/day:  100,000 / 20 = 5,000 days = 13.7 years
At 60 facts/day:  100,000 / 60 = 1,667 days = 4.5 years

With dedup, real growth is slower — many facts merge
rather than creating new vectors.
```
