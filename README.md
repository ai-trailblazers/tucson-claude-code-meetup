# Tucson Claude Code Meetup

A hands-on, 4-session course where you build **MeetupBot** — an AI-powered agent that helps organize AI developer meetups. You'll learn agent-building patterns that transfer to any project, using Claude Code and ngrok AI Gateway.

## Prerequisites

- Terminal/command line access
- Node.js installed
- Git installed (we'll cover the basics)
- Text editor (VS Code recommended)
- ngrok account with AI Gateway access (or a direct LLM provider API key as fallback)

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

| Session | Topic | What You Build | Reference Modules |
|---------|-------|----------------|-------------------|
| 1 | Fundamentals | Event planner with structured JSON output | [01-slash-commands](references/claude-howto/01-slash-commands), [02-memory](references/claude-howto/02-memory), [10-cli](references/claude-howto/10-cli) |
| 2 | Context Engineering | Comms + scheduling system via PRPs | [03-skills](references/claude-howto/03-skills), [09-advanced-features](references/claude-howto/09-advanced-features) |
| 3 | Subagents & Hooks | Specialist agents + automated review loop | [04-subagents](references/claude-howto/04-subagents), [06-hooks](references/claude-howto/06-hooks), [05-mcp](references/claude-howto/05-mcp) |
| 4 | Parallel Agents & Feedback | Competing variants + self-improving system | [07-plugins](references/claude-howto/07-plugins), [08-checkpoints](references/claude-howto/08-checkpoints) |

## Session Folders

Each `sessions/session-N/` folder contains:
- `EXERCISE.md` — step-by-step instructions for the session

## Sample Data

The `data/` folder contains sample data you can copy into your project:
- `venues.json` — 5 venues with capacity, amenities, and cost info
- `speakers.json` — 8 speakers with topics, availability, and ratings
- `sample-event-plan.json` — reference output showing the expected event plan format

## Solution / Reference Implementation

The `solution/` folder contains a complete MeetupBot implementation — one snapshot per session showing exactly what your project should look like after completing that session's exercises.

```
solution/
├── session-1/   # CLAUDE.md, data files, /plan-event command, sample output
├── session-2/   # + INITIAL.md, PRP, /build-schedule, /draft-announcement, /draft-speaker-outreach
├── session-3/   # + schedule-optimizer & comms-reviewer subagents, auto-review hook
└── session-4/   # + parallel variants, /post-event command, feedback loop, complete system
```

Use these to:
- **Compare your work** after each session checkpoint
- **Debug issues** when your output doesn't match expectations
- **Demo the finished product** before starting each session
- **Copy specific files** if you fall behind and need to catch up

Each session folder is self-contained — you can `cp -r solution/session-N/ my-project/` to reset to any checkpoint.

## Reference Materials

The `references/claude-howto/` directory contains the complete [Claude How-To](https://github.com/luongnv89/claude-howto) guides — 10 progressive tutorial modules with copy-paste templates, visual diagrams, and working examples for every Claude Code feature. Use these as deep-dive companions for each session.

The `templates/` directory contains context engineering templates from the [Context Engineering Intro](https://github.com/coleam00/context-engineering-intro) — including CLAUDE.md, INITIAL.md, PRP templates, and slash commands for the generate/execute PRP workflow.

See the [Reference Guide](references/claude-howto/LEARNING-ROADMAP.md) for the full learning roadmap.

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
├── PRPs/
│   └── meetup-comms.md          # Generated PRP
└── INITIAL.md                   # Feature request template
```

## What You'll Learn

These patterns transfer to any agent project:

| Pattern | Session | Why It Matters |
|---------|---------|----------------|
| CLAUDE.md | 1 | Project rules that shape every AI response |
| Structured output | 1 | JSON schemas > freeform text for reliable agents |
| Context engineering | 2 | Complete blueprints > clever prompts |
| PRPs | 2 | Implementation specs with validation gates |
| Slash commands | 1-2 | Reusable, composable agent capabilities |
| Subagents | 3 | Specialists beat generalists |
| Hooks | 3 | Automate quality checks in the agent lifecycle |
| Parallel generation | 4 | Non-determinism becomes an advantage with evaluation |
| Feedback loops | 4 | Agents that learn from past results |

## ngrok AI Gateway

This course uses ngrok AI Gateway to route LLM calls to multiple providers through a single endpoint. Benefits:
- **One endpoint** — no managing separate API keys for OpenAI, Anthropic, Google
- **Automatic failover** — if one provider is down, the gateway tries the next
- **Cost routing** — `ngrok/auto` picks the cheapest capable model
- **PII redaction** — protect attendee data in LLM calls

**Don't have ngrok access?** Every exercise works with a direct provider URL too. Just set your `config/ngrok-gateway.json` to point at OpenAI or Anthropic directly. The agent patterns are identical.

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Claude How-To Guide](https://github.com/luongnv89/claude-howto) — Visual tutorials and templates for all Claude Code features
- [Context Engineering Intro](https://github.com/coleam00/context-engineering-intro) — Context engineering templates and PRP workflow
- [ngrok AI Gateway Docs](https://ngrok.com/docs/ai-gateway/)
- [Context Engineering Best Practices](https://www.philschmid.de/context-engineering)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)

## Attribution

This course is built on the work of others in the Claude Code community:

- **[Cole Medin](https://github.com/coleam00)** — Course structure, exercises, context engineering templates, and the PRP workflow are adapted from [context-engineering-intro](https://github.com/coleam00/context-engineering-intro). Cole's work on context engineering patterns and the generate/execute PRP workflow form the backbone of this curriculum.

- **[Luong Nguyen](https://github.com/luongnv89)** — Reference materials and deep-dive tutorials are sourced from [claude-howto](https://github.com/luongnv89/claude-howto), a comprehensive visual guide to Claude Code with 117+ documented features, copy-paste templates, and structured learning paths.

Both projects are MIT licensed. See [LICENSE](LICENSE) for details.

## License

MIT License — see [LICENSE](LICENSE) for details.
