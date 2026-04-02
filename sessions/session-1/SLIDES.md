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

An AI coding assistant that lives **in your terminal**.

| Capability | What it does |
|---|---|
| **Reads** | Understands your entire project |
| **Edits** | Modifies files with surgical precision |
| **Runs** | Executes commands, tests, scripts |
| **Searches** | Finds code, patterns, dependencies |
| **Follows rules** | Reads `CLAUDE.md` every conversation |
| **Extends** | Custom commands, subagents, hooks |

Not a chatbot. Not an autocomplete. A **coding agent**.

---

## Slide 5: Installation

# Installation

```bash
# Install Claude Code globally
npm install -g @anthropic-ai/claude-code

# Create your project
mkdir meetup-bot
cd meetup-bot
git init

# Launch Claude Code
claude
```

### Requirements:
- Node.js 18+
- Git
- Anthropic API key (or ngrok AI Gateway)

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
# MeetupBot Agent Rules

## Output Format
IMPORTANT: Always return event plans as JSON.

## Schema
Every event plan MUST include:
- event_name (string)
- date (ISO 8601)
- description (string, 2-3 sentences)
- target_audience (string)
- suggested_speakers (array of objects)
- agenda (array of time/topic pairs)
- logistics (object: venue, capacity, equipment)

## Personality
You are a helpful meetup organizer. Be concise
and practical. Prefer structured output over
freeform text.
```

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

| Mode | Behavior |
|---|---|
| **Interactive** | Asks permission each time |
| **Allow list** | Pre-approved commands run automatically |
| **Dangerously skip** | Skips all prompts (not recommended) |

---

## Slide 12: ngrok AI Gateway — The Big Picture

# ngrok AI Gateway — The Big Picture

### The Problem:
- Multiple AI providers = multiple API keys
- No failover if one goes down
- No visibility into costs or usage
- PII leaking into prompts

### The Solution:
**One endpoint. Multiple providers.**

```
Your App  --->  ngrok AI Gateway  --->  Anthropic
                                  --->  OpenAI
                                  --->  Google
                                  --->  Ollama (local)
```

Single API key. Automatic routing. Full observability.

---

## Slide 13: ngrok AI Gateway — Key Features

# ngrok AI Gateway — Key Features

- **One API key** — single credential for all providers
- **Failover** — if Anthropic is down, route to OpenAI automatically
- **Cost routing** — `ngrok/auto` picks the cheapest provider for the task
- **PII redaction** — strip sensitive data before it hits the model
- **SDK compatible** — drop-in replacement, no code changes needed

```
# Instead of:
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...

# Just:
NGROK_API_KEY=ngrok-...
NGROK_AI_GATEWAY_URL=https://your-gateway.ngrok.app
```

---

## Slide 14: Setting Up ngrok Gateway

# Setting Up ngrok Gateway

**File:** `config/ngrok-gateway.json`

```json
{
  "gateway_url": "https://your-gateway.ngrok.app",
  "api_key": "ngrok-...",
  "default_model": "claude-sonnet-4-20250514",
  "fallback_models": [
    "gpt-4o",
    "gemini-pro"
  ]
}
```

### Fallback strategy:

- If gateway is configured -> use it
- If not -> fall back to direct provider URL
- Works with Claude Code's `--api-base` flag

**LIVE DEMO**

---

## Slide 15: Slash Commands

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

```bash
# Usage in Claude Code:
/plan-event "Building RAG pipelines"
```

---

## Slide 16: Anatomy of a Slash Command

# Anatomy of a Slash Command

**File:** `.claude/commands/plan-event.md`

```markdown
Plan a meetup event for the following topic: $ARGUMENTS

Follow these steps:
1. Read CLAUDE.md for output format rules
2. Generate an event plan as structured JSON
3. Include: event_name, date, description,
   target_audience, suggested_speakers, agenda,
   and logistics
4. Save the output to data/events/
5. Commit with message "Add event plan: [topic]"

IMPORTANT: Output MUST be valid JSON matching
the schema in CLAUDE.md.
```

---

## Slide 17: LIVE DEMO — Building /plan-event

# LIVE DEMO: Building /plan-event

### Steps:

1. Create `.claude/commands/plan-event.md`
2. Run `/plan-event "Building RAG pipelines"`
3. Watch Claude generate structured JSON
4. Check the output file

### Expected output (truncated):

```json
{
  "event_name": "Building RAG Pipelines",
  "date": "2026-04-15T18:30:00",
  "description": "Hands-on session covering...",
  "target_audience": "Intermediate developers...",
  "suggested_speakers": [...],
  "agenda": [...],
  "logistics": {...}
}
```

**LIVE DEMO**

---

## Slide 18: Power Keywords

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

---

## Slide 19: Tips & Gotchas

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

## Slide 20: BUILD TIME

# BUILD TIME

### Exercise: `session-1/EXERCISE.md`

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

## Slide 21: Checkpoint

# Checkpoint — What You Should Have

- [ ] Git repo initialized with commits
- [ ] `CLAUDE.md` at project root with output rules
- [ ] Project structure with `data/` directory
- [ ] ngrok AI Gateway configured (or fallback)
- [ ] `/plan-event` slash command working
- [ ] At least one event plan saved as JSON

### If you're missing any of these, let us know!

---

## Slide 22: What's Next — Session 2

# What's Next: Session 2

## Context Engineering: Blueprints Beat Prompts

- **INITIAL.md** — project bootstrap instructions
- **PRP (Prompt-Reusable Patterns)** — reusable context documents
- **Comms system** — draft emails, social posts, announcements
- Moving from single commands to **coordinated workflows**

> "Session 1 gave you the tools. Session 2 teaches you to think in systems."

---

## Slide 23: Session 1 Recap

# Session 1 Recap

### Three things to remember:

1. **`CLAUDE.md` is your agent's brain**
   - Every rule you write shapes every response

2. **Structured output > freeform text**
   - JSON schemas make agents reliable and composable

3. **ngrok AI Gateway = one endpoint, many providers**
   - Simplify keys, add failover, control costs

### You just built your first agent feature.

See you at Session 2.
