# AI OS Plugin

> Turn your AI assistant into a business operating system. 14 skills, 3 agents, safety hooks — one install.

A white-label AI plugin that gives your assistant structured business workflows, voice-matched content writing, lead research, task management, and more. The setup wizard configures everything for YOUR specific business in one conversation.

## Install

### Runtime CLI (terminal)

The workspace includes a small wrapper binary called `aios` that delegates to
whatever underlying runtime CLI you choose. Set the environment variable
`AIOS_CMD` to the path of your runtime executable (e.g. the vendor's CLI or a
custom script) before running it. If you prefer, create a symlink named
`aios` pointing at your runtime.

```bash
# install via your runtime's plugin system or add the repository manually
# example commands will vary with your runtime:
# /plugin marketplace add BTSLAB/ai-os
# /plugin install ai-os@BTSLAB/ai-os
```

You can also install and use the bundled CLI wrapper via npm (recommended
for Linux/macOS hosts where you want a global `aios` command):

```bash
npm install -g @btslab/ai-os
export AIOS_CMD="/path/to/your/runtime-cli"  # set once, e.g. in your shell rc
aios -p "/weekly-review"
```


### Other Clients (desktop/web)

Browse to your runtime's plugin marketplace (or copy this repo) and install **AI OS**.

## What You Get

### 14 Skills

**Starter Skills (zero config):**

| Skill | What It Does |
|-------|-------------|
| `business-setup` | Setup wizard — configures the system for your business |
| `research` | Deep research on any topic using web search |
| `content-writer` | Create content in your voice (LinkedIn, email, blog) |
| `meeting-prep` | Research + talking points for upcoming meetings |
| `email-assistant` | Triage emails, draft responses, summarize threads |
| `weekly-review` | Structured weekly review and next-week planning |
| `task-manager` | SQLite-backed task and project tracking |
| `skill-creator` | Create your own custom skills |

**Power Skills (optional API keys):**

| Skill | What It Does |
|-------|-------------|
| `research-lead` | LinkedIn URL to full research package + personalized outreach |
| `content-pipeline` | YouTube transcript to LinkedIn posts + carousel PDFs |
| `email-digest` | Automated inbox to sentiment analysis to Slack briefing |
| `gamma-slides` | Markdown to professional slide deck via Gamma |
| `build-website` | PRISM framework for premium static websites |
| `build-app` | ATLAS framework for full-stack applications |

### 3 Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| `researcher` | Sonnet | Read-only research tasks |
| `content-writer` | Sonnet | Voice-matched content generation |
| `code-reviewer` | Opus | Code quality analysis |

### Safety Hooks

- **Stop hook** — Auto-captures session activity to daily logs
- **PreToolUse hook** — Blocks dangerous commands (rm -rf, force-push, credential deletion)
- **PostToolUse hook** — Validates JSON output from scripts

## Getting Started

After installing, say:

> **"Set up my business"**

The setup wizard walks you through 4 phases:
1. **Your Business** — What you do, who you serve, your offer
2. **Your Voice** — Communication style, sample text, anti-patterns
3. **Your Tools** — What you use daily, content platforms, automation wishes
4. **Your Goals** — 90-day priorities, success metrics, tasks to offload

Then it auto-configures context files so every skill knows your business and writes in your voice.

## After Setup

Just ask naturally:

- "Research [company/person/topic]"
- "Write a LinkedIn post about [topic]"
- "Prep for my meeting with [person]"
- "Help with this email: [paste]"
- "Add a task: [description]"
- "What's on my plate?"
- "Weekly review"
- "Create a skill for [workflow]"
- "Build me a website for [business]"
- "Create slides about [topic]"

## Architecture

```
ai-os/
├── .aios-plugin/
│   └── plugin.json         # Plugin manifest (update links below)
├── skills/                  # 14 business workflow skills
│   ├── business-setup/      # Setup wizard
│   ├── research/            # Deep research
│   ├── content-writer/      # Voice-matched writing
│   ├── meeting-prep/        # Meeting preparation
│   ├── email-assistant/     # Email triage + drafts
│   ├── weekly-review/       # Weekly review + planning
│   ├── task-manager/        # Task tracking (SQLite)
│   ├── skill-creator/       # Create new skills
│   ├── research-lead/       # Lead research pipeline
│   ├── content-pipeline/    # Content repurposing
│   ├── email-digest/        # Inbox processing
│   ├── gamma-slides/        # Slide generation
│   ├── build-website/       # Website builder
│   └── build-app/           # App builder
├── agents/                  # 3 specialist subagents
├── scripts/                 # Hook scripts (safety + memory)
├── hooks.json               # Hook configuration
├── settings.json            # Default permissions
└── docs/                    # Guides and upgrade paths
```

## Design Philosophy

**Separation of concerns.** AI reasoning handles WHAT to do. Deterministic scripts handle HOW. This is why a 7-step pipeline produces consistent results instead of probabilistic guessing.

```
All-AI approach:
  90% accuracy x 90% x 90% x 90% x 90% = 59% over 5 steps

Separation of concerns:
  AI decides WHAT (90%) -> Scripts execute HOW (99.9%) = consistent results
```

## Requirements

- A compatible AI runtime or service subscription
- **Python 3** for hook scripts and skill scripts
- No additional API keys needed for starter skills
- Power skills unlock with optional API keys (see docs/)

## Docs

- [Skills Guide](docs/SKILLS-GUIDE.md) — Create custom skills
- [MCP Servers](docs/MCP-SERVERS.md) — Connect external services
- [Automation](docs/AUTOMATION.md) — Cron and headless mode
- [Memory Upgrade](docs/MEMORY-UPGRADE.md) — Add vector memory
- [Upgrade Paths](docs/UPGRADE-PATHS.md) — Gmail, Telegram, n8n, more
- [Architecture](ARCHITECTURE.md) — Full system design document

## Cost

| Component | Cost |
|-----------|------|
| Runtime subscription | varies |
| Core skills (8 starter) | $0 additional |
| Power skills | Varies by API usage |
| **Minimum viable** | **$20/month** |

## License

MIT — Free to use, modify, and distribute.

## Contributing

Fork it. Improve it. Submit a PR. If you build a useful skill, share it.
