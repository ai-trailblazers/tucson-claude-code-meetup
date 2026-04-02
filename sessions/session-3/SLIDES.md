# Session 3: Subagents & Hooks

---

## Slide 1

# Building AI Agents with Claude Code

### Session 3: Subagents & Hooks
**Specialists Beat Generalists**

> "One agent doing everything = mediocre at everything"

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
description: Analyzes event schedules for conflicts,
  optimizes time slots, and balances topic distribution.
tools:
  - Read
  - Glob
---

# Schedule Optimizer Agent

## Instructions
You are a schedule optimization specialist.
Analyze the provided schedule for conflicts, gaps,
and topic clustering issues.

## Input
- Schedule JSON from /build-schedule output

## Output Format
Return a JSON object with:
- conflicts: array of detected conflicts
- suggestions: array of optimizations
- optimized_schedule: the improved schedule

## Rules
- Never modify files directly
- Flag conflicts, don't silently resolve them
- Preserve speaker preferences when possible
```

---

## Slide 8: Key Subagent Concepts

| Concept | Detail |
|---------|--------|
| **Own context window** | Fresh context, no bleed from parent |
| **Limited tools** | Only what it needs — `Read`, `Glob`, not `Write` |
| **"Proactively" keyword** | In description: tells Claude to auto-invoke |
| **One-shot design** | Does its job, returns result, exits |
| **Structured output** | JSON contract for reliable handoff |

```yaml
description: Proactively analyzes schedules for conflicts
  and optimization opportunities.
```

The word **"Proactively"** = Claude will invoke this agent without being asked.

---

## Slide 9: LIVE DEMO — Schedule Optimizer

### Build it. Test it.

```bash
# Create the subagent
mkdir -p .claude/agents

# Test it
claude "Use schedule-optimizer agent to optimize
the Python meetup schedule for next month"
```

Compare output to the **monolith attempt** from Slide 4.

**What to watch for:**
- Specific conflict detection
- Concrete time-slot suggestions
- Structured, actionable output

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

## Slide 12: Model Routing with ngrok

Route the **right model** to the **right task**:

| Task | Model | Why |
|------|-------|-----|
| Drafting email copy | `gpt-4o-mini` | Fast, cheap, good at prose |
| Schedule optimization | `claude-sonnet` | Strong at structured reasoning |
| Quality review | `claude-sonnet` | Nuanced evaluation |
| Simple formatting | `gpt-4o-mini` | Don't overspend on easy tasks |

```json
{
  "model": "ngrok/auto",
  "routing": "let the gateway choose"
}
```

ngrok AI Gateway handles routing — you set the rules.

---

## Slide 13: Hooks — Lifecycle Automation

**Hooks** = code that runs when things happen in Claude Code.

| Hook Event | When It Fires |
|-----------|--------------|
| `PreToolUse` | Before a tool executes |
| `PostToolUse` | After a tool completes |
| `UserPromptSubmit` | When user sends a message |
| `Stop` | When agent finishes its turn |

Think of hooks as **CI/CD for your agent workflow**.

---

## Slide 14: Auto-Review Hook

File: `.claude/hooks/auto-review.sh`

```bash
#!/bin/bash
# Auto-review hook: triggers comms-reviewer
# when files are written to the comms/ folder

# Read the hook event from stdin
EVENT=$(cat -)
TOOL_NAME=$(echo "$EVENT" | jq -r '.tool_name')
FILE_PATH=$(echo "$EVENT" | jq -r '.tool_input.file_path // empty')

# Check if Write tool hit the comms/ folder
if [ "$TOOL_NAME" = "Write" ] && [[ "$FILE_PATH" == *comms/* ]]; then
    echo "Auto-review triggered for: $FILE_PATH"
    echo "Routing to comms-reviewer agent..."
fi
```

**Any write to `comms/`** = automatic quality review.

---

## Slide 15: Registering Hooks

File: `.claude/settings.local.json`

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "command": ".claude/hooks/auto-review.sh"
      }
    ]
  }
}
```

| Field | Purpose |
|-------|---------|
| `PostToolUse` | Fire after a tool runs |
| `matcher` | Only trigger on `Write` tool |
| `command` | Script to execute |

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

For MeetupBot in production, MCP could connect:
- **Eventbrite** — auto-publish events
- **Google Calendar** — check venue availability
- **Slack** — post announcements to channels
- **Notion** — update planning docs

*Aside for today — but the architecture supports it.*

---

## Slide 18: Tips & Gotchas

### Do
- Use **"Proactively"** in subagent descriptions
- Design descriptions to be **self-contained**
- Give subagents **minimal tool sets**
- Return **structured JSON** from subagents
- Test subagents **in isolation** first

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

Exercise details: `class/session-3/EXERCISE.md`

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
