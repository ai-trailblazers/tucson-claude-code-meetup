# Session 3: Subagents & Hooks

---

## Slide 1

# Building AI Agents with Claude Code

### Session 3: Subagents & Hooks
**Specialists Beat Generalists**

*Split one overloaded agent into focused specialists*

**Nick Yeager** — AI Solutions Architect / nickcyeager.com

Tucson Claude Code Meetup | `github.com/ai-trailblazers/tucson-claude-code-meetup`

---

## Slide 2: Recap — Where We Are

Last session we built **composable slash commands**:

- `/plan-event` — structured event planning
- `/build-schedule` — time-slot optimization
- `/draft-announcement` — community comms
- `/draft-speaker-outreach` — personalized emails

All composable via **JSON contracts** between commands.

**Today: break the monolith.**

---

## Slide 3: Today's Goal

Build **specialist subagents** + **automated review hooks**

| Topic | Why It Matters |
|-------|---------------|
| Why monoliths fail | Context overload kills quality |
| Subagents | Isolated specialists, one job each |
| Hooks | Lifecycle automation, quality gates |
| Model routing | Right model for the right task |

---

## Slide 4: The Monolith Problem

### LIVE DEMO

One prompt to rule them all:

```
Optimize the schedule for conflicts, rewrite the announcement
for better engagement, review the speaker outreach emails for
tone, and suggest a better venue layout — all at once.
```

Watch what happens to quality...

---

## Slide 5: Why Monolithic Fails

| Problem | What Happens |
|---------|-------------|
| **Context overload** | Agent juggles too many concerns, drops details |
| **No specialization** | Generic output for every task |
| **No quality gates** | No review step, errors pass through |
| **Can't parallelize** | Sequential bottleneck, one massive prompt |

The agent isn't bad — it's **stretched too thin**.

---

## Slide 6: Subagents — The Fix

```
                    ┌─────────────────────┐
                    │     Main Agent       │
                    │   (orchestrator)     │
                    └─────────┬───────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
    ┌─────────▼──────┐ ┌─────▼──────┐ ┌──────▼─────────┐
    │   schedule-    │ │   comms-   │ │   speaker-     │
    │   optimizer    │ │   reviewer │ │   matcher      │
    └────────────────┘ └────────────┘ └────────────────┘
    Own context         Own context     Own context
    Limited tools       Limited tools   Limited tools
    One-shot            One-shot        One-shot
```

Each subagent: **isolated context, focused job, auto-invocable**.

---

## Slide 7: Anatomy of a Subagent

File: `.claude/agents/schedule-optimizer.md`

```markdown
---
name: schedule-optimizer
description: Schedule optimization specialist. Use proactively
  to optimize any meetup schedule for speaker conflicts,
  break intervals, and audience energy.
tools: Read, Grep, Glob
model: sonnet
---

You are a meetup schedule optimization specialist.

When given an event plan, optimize the schedule by:
1. **Conflict check** — verify no speaker is double-booked
2. **Energy management** — engaging talks after breaks
3. **Break intervals** — every 60–90 minutes
4. **Setup/teardown** — 15-min buffer at start and end

## Output Format
A markdown report with: optimized schedule table,
changes made, conflicts resolved, warnings.

## Rules
- Never exceed venue capacity
- Flag conflicts — don't silently drop speakers
```

`tools` allowlist + `model:` field = least-privilege, right-sized cost.

---

## Slide 8: Key Subagent Concepts

| Concept | Detail |
|---------|--------|
| **Own context window** | Fresh context, no bleed from parent |
| **Limited tools** | Only what it needs — `Read`, `Grep`, `Glob`, not `Write` |
| **`use proactively` phrasing** | In description: encourages Claude to auto-invoke |
| **One-shot design** | Does its job, returns result, exits |
| **Structured output** | Pick a parseable format (markdown table or JSON) |

```yaml
description: Schedule optimization specialist. Use proactively
  to flag conflicts and rebalance the agenda.
```

`use proactively` is a **nudge**, not a guarantee. Claude still picks based on the description match.

---

## Slide 9: LIVE DEMO — Schedule Optimizer

