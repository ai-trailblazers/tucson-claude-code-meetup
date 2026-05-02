# Session 2: Context Engineering

---

## Slide 1

# Building AI Agents with Claude Code

### Session 2: Context Engineering

**Nick Yeager** — AI Solutions Architect / nickcyeager.com

Tucson Claude Code Meetup | `github.com/ai-trailblazers/tucson-claude-code-meetup`

---

## Slide 2: Recap — Where We Left Off

You have:
- A git repo with `CLAUDE.md` defining your agent's personality and schemas
- `/plan-event` that generates structured JSON event plans
- An LLM provider connected — Claude Code Max (default), Anthropic API, or ngrok
- Sample venue and speaker data in `data/`

**Today:** Build the comms and scheduling system using a different approach.

---

## Slide 3: Today's Goal

**Session 2 Milestone:**
A pipeline where `/plan-event` feeds into `/build-schedule` and `/draft-announcement`

You'll learn:
- **Context engineering** vs. prompt engineering
- **INITIAL.md** — feature requests that actually work
- **PRPs** — implementation blueprints with validation gates
- **Composable slash commands** that feed into each other
- **The examples/ folder trick** — show, don't describe

---

## Slide 4: Why agents fail

Most failures aren't model failures. They're context failures.

- Wrong output format → no schema provided
- Missed constraint → never specified
- Generic tone → no examples to match

---

## Slide 5: Design Slop

### AI output without context

Analysis of 500 Show HN sites: **67% used 2+ identical AI design patterns**.

| Pattern | What It Looks Like |
|---|---|
| Inter font, centered hero | Same headline layout |
| "VibeCode Purple" palette | Same gradient, same dark mode, same grey text |
| shadcn/ui cards with icon tops | Identical feature grids, numbered steps |
| Uppercase badges above headings | `✨ INTRODUCING` on every landing page |
| Glassmorphism + gradient shadows | Same blurry card effect everywhere |

No examples, no brand, no constraints → AI falls back to the most common patterns in training data.

Same thing happens to agent output: generic event plans, generic emails, generic schedules.

