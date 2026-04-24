# Session 4: Parallel Subagents & The Feedback Loop

---

## Slide 1

# Building AI Agents with Claude Code

### Session 4: Parallel Agents & The Feedback Loop

*Generate multiple variants, score them, pick the best one*

---

## Slide 2: Recap -- The Full System So Far

What we've built across 3 sessions:

- `/plan-event` -- structured event planning
- `/build-schedule` -- detailed schedule generation
- `/draft-announcement` -- communication drafts
- `/draft-speaker-outreach` -- personalized speaker emails
- `schedule-optimizer` -- subagent specialist
- `comms-reviewer` -- communication quality subagent
- Auto-review hook -- triggered on comms writes

**Today:** parallel generation + learning from results

---

## Slide 3: Today's Goal

**Competing variants + a self-improving feedback loop**

You will learn:

- **Parallel subagents** -- run multiple agents simultaneously
- **Evaluation-driven selection** -- let specialists pick the winner
- **Git worktrees** -- isolated workspaces for each variant
- **Feedback loops** -- agents that learn from past results

---

## Slide 4: The Non-Determinism Problem

Ask the same question 3 times:

```
"Plan a meetup about RAG pipelines"
→ Response A (community-focused)
→ Response B (deep technical)
→ Response C (hands-on workshop)
```

Usually this is a **problem**.

But what if we do it **intentionally**?

- Generate 3 variants on purpose
- Evaluate each objectively
- Pick the best automatically

**Non-determinism + evaluation = better than any single attempt**

---

## Slide 5: Parallel Subagents

```
                    ┌─────────────┐
                    │  Main Agent  │
                    └──────┬──────┘
               ┌───────────┼───────────┐
               v           v           v
        ┌──────────┐ ┌──────────┐ ┌──────────┐
        │ V1:      │ │ V2:      │ │ V3:      │
        │ Network  │ │ Tech     │ │ Hands-on │
        │ Focus    │ │ Depth    │ │ Workshop │
        └──────────┘ └──────────┘ └──────────┘
               │           │           │
               v           v           v
        Event Plan    Event Plan    Event Plan
        + Schedule    + Schedule    + Schedule
        + Announce    + Announce    + Announce
               │           │           │
               └───────────┼───────────┘
                           v
                  ┌────────────────┐
                  │  Specialists   │
                  │  Score Each    │
                  └────────┬───────┘
                           v
                  ┌────────────────┐
                  │ Winner Selected│
                  └────────────────┘
```

---

## Slide 6: How It Works -- Under the Hood

**Git worktrees provide isolation**

```
meetup-agent/        ← main workspace
meetup-agent-v1/     ← variant 1 workspace
meetup-agent-v2/     ← variant 2 workspace
meetup-agent-v3/     ← variant 3 workspace
```

- Each subagent works in its own copy of the repo
- No conflicts between variants
- Claude handles the orchestration

---

## Slide 7: Git Worktrees -- The Concept

> Aside for the curious

A **worktree** is a separate working directory linked to the same Git repo.

```bash
git worktree add ../meetup-agent-v1 -b variant-1
git worktree add ../meetup-agent-v2 -b variant-2
git worktree add ../meetup-agent-v3 -b variant-3
```

Claude Code's Agent tool uses `isolation: "worktree"` automatically.

**You don't need special syntax** — just describe what you want:

```
Run 3 parallel subagents for the RAG Workshop brief.
Each in its own worktree. V1: community-first. V2: deep-dive. V3: workshop-lab.
```

Claude handles the worktree creation, parallel execution, and result merging.

Same repo. Separate branches. Parallel work.

---

## Slide 8: LIVE DEMO -- Parallel Generation

**3 variants for "RAG Workshop"**

| Variant | Strategy | Focus |
|---------|----------|-------|
| V1 | Community-first | Networking, demos, group discussion |
| V2 | Deep-dive | Architecture, internals, advanced patterns |
| V3 | Workshop-lab | Hands-on coding, build a RAG pipeline live |