### Build it. Test it.

Two ways to create a subagent:

```bash
# Option A: guided UI (recommended)
/agents
# → Library → Create new agent → Project scope

# Option B: write the file by hand
mkdir -p .claude/agents
$EDITOR .claude/agents/schedule-optimizer.md
```

> **Gotcha:** Hand-edited subagent files load at session start. After saving, **restart your session** to pick up changes. The `/agents` UI applies changes immediately.

Test it:
```
Use the schedule-optimizer agent to optimize
the Python meetup schedule for next month
```

Compare output to the **monolith attempt** from Slide 4.

---

## Slide 10: LIVE DEMO — Comms Reviewer

### Build it. Test it.

File: `.claude/agents/comms-reviewer.md`

Scores communications **1-10** on:

| Criteria | What It Checks |
|----------|---------------|
| **Completeness** | Date, time, location, RSVP link |
| **Tone** | Welcoming, professional, on-brand |
| **Clarity** | Scannable, no jargon, clear next steps |
| **CTA** | Strong call-to-action, easy to act on |

Final verdict: **SEND** / **REVISE** / **REWRITE**

---

## Slide 11: The Quality Jump

### Before (Monolith)
- "The schedule looks fine, maybe move Talk B"
- "The announcement is good, consider adding more detail"
- Generic, surface-level, no specifics

### After (Specialists)
- **3 conflicts detected**, specific resolutions proposed
- **Email scored 6/10**: missing RSVP link, weak CTA, tone too formal
- Focused, thorough, actionable output

**Same model. Same data. Different architecture.**

---

## Slide 12: Model Routing — The `model:` Field

Route the **right model** to the **right task** — natively, per subagent:

```yaml
---
name: schedule-optimizer
tools: Read, Grep, Glob
model: sonnet     # nuanced reasoning over structured data
---
```

```yaml
---
name: comms-reviewer
tools: Read, Grep, Glob
model: haiku      # fast, cheap evaluation
---
```

| Field value | When to use |
|---|---|
| `haiku` | Fast triage, scoring, classification |
| `sonnet` | Default for most reasoning |
| `opus` | Heaviest planning / hardest tradeoffs |
| `inherit` | Match the parent session (default) |

> Want to mix providers (Claude + GPT)? Put **ngrok AI Gateway** in front and route by tag. That's a layer above — `model:` handles Claude-side routing for free.

---

## Slide 13: Hooks — Lifecycle Automation

**Hooks** = code that runs when things happen in Claude Code.

Common events (full list has 30+ events — see docs):

| Hook Event | When It Fires | Use Case |
|-----------|--------------|----------|
| `PreToolUse` | Before a tool executes | Block dangerous operations, validate input |
| `PostToolUse` | After a tool completes | Trigger reviews, log actions, notify |
| `UserPromptSubmit` | When user sends a message | Validate/transform input, add context |
| `Stop` / `SubagentStop` | When the agent (or a subagent) finishes | Summarize, commit, clean up |
| `SessionStart` / `SessionEnd` | Session boundaries | Bootstrap env, archive transcripts |
| `PreCompact` | Before context compaction | Persist state you don't want compressed |

Each hook receives **JSON on stdin** with event details (tool name, file path, etc.).

**Conditional hooks** — target specific actions with the `if` field (tool events only):
```json
{ "matcher": "Bash", "hooks": [
  { "type": "command", "if": "Bash(git commit *)", "command": "..." }
]}
```

Think of hooks as **CI/CD for your agent workflow**.

---

## Slide 14: Auto-Review Hook

File: `.claude/hooks/auto-review.sh`

```bash
#!/bin/bash
# PostToolUse hook: fires after every Write tool call
# Checks if the written file is in comms/ and logs a review trigger

# Hook receives JSON on stdin with tool details
INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | python3 -c \
  "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name',''))" 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | python3 -c \
  "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null)

if [[ "$TOOL_NAME" == "Write" ]]; then
    if [[ "$FILE_PATH" == *"comms/"* || "$FILE_PATH" == *"announcement"* || "$FILE_PATH" == *"outreach"* ]]; then
        mkdir -p .claude/logs
        echo "$(date): Auto-review triggered for $FILE_PATH" >> .claude/logs/reviews.log
        echo "New communication drafted: $FILE_PATH — comms-reviewer will evaluate."
    fi
fi
```