> Source: Adrian Krebs, ["Design Slop"](https://www.adriankrebs.ch/blog/design-slop/)

---

## Slide 6: Prompt Engineering vs. Context Engineering

| | Prompt Engineering | Context Engineering |
|---|---|---|
| **Approach** | Wording | System |
| **What you give** | "Write a good email" | Schema + examples + rules + data + tone |
| **Strategy** | AI guesses | AI is told |
| **Failure mode** | "Why didn't it know X?" | "I forgot to include X" |
| **Scalability** | Breaks at complexity | Scales with structure |

The problem becomes yours, not the model's.

---

## Slide 7: LIVE DEMO — The Difference

Same task, two approaches.

**Prompt engineering:**
```
Write an announcement email for a RAG meetup
```

**Context engineering:**
```
Read the event plan at events/building-rag-pipelines.json,
read data/speakers.json for speaker bios, and read
examples/sample-event-plan.json for the expected format.

Write an announcement email targeting intermediate Python
developers. Keep it under 200 words, include the date,
venue, and speaker highlights.
```

---

## Slide 8: The Context Engineering Stack

```
Layer                  Purpose
─────────────────────  ──────────────────────────────────
CLAUDE.md              Always-on rules (personality, schemas, constraints)
examples/              Reference outputs the AI mimics
data/                  Real information to work with
INITIAL.md             Feature spec (what to build)
PRPs/                  Implementation blueprint (how to build it)
.claude/commands/      Reusable workflows
```

Each layer adds context.

---

## Slide 9: INITIAL.md — The Feature Request

Four sections:

```markdown
## FEATURE:
What to build — inputs, outputs, behavior

## EXAMPLES:
Files to learn from — point to actual files in your repo

## DOCUMENTATION:
APIs, schemas, constraints

## OTHER CONSIDERATIONS:
Gotchas, edge cases, integration points
```

> **Template:** See `templates/INITIAL.md` for the blank template and `templates/INITIAL_EXAMPLE.md` for a filled-out example.

---

## Slide 10: Good vs. Bad Feature Requests

**Bad:**
```
Build a scheduling system for meetups
```

**Good:**
```
Build a scheduling system that reads event plan JSON from
/plan-event output, fits talks into time slots using speaker
availability from data/speakers.json, adds breaks every
90 min, and outputs both markdown and JSON.
```

| Bad | Good |
|---|---|
| No data sources | Points to specific files |
| No constraints | Break intervals, availability |
| No output format | Markdown + JSON |
| Ambiguous scope | Reads from, outputs to |

---

## Slide 11: PRPs — Implementation Blueprints

**PRP = Product Requirements Prompt**

Like a PRD, but for AI coding assistants:

- **Complete context** — everything the AI needs, in one file
- **Step-by-step plan** — ordered tasks with dependencies
- **Validation gates** — tests and checks that must pass
- **Error handling** — what to do when things go wrong

Generated from INITIAL.md by `/generate-prp`.

> **Note:** `/generate-prp` and `/execute-prp` are custom slash commands, not built-in Claude Code features. Templates in `templates/.claude/commands/` — copy them into your project's `.claude/commands/` directory.

---

## Slide 12: The PRP Workflow

```
INITIAL.md  -->  /generate-prp  -->  PRPs/meetup-comms.md  -->  /execute-prp  -->  Code
    ^                                        ^
    |                                        |
 You write this                   Claude researches the
                                  codebase and builds this
```

1. Describe the feature in INITIAL.md
2. `/generate-prp` reads codebase, analyzes patterns, generates blueprint
3. Review the PRP — catch misunderstandings early
4. `/execute-prp` follows the blueprint step by step

---

## Slide 13: LIVE DEMO — /generate-prp

**Run:** `/generate-prp INITIAL.md`

Claude:
1. Reads the feature request
2. Analyzes existing code (`CLAUDE.md`, commands, data files)
3. Researches patterns from `examples/`
4. Generates a blueprint

**Review `PRPs/meetup-comms.md`:**
- Does it understand the data flow (event plan → schedule, event plan → emails)?
- Did it pick up the speaker availability constraint?
- Are there validation steps?
- Did it reference the right files?

---

## Slide 14: LIVE DEMO — /execute-prp

**Run:** `/execute-prp PRPs/meetup-comms.md`

Claude:
1. Reads the full PRP
2. Creates `.claude/commands/build-schedule.md`
3. Creates `.claude/commands/draft-announcement.md`
4. Creates `.claude/commands/draft-speaker-outreach.md`
5. Validates against the event plan schema

Claude is following a blueprint you reviewed, not guessing.

---

## Slide 15: When the PRP is wrong

Most failures are catchable at review time — before `/execute-prp` runs.

| Symptom | How you spot it | How to fix |
|---|---|---|
| PRP missed a constraint from INITIAL.md | Search the PRP for the keyword — it's not there | Add it to the Implementation Plan, save, re-run `/execute-prp` |
| Generated command hardcodes values instead of `$ARGUMENTS` | Open the new command file — paths are baked in | Edit the command directly, or fix the PRP's pattern reference and re-execute |
| Output doesn't match the schema in `CLAUDE.md` | Run the command — JSON keys wrong, fields missing | Tighten the schema rules in `CLAUDE.md` — every future command benefits |
| `/execute-prp` left files half-done | Some command files in `.claude/commands/` are missing | Re-run `/execute-prp` on the same PRP — existing files are read and respected |

**The leverage points are the PRP and `CLAUDE.md`.** Command files are downstream — fix upstream, regenerate downstream.

---

## Slide 16: The Examples/ Folder

```
examples/
  sample-event-plan.json     "Make output look like this"
  sample-announcement.md     "Match this tone and format"
  sample-schedule.md         "Follow this structure"
```

The AI pattern-matches against your examples.

- Specific JSON schema → show a sample file
- Particular email tone → include a real example
- Consistent formatting → provide a template

The design slop sites all look the same because the AI had no examples to differentiate against.

---

## Slide 17: Composable Slash Commands

Commands that feed into each other:

```
/plan-event "RAG pipelines"
    --> outputs events/rag-pipelines.json

/build-schedule events/rag-pipelines.json
    --> outputs schedules/rag-pipelines.md + .json

/draft-announcement events/rag-pipelines.json
    --> outputs comms/rag-pipelines-announcement.md
```

Each command reads structured data from the previous one.

- Predictable format → reliable piping
- Schema in CLAUDE.md → every command knows the contract
- Structured beats freeform for agent-to-agent communication

---

## Slide 18: $ARGUMENTS in Slash Commands

```markdown
---
name: build-schedule
description: Build a schedule from an event plan
argument-hint: [event-plan.json]
allowed-tools: Read, Write
---

Build a schedule for the event plan at: $ARGUMENTS

## Steps:
1. Read $ARGUMENTS and data/speakers.json
2. Fit talks into time slots, breaks every 90 min
3. Output markdown + JSON to schedules/
```

**Usage:** `/build-schedule events/rag-pipelines.json`  →  `$ARGUMENTS` becomes `events/rag-pipelines.json`

> YAML frontmatter (`name`, `description`, `argument-hint`, `allowed-tools`) is the current convention. Plain-markdown commands still work. Skills (`.claude/skills/<name>/SKILL.md`) are the same idea with extra capabilities — Session 3.

---

## Slide 19: Tips & Gotchas

| | Tip |
|---|---|
| Don't | Skip INITIAL.md and go straight to coding |
| **Do** | **Review the PRP before executing** |
| Don't | Write vague EXAMPLES sections — point to specific files |
| **Do** | **Include OTHER CONSIDERATIONS — edge cases live there** |
| Don't | Expect perfection on the first PRP — iterate |
| **Do** | **Add more examples over time** |

A bad PRP executed perfectly still gives you bad code. Don't skip the review step.

---

## Slide 20: Exercise

### Build the Comms & Scheduling System via PRP

See `sessions/session-2/EXERCISE.md` for step-by-step instructions.

**Goal:** A pipeline where:
```
/plan-event --> /build-schedule --> /draft-announcement
```

**Steps:**
1. Write INITIAL.md (15 min)
2. Run `/generate-prp` and review (10 min)
3. Run `/execute-prp` and test (15 min)

**Time:** ~40 minutes

Raise your hand if you get stuck on INITIAL.md — that's the hardest part.

---

## Slide 21: Checkpoint

You should have:

- INITIAL.md with complete feature request
- Generated PRP in `PRPs/`
- `/build-schedule` command working
- `/draft-announcement` command working
- `/draft-speaker-outreach` command working
- All commands consuming JSON from previous steps

**Quick test:** Run the full pipeline end-to-end:
```
/plan-event "Your Topic" --> /build-schedule --> /draft-announcement
```

---

## Slide 22: What's Next — Session 3

### Subagents & Hooks

Right now, one agent does everything. Next session:

- **Subagents** — split into specialists (schedule optimizer, comms reviewer, quality checker)
- **Hooks** — automate checks that run on every command

---

## Slide 23: Recap

1. **Context engineering > prompt engineering**
   Give the AI everything it needs.

2. **INITIAL.md → PRP → Execute**
   Describe WHAT, generate HOW, execute.

3. **Composable commands via structured JSON**
   JSON schemas enable data flow between commands.