Watch all 3 run **simultaneously**.

---

## Slide 9: Evaluation -- Reusing Your Specialists

Remember our subagents from Session 3?

| Specialist | What It Scores |
|---|---|
| `schedule-optimizer` | Schedule quality, time allocation, flow |
| `comms-reviewer` | Announcement clarity, tone, completeness |

**Build once, reuse everywhere.**

Each specialist scores each variant on the same criteria.

---

## Slide 10: LIVE DEMO -- Scoring Variants

**Evaluation Results:**

| Criteria | V1 | V2 | V3 |
|---|---|---|---|
| Schedule Quality | 7/10 | 8/10 | 9/10 |
| Announcement Clarity | 9/10 | 6/10 | 8/10 |
| Overall | 8.0 | 7.0 | 8.5 |

Which won? **Why?**

The scores tell a story about tradeoffs.

---

## Slide 11: Why This Works

**Single attempt:**
- Hope it's good
- Re-run if it isn't
- No basis for comparison

**Parallel + evaluation:**
- 3 different strategies explored
- Objective scoring criteria
- Combinable elements (best schedule + best announcement)
- Reproducible evaluation criteria

This is how production AI systems work.

---

## Slide 12: The Missing Piece -- Learning

Our agent plans **great** events. But it doesn't remember what happened.

- Estimated 40 attendees... but 35 showed up
- WiFi was slow at the venue
- Hands-on exercises ran 15 minutes too long
- Lightning talks were the highlight

**Without feedback:** same mistakes, every time.

---

## Slide 13: The Feedback Loop

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Plan Event  │ ──> │  Run Event   │ ──> │   Capture    │
│  /plan-event │     │  (real world)│     │   Feedback   │
└──────────────┘     └──────────────┘     └──────┬───────┘
       ^                                         │
       │                                         v
       │                                  ┌──────────────┐
       │                                  │  Store in     │
       └──────────────────────────────────│  past-events/ │
            Next /plan-event reads them   └──────────────┘
```

**The agent gets smarter over time.**

---

## Slide 14: Post-Event Data

```json
{
  "event": "RAG Pipeline Workshop",
  "date": "2026-03-15",
  "venue": "Maker Space Downtown",
  "actualAttendees": 35,
  "estimatedAttendees": 40,
  "venueRating": 3,
  "formatRating": 4.2,
  "feedbackHighlights": [
    "Lightning talks were the best part",
    "Loved the hands-on exercises"
  ],
  "improvementAreas": [
    "WiFi too slow for live coding",
    "Exercises ran 15 min over time"
  ],
  "lessonsLearned": [
    "Cap exercises at 20 min with hard cutoff",
    "Test venue WiFi before committing",
    "Lightning talks drive engagement"
  ]
}
```

---

## Slide 15: How /plan-event Uses Feedback

**Before (no feedback):**
```
Venue: Maker Space Downtown
  - Good location, affordable
Exercises: 30 minutes each
```

**After (with past-events/ data):**
```
Venue: Tech Hub East (Maker Space WiFi rated 3/10)
  - Confirmed 100Mbps+ connection
Exercises: 20 minutes max (past events ran over)
  - Added hard cutoff timers
