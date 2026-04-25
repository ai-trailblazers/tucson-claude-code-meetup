# Session 1: Fundamentals + Event Planning

---

## Slide 1

# Building AI Agents with Claude Code

### Session 1: Fundamentals + Your First Agent Feature

*From zero to structured event planning in 60 minutes*

Tucson Claude Code Meetup

---

## Slide 2: What We're Building

# What We're Building: MeetupBot

An AI agent that helps run a tech meetup:

- **Plans events** — generates structured event details from a topic
- **Schedules talks** — manages speaker slots and timing
- **Drafts comms** — writes emails, social posts, announcements
- **Learns from feedback** — improves over time with attendee input

### By Session 4, you'll have:

- A working agent with **subagents**, **hooks**, and a **feedback loop**
- Real skills you can apply to any agent project

---

## Slide 3: Today's Goal

# Today's Goal

**Input:**
```
/plan-event "Building RAG pipelines"
```

**Output:** Structured JSON event plan

### What you'll learn:

- Git basics (just enough to be dangerous)
- Claude Code setup & navigation
- Writing your first `CLAUDE.md`
- Configuring ngrok AI Gateway
- Building your first slash command

---

## Slide 4: What is Claude Code?

# What is Claude Code?

An AI coding assistant that lives **where you work**.

