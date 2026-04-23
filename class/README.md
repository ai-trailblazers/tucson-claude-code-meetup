# Building AI Agents with Claude Code — Student Guide

A 4-part course where you'll build **MeetupBot** — an AI-powered agent that helps organize AI developer meetups. You'll learn agent-building patterns that transfer to any project, using ngrok AI Gateway as the LLM backbone.

## Prerequisites

- Terminal/command line access
- Node.js installed
- Git installed (we'll cover the basics)
- Text editor (VS Code recommended — has a Claude Code extension!)
- ngrok account with AI Gateway access (or a direct LLM provider API key as fallback)

> **Claude Code runs everywhere:** CLI (terminal), Desktop app (Mac/Windows), Web (`claude.ai/code`), VS Code extension, and JetBrains plugin. We'll use the CLI in this course, but the features and patterns work across all surfaces.

## Quick Start

```bash
# 1. Install Claude Code
npm install -g @anthropic-ai/claude-code

# 2. Create your project (you'll do this in Session 1)
mkdir meetup-agent && cd meetup-agent
git init

# 3. Launch Claude Code
claude
```

## Course Structure

| Session | Topic | What You Build |
|---------|-------|----------------|
| 1 | Fundamentals | Event planner with structured JSON output |
| 2 | Context Engineering | Comms + scheduling system via brainstorm → plan → execute |
| 3 | Subagents & Hooks | Specialist agents + automated review loop |
| 4 | Parallel Agents & Feedback | Competing variants + self-improving system |

## Session Folders

Each `session-N/` folder contains:
- `EXERCISE.md` — step-by-step instructions for the session

## Starter Files

The `data/` folder contains starter files you can copy into your project:

**Sample Data** (copy into your project's `data/` and `examples/` folders):
- `venues.json` — 5 venues with capacity, amenities, and cost info
- `speakers.json` — 8 speakers with topics, availability, and ratings
- `sample-event-plan.json` — reference output (copy to `examples/sample-event-plan.json`)

**Plugin (needed for Session 2):**
- Install the superpowers plugin: `claude plugin add superpowers`
- This adds `/brainstorm`, `/write-plan`, and `/execute-plan` commands

## The Project

By the end of Session 4, you'll have built:

```
meetup-agent/
├── CLAUDE.md                     # Agent rules, output schemas, personality
├── config/
│   └── ngrok-gateway.json        # LLM routing config
├── data/
│   ├── venues.json               # Venue options
│   ├── speakers.json             # Speaker pool
│   └── past-events/              # Feedback loop data
├── events/                       # Generated event plans
├── schedules/                    # Generated schedules
├── comms/                        # Drafted communications
├── briefs/                       # Event briefs for planning
├── examples/
│   └── sample-event-plan.json    # Reference output
├── .claude/
│   ├── commands/
│   │   ├── plan-event.md         # Generate event plans
│   │   ├── build-schedule.md     # Build schedules
│   │   ├── draft-announcement.md # Draft announcements
│   │   ├── draft-speaker-outreach.md  # Speaker emails
│   │   └── post-event.md        # Post-event feedback
│   ├── agents/
│   │   ├── schedule-optimizer.md # Schedule specialist
│   │   └── comms-reviewer.md    # Comms quality gate
│   └── hooks/
│       └── auto-review.sh       # Auto-triggers review
└── docs/
    └── plans/                   # Design docs from brainstorming
```

## ngrok AI Gateway

This course uses ngrok AI Gateway to route LLM calls to multiple providers through a single endpoint. Benefits:
- One endpoint instead of managing separate API keys for OpenAI, Anthropic, Google
- Automatic failover when a provider goes down — the gateway tries the next one
- Cost routing via `ngrok/auto`, which picks the cheapest capable model
- PII redaction to protect attendee data in LLM calls

**Don't have ngrok access?** Every exercise works with a direct provider URL too. Just set your `config/ngrok-gateway.json` to point at OpenAI or Anthropic directly. The agent patterns are identical.

## What You'll Learn

These patterns transfer to any agent project:

| Pattern | Session | Why It Matters |
|---------|---------|----------------|
| CLAUDE.md | 1 | Project rules that shape every AI response |
| Self-correcting CLAUDE.md | 1 | Diagnose failures -> update rules -> retest. Compounds over time |
| Gotchas sections | 1 | Document known failure points so they never repeat |
| Structured output | 1 | JSON schemas > freeform text for reliable agents |
| Context engineering | 2 | Complete blueprints > clever prompts |
| Brainstorm → Plan → Execute | 2 | Interactive design, structured planning, batch implementation |
| Slash commands | 1-2 | Reusable, composable agent capabilities |
| Feature-specific agents | 3 | "schedule-optimizer" > "Backend Engineer" — specificity wins |
| Subagents | 3 | Specialists beat generalists |
| Tool deny-lists | 3 | Least-privilege: agents get only the tools they need |
| Quality-gate hooks | 3 | Hooks as inline evaluators, not just loggers |
| Complexity triage | 4 | Classify before processing — skip overkill for simple tasks |
| Adversarial evaluation | 4 | Evaluators that attack, not praise |
| Uncorrelated perspectives | 4 | Independent reviewers catch what solo reviewers miss |
| Fresh context via files | 4 | File-based state > LLM memory for reliability |
| Parallel generation | 4 | Non-determinism becomes an advantage with evaluation |
| Feedback loops | 4 | Agents that learn from past results |
| Workflow DAGs | 4 | Where to go next: composing everything into pipelines |
| Auto Mode | 1 | Classifier-based permissions — safe actions auto-approved |
| Conditional hooks | 3 | Target hooks to specific actions with `if` field |
| Routines | 4 | Cloud automations on schedule, GitHub events, or API calls |
| Effort controls | 1 | `/effort` and `/fast` for speed vs. reasoning depth |
| Agent SDK | 4 | Embed Claude Code agents in your own apps |

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Claude Agent SDK](https://docs.anthropic.com/en/docs/agent-sdk)
- [ngrok AI Gateway Docs](https://ngrok.com/docs/ai-gateway/)
- [Context Engineering Best Practices](https://www.philschmid.de/context-engineering)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