**Any write to `comms/`** = automatic quality review.

> This is a working example — copy it to `.claude/hooks/auto-review.sh` and `chmod +x` it.

---

## Slide 15: Registering Hooks

File: `.claude/settings.local.json`

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/auto-review.sh"
          }
        ]
      }
    ]
  }
}
```

| Field | Purpose |
|-------|---------|
| `PostToolUse` | Fire after a tool runs |
| `matcher` | Only trigger on `Write` tool |
| `hooks` | Array of hook actions to execute |
| `type` + `command` | Run a shell command |

Hook receives the **tool event as JSON on stdin**.

---

## Slide 16: LIVE DEMO — The Full Loop

Watch it all connect:

```
/plan-event "Python meetup April 2026"
    │
    ▼
/build-schedule
    │
    ▼
schedule-optimizer (subagent auto-invoked)
    │
    ▼
/draft-announcement
    │
    ▼
Write to comms/ ──► hook fires ──► comms-reviewer
    │
    ▼
Scored output: SEND / REVISE / REWRITE
```

**Zero manual review steps. Automated quality.**

---

## Slide 17: MCP — Connecting External Tools

**Model Context Protocol** — standard interface for external tools.

```
Claude Code ──► MCP Server ──► External Service
                                  ├── Eventbrite API
                                  ├── Google Calendar
                                  ├── Slack
                                  └── Database
```

**Recent improvements:**
- **Tool Search** — defers tool definitions until Claude needs them, keeping MCP context low when you connect many servers
- **Channels** (research preview) — MCP servers push messages into your session (Telegram, Discord, webhooks)

For MeetupBot in production, MCP could connect:
- **Eventbrite** — auto-publish events
- **Google Calendar** — check venue availability
- **Slack** — post announcements to channels
- **Notion** — update planning docs

*Aside for today — but the architecture supports it.*

---

## Slide 18: Tips & Gotchas

### Do
- Include **"use proactively"** in subagent descriptions
- Design descriptions to be **self-contained**
- Give subagents **minimal tool sets** (or use `disallowedTools`)
- Set `model:` per task — `haiku` for triage, `sonnet` for reasoning
- Return a **parseable, structured** output (table or JSON)
- Test subagents **in isolation** first
- **Restart your session** after hand-editing agent files

### Don't
- Give subagents tools they don't need
- Assume subagents share context with parent
- Hook every single tool event (performance)
- Make subagents that depend on each other's state
- Skip the one-shot pattern (keep them focused)

---

## Slide 19: BUILD TIME

### Exercise: Specialist Subagents + Auto-Review

**Goal:** Build specialists that outperform the monolith, with automated quality checks.

Tasks:
1. Create `schedule-optimizer` subagent
2. Create `comms-reviewer` subagent
3. Wire up the auto-review hook
4. Run the full loop and compare quality

**Time: ~35 minutes**

Exercise details: `sessions/session-3/EXERCISE.md`

---

## Slide 20: Checkpoint

Before moving on, verify:

- [ ] `schedule-optimizer` subagent detects real conflicts
- [ ] `comms-reviewer` subagent scores and verdicts communications
- [ ] Hook fires automatically on `comms/` writes
- [ ] **Visible quality improvement** over monolith approach

**Raise your hand if you're stuck** — we'll do a group debug.

---

## Slide 21: What's Next — Session 4

### Parallel Agents & Feedback Loops

- **3 competing agents** generate different approaches
- **Specialist evaluators** score each approach
- **Feedback system** picks the best, iterates

The architecture scales: more agents, better results.

---

## Slide 22: Session 3 Recap

Three things to remember:

### 1. Specialists Beat Generalists
Same model, focused context = dramatically better output.

### 2. Hooks Automate Quality
No manual review steps. Code runs when things happen.

### 3. Route Models to Tasks
Right model for the right job. Don't overspend, don't undershoot.

**Next session:** we make the agents compete.