Lightning talks: Added 15-min block (highest-rated segment)
```

**Wiring it up:** Update `/plan-event` to read `data/past-events/`:

```markdown
# In .claude/commands/plan-event.md, add:
Before generating the plan, read all files in data/past-events/
for lessons learned. Apply them to venue, format, and schedule.
```

One line in your slash command closes the loop.

---

## Slide 16: LIVE DEMO -- The Full Loop

1. Create mock feedback from a past event
2. Run `/plan-event` for a new topic
3. Watch the agent reference past feedback
4. See recommendations change based on real data

---

## Slide 17: The Complete MeetupBot

| Session | What We Built |
|---|---|
| Session 1 | Plans events with structured output |
| Session 2 | Composable pipeline of commands |
| Session 3 | Quality automation with specialists |
| Session 4 | Self-improvement through feedback |

**Final tally:**
- 5 slash commands
- 2 subagents
- 1 hook
- 1 feedback loop

---

## Slide 18: Production Decision Framework

| Pattern | When to Use |
|---|---|
| `CLAUDE.md` | Global rules, style, constraints |
| Slash commands | Repeatable, composable tasks |
| Subagents | Domain-specific evaluation or generation |
| Hooks | Automatic quality gates on events |
| `examples/` | Few-shot learning, output formatting |
| PRPs | Complex multi-step plans |

---

## Slide 19: Transferable Patterns

| MeetupBot Pattern | General Pattern |
|---|---|
| Event JSON output | Structured output for any domain |
| Composable commands | Task pipelines |
| schedule-optimizer / comms-reviewer | Domain specialist agents |
| Auto-review hook | Quality gates |
| 3 competing variants | Non-determinism + evaluation |
| past-events/ feedback | Learning loops |

**These patterns work for any agent you build.**

---

## Slide 20: BUILD TIME

**Exercise:** `sessions/session-4/EXERCISE.md`

**Goal:** Build competing variants, evaluate them, and close the feedback loop.

**Time:** ~35 minutes

**What you'll build:**
- 3 parallel variants with different strategies
- Evaluation using your existing subagents
- Winner selection
- `/post-event` command for capturing feedback
- Feedback integration into `/plan-event`

---

## Slide 21: Checkpoint

By now you should have:

- [ ] 3 variants generated in parallel
- [ ] Variants evaluated by your subagents
- [ ] Winner selected based on scores
- [ ] `/post-event` command working
- [ ] Past feedback influencing new plans

---

## Slide 22: Where to Go Next — Routines & Beyond

### Routines (new!) — Cloud automations without your laptop

| Trigger | Example |
|---|---|
| **Scheduled** | "Every Monday, suggest this week's meetup topic" |
| **GitHub event** | "When a PR opens, review event plan changes" |
| **API call** | "When RSVP webhook fires, update attendee estimate" |

Available on Pro (5/day), Max (15/day), Team/Enterprise (25/day).

### Claude Agent SDK — embed agents in your apps

```bash
pip install claude-agent-sdk          # Python
npm install @anthropic-ai/claude-agent-sdk  # TypeScript
```

### Extend MeetupBot:
- MCP servers for Eventbrite, Google Calendar, Slack
- More specialist subagents (budget-optimizer, sponsor-outreach)
- **Routines** to automate the feedback loop on a schedule
- **Agent SDK** to embed MeetupBot in your own tools

---

## Slide 22b: Current Claude Models (April 2026)

| Model | Best For | Context |
|---|---|---|
| **Opus 4.7** | Complex reasoning, long autonomy | 1M tokens |
| **Sonnet 4.6** | Fast, capable general use | 1M tokens |
| **Haiku 4.5** | Quick tasks, triage, routing | 200K tokens |

**Claude Code surfaces:** CLI, Desktop (Mac/Windows), Web (claude.ai/code), VS Code, JetBrains

---

## Slide 23: Course Recap

| Session | Key Lesson |
|---|---|
| Session 1 | CLAUDE.md rules shape agent behavior |
| Session 2 | Complete context files beat clever one-off prompts |
| Session 3 | Focused agents per task beat one agent doing everything |
| Session 4 | Multiple variants + scoring beat hoping the first attempt is good |

**The constant across all 4 sessions:**

Same model. What changed was the context, the structure, and the feedback.

---

## Slide 24: Thank You

**Resources:**
- [Claude Code Docs](https://code.claude.com/docs)
- [Claude Agent SDK](https://code.claude.com/docs/en/agent-sdk)
- [ngrok AI Gateway](https://ngrok.com/docs/ai-gateway/)
- [Context Engineering Best Practices](https://www.philschmid.de/context-engineering)
- [Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)
- Course Repo: [github.com/nickyeager/tucson-claude-code-meetup](https://github.com/nickyeager/tucson-claude-code-meetup)

**Questions?**

Thank you for building with us.