| Surface | How |
|---|---|
| **CLI** | Terminal-native (what we're using this morning) |
| **Desktop** | Mac + Windows app |
| **Web** | `claude.ai/code` |
| **VS Code** | Native extension |
| **JetBrains** | Native plugin |

| Capability | What it does |
|---|---|
| **Reads** | Understands your entire project |
| **Edits** | Modifies files with surgical precision |
| **Runs** | Executes commands, tests, scripts |
| **Searches** | Finds code, patterns, dependencies |
| **Follows rules** | Reads `CLAUDE.md` every conversation |
| **Extends** | Custom commands, subagents, hooks |

Powered by **Claude Opus 4.7** — 1M token context window. Not a chatbot. A **coding agent**.

---

## Slide 5: Installation

# Installation

```bash
# Install Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# Create your project
mkdir meetup-agent
cd meetup-agent
git init

# Launch Claude Code
claude
```

### Requirements:
- Node.js 18+
- Git
- Anthropic API key (or ngrok AI Gateway)

> See `sessions/SETUP-GUIDE.md` for detailed install instructions + LLM provider options

**LIVE DEMO**

---

## Slide 6: Git Basics — Just Enough

# Git Basics — Just Enough

Think of git commits as **save points in a video game**.

```bash
# Initialize a new repo
git init

# Stage all changes
git add -A

# Save a checkpoint
git commit -m "Add initial project structure"
```

### That's it. Three commands.

- `git init` — Start tracking
- `git add -A` — Select what to save
- `git commit -m ""` — Save with a note

You can always go back to a save point if things break.

---

## Slide 7: CLAUDE.md — Your Agent's Rulebook

# CLAUDE.md — Your Agent's Rulebook

- Lives at your **project root**
- **Auto-read** at the start of every conversation
- Defines your agent's personality, formats, constraints, and conventions

```
my-project/
  CLAUDE.md        <-- Claude reads this FIRST
  src/
  tests/
  ...
```

### This is context engineering.

You're not just prompting — you're **programming behavior**.

---

## Slide 8: What Goes in CLAUDE.md?

# What Goes in CLAUDE.md?

```markdown
# MeetupBot

## Personality
Friendly, organized, opinionated about good events.
Concise and actionable — no filler.

## Output Format
IMPORTANT: All event data MUST be structured JSON.

## Event Plan Schema
- eventName, description, date, format, targetAudience
- estimatedAttendees, suggestedDuration, topicTags, prerequisites
- suggestedSpeakers: [{id, name, reason}]
- suggestedVenue: {id, name, reason}
- schedule: {totalMinutes, slots: [{time, duration, type, title}]}
- estimatedCost: {venue, food, total, perAttendee}

## Data Locations
- Venues: data/venues.json
- Speakers: data/speakers.json
- Past events: data/past-events/
```

> **Starter template available:** `templates/CLAUDE-starter.md` has a complete, ready-to-use version with all sections filled out.

---

## Slide 9: Why Structured Output Matters

# Why Structured Output Matters

| Freeform Text | Structured JSON |
|---|---|
| "The event could be on March 15th..." | `"date": "2026-03-15"` |
| Inconsistent formatting | Predictable schema |
| Hard to parse programmatically | Easy to pipe into other tools |
| Different every time | Reliable and repeatable |
| Good for humans reading | Good for **agents consuming** |

### JSON schemas make agents reliable.

If another agent (or your code) needs to read the output, **structure wins**.

---

## Slide 10: LIVE DEMO — Creating CLAUDE.md

# LIVE DEMO: Creating CLAUDE.md

### What to watch for:

1. **Immediate reading** — Claude picks it up right away
2. **Rules affect responses** — output format changes instantly
3. **`IMPORTANT` keyword** — elevates priority of a rule

### Key moment:

> Ask Claude something *before* CLAUDE.md exists, then again *after*.
> See the difference.

**LIVE DEMO**

---

## Slide 11: Permissions

# Permissions

Claude Code asks before running commands. You can pre-configure trust.

**File:** `.claude/settings.local.json`

```json
{
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(python *)",
      "Bash(npm test)"
    ]
  }
}
```

### Modes:

| Mode | How | Best For |
|---|---|---|
| **Interactive** (default) | Approve each action | Learning, auditing |
| **Auto Mode** (`Shift+Tab`) | Classifier auto-approves safe actions | Development flow |
| **Allow list** | Pre-configured in settings.json | Teams, CI/CD |

---

## Slide 12: Connecting to an LLM Provider

# Connecting to an LLM Provider

Claude Code needs an LLM to run. Three options for today:

| Option | Setup | Cost |
|--------|-------|------|
| **Claude Max** | Already logged in — no config needed | $100/mo subscription |
| **Anthropic API** | Set `ANTHROPIC_API_KEY` env var | Pay per token |
| **ngrok AI Gateway** | One endpoint, multiple providers, failover | Free tier available |

### Simplest path (Anthropic API):
```bash
export ANTHROPIC_API_KEY=sk-ant-your-key-here
```

### If you have Claude Max:
```bash
# Nothing to configure — Claude Code detects your subscription
```

All exercises work identically regardless of which option you choose.

---

## Slide 13: ngrok AI Gateway

# ngrok AI Gateway

**One endpoint. Multiple providers. Automatic routing.**

```
Your App  --->  ngrok AI Gateway  --->  Anthropic
                                  --->  OpenAI
                                  --->  Google
                                  --->  Ollama (local)
```

- **Failover** — if Anthropic is down, route to OpenAI automatically
- **Cost routing** — `ngrok/auto` picks the cheapest model for the task
- **PII redaction** — strip sensitive data before it hits the model
- **SDK compatible** — drop-in replacement, no code changes

> ngrok was originally going to sponsor this series with gateway credits. That didn't come together, so we're using the free tier. Works fine for what we're doing.

---

## Slide 14: AI Gateway Landscape

# AI Gateway Landscape

ngrok is one of several AI gateways worth knowing about:

| Gateway | What It Does | Good For |
|---------|-------------|----------|
| **ngrok AI Gateway** | Multi-provider routing, failover, PII redaction | Production apps, cost optimization |
| **OpenRouter** | Unified API for 200+ models from many providers | Model comparison, access to niche models |
| **LiteLLM** | Open-source proxy, self-hosted | Teams wanting full control, no vendor lock-in |
| **Portkey** | Observability + routing + caching | Enterprise monitoring, prompt management |

**For Claude Code specifically:** Direct Anthropic API or ngrok. The others are useful for general AI development and multi-model apps.

---

## Slide 15: Provider Setup

# Provider Setup

### Option A: Direct Anthropic API (recommended for today)
```bash
export ANTHROPIC_API_KEY=sk-ant-your-key-here
```

### Option B: ngrok AI Gateway
**File:** `config/ngrok-gateway.json`
```json
{
  "baseUrl": "https://your-gateway.ngrok.app/v1",
  "apiKey": "ngrok-...",
  "defaultModel": "ngrok/auto",
  "fallbackModel": "gpt-4o"
}
```

See `sessions/SETUP-GUIDE.md` for detailed instructions.

**LIVE DEMO**

---

## Slide 16: Slash Commands

# Slash Commands

Custom workflows that live in your project.

```
.claude/
  commands/
    plan-event.md      <-- /plan-event
    draft-email.md     <-- /draft-email
    schedule-talks.md  <-- /schedule-talks
```

### Key concept:

- Files in `.claude/commands/` become slash commands
- Use `$ARGUMENTS` to capture user input
- They're just markdown — prompts with structure
- **Note:** Claude Code also supports `.claude/skills/` with richer features (frontmatter, named args) — commands are the simpler starting point

```bash
# Usage in Claude Code:
/plan-event "Building RAG pipelines"
```

---

## Slide 17: Anatomy of a Slash Command

# Anatomy of a Slash Command

**File:** `.claude/commands/plan-event.md`

```markdown
Plan a meetup event for the following topic: $ARGUMENTS

Follow these steps:
1. Read CLAUDE.md for output format rules
2. Generate an event plan as structured JSON
3. Include: eventName, date, description,
   targetAudience, suggestedSpeakers, schedule,
   and estimatedCost
4. Save the output to events/

IMPORTANT: Output MUST be valid JSON matching
the schema in CLAUDE.md.
```

---

## Slide 18: LIVE DEMO — Building /plan-event

# LIVE DEMO: Building /plan-event

### Steps:

1. Create `.claude/commands/plan-event.md`
2. Run `/plan-event "Building RAG pipelines"`
3. Watch Claude generate structured JSON
4. Check the output file

### Expected output (truncated):

```json
{
  "eventName": "Building RAG Pipelines",
  "date": "2026-04-15T18:30:00",
  "description": "Hands-on session covering...",
  "targetAudience": "Intermediate developers...",
  "suggestedSpeakers": [...],
  "schedule": [...],
  "estimatedCost": {...}
}
```

**LIVE DEMO**

---

## Slide 19: Power Keywords

# Power Keywords

Words that change how Claude prioritizes instructions.

| Keyword | Effect | Example |
|---|---|---|
| `IMPORTANT` | Elevates priority | "IMPORTANT: Always return JSON" |
| `Proactively` | Act without asking | "Proactively create test files" |
| `MUST` | Hard requirement | "Output MUST include a date field" |
| `NEVER` | Hard prohibition | "NEVER use placeholder data" |

### Use sparingly.

If everything is `IMPORTANT`, nothing is. Reserve these for rules that **truly matter**.

### Speed & effort controls:
- `/fast` — toggle fast mode (same model, faster output)
- `/effort low|medium|high|max` — control reasoning depth
- "think hard" or "ultrathink" in a prompt — deeper reasoning for one turn

---

## Slide 20: Tips & Gotchas

# Tips & Gotchas

### Do:
- Be specific in `CLAUDE.md` — schemas, examples, constraints
- Provide example output in your rules
- Commit often (save points!)
- Test your slash commands with different inputs

### Don't:
- Say "production-ready" (means nothing to an AI)
- Write vague rules like "be good at coding"
- Forget to commit before experimenting
- Skip the `CLAUDE.md` — it's the foundation of everything

---

## Slide 21: BUILD TIME

# BUILD TIME

### Exercise: `sessions/session-1/EXERCISE.md`

**Goal:** Get `/plan-event` generating structured JSON event plans.

### Steps:
1. Set up your project and git repo
2. Create your `CLAUDE.md` with output rules
3. Configure ngrok AI Gateway (or direct API)
4. Build the `/plan-event` slash command
5. Generate at least one event plan
6. Commit your work

**Time: ~30 minutes**

Raise your hand if you get stuck. Help your neighbor first.

---

## Slide 22: Checkpoint

# Checkpoint — What You Should Have

- [ ] Git repo initialized with commits
- [ ] `CLAUDE.md` at project root with output rules
- [ ] Project structure with `data/` directory
- [ ] LLM provider connected (API key, Claude Max, or ngrok)
- [ ] `/plan-event` slash command working
- [ ] At least one event plan saved as JSON

### If you're missing any of these, let us know!

---

## Slide 23: What's Next — Session 2

# What's Next: Session 2

## Context Engineering: Blueprints Beat Prompts

- **INITIAL.md** — project bootstrap instructions
- **PRP (Prompt-Reusable Patterns)** — reusable context documents
- **Comms system** — draft emails, social posts, announcements
- Moving from single commands to **coordinated workflows**

> Session 1: tools working. Session 2: wiring them into a pipeline.

---

## Slide 24: Session 1 Recap

# Session 1 Recap

### Three things to remember:

1. **`CLAUDE.md` is your agent's brain**
   - Every rule you write shapes every response

2. **Structured output > freeform text**
   - JSON schemas make agents reliable and composable

3. **ngrok AI Gateway = one endpoint, many providers**
   - Simplify keys, add failover, control costs

### You just built your first agent feature.

> **Scaling tip:** As your CLAUDE.md files grow across projects, [RuleMetric](https://github.com/nickyeager/momento-mori) helps manage instructions at scale — write once, convert to 25+ AI tool formats.

See you at Session 2.
