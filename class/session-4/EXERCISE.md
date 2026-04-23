# Session 4 Exercise: Parallel Subagents & The Feedback Loop

## Goal
Run parallel subagents to generate competing meetup plan variants, evaluate them with your Session 3 specialists, select the winner, and build a post-event feedback system that makes future events better.

## Step 1: Create a Meetup Brief (5 min)

Create `briefs/rag-workshop.md`:

```markdown
# Meetup Brief: RAG Workshop

**Topic:** Building Production RAG Pipelines
**Format:** Hands-on workshop
**Target attendees:** 40
**Duration:** 3 hours (evening, 6-9 PM)
**Audience level:** Intermediate Python developers with basic LLM experience
**Goals:** Attendees leave with a working RAG pipeline they can extend
**Constraints:** Venue must have WiFi and power outlets for all attendees
```

## Step 2: Triage the Brief (5 min)

Before throwing the full pipeline at every request, smart agent systems classify complexity first. Archon's PR review workflow skips heavy agents for trivial changes. We'll do the same — triage the brief to decide how much effort to invest.

```
Read briefs/rag-workshop.md and classify this event brief:

COMPLEXITY TRIAGE:
- Simple (single talk, <20 attendees, no constraints) -> run 1 variant, skip parallel agents
- Medium (workshop/panel, 20-60 attendees, some constraints) -> run 2 variants
- Complex (multi-track, 60+ attendees, hard constraints, multiple speakers) -> run 3 variants

Output the classification and your reasoning. What constraints make this brief non-trivial?
```

**Why triage?** Running 3 parallel subagents is expensive. For a simple "pizza and lightning talks" meetup, one plan is plenty. Triage prevents over-engineering simple events while ensuring complex ones get the full treatment. The brief above should classify as **Medium** or **Complex** — proceed with 3 variants.

## Step 3: Run 3 Parallel Subagents (15 min)

Ask Claude to run 3 competing variants in parallel, each with a different strategy:

```
I need you to generate 3 competing event plans for the brief in briefs/rag-workshop.md.
Run these as 3 parallel subagents, each with a different optimization strategy:

1. "Community-first" — optimize for networking, community building, and beginner accessibility. More breaks, ice-breakers, group exercises.

2. "Deep-dive" — optimize for maximum technical depth. Longer talk slots, advanced content, live coding demos, minimal breaks.

3. "Workshop-lab" — optimize for hands-on learning. Short intros followed by guided exercises, pair programming, mentor stations.

For each variant:
- Read the brief at briefs/rag-workshop.md
- Read data/venues.json and data/speakers.json
- Generate a complete event plan JSON following CLAUDE.md schema
- Generate a schedule
- Draft an announcement email

Save outputs to:
- events/rag-workshop-v1-community.json, schedules/rag-workshop-v1.md, comms/rag-workshop-v1-announcement.md
- events/rag-workshop-v2-deepdive.json, schedules/rag-workshop-v2.md, comms/rag-workshop-v2-announcement.md
- events/rag-workshop-v3-lab.json, schedules/rag-workshop-v3.md, comms/rag-workshop-v3-announcement.md

Run all 3 in parallel using subagents.
```

> **What's happening under the hood:** Claude Code uses git worktrees to give each subagent an isolated copy of your repo. They run simultaneously without stepping on each other's files. You don't need to manage the git branches — Claude handles it.

## Step 4: Adversarial Evaluation (10 min)

Now the evaluators become **adversaries**. Their job is to *break* each variant, not praise it. This is the Generator -> Evaluator pattern used by Archon's adversarial workflows: one agent creates, another tries to find every flaw.

Use your Session 3 subagents to attack each variant:

```
Use the schedule-optimizer agent to evaluate all 3 schedule variants. Be adversarial —
your job is to find every conflict, energy dip, and logistics problem:
- schedules/rag-workshop-v1.md
- schedules/rag-workshop-v2.md
- schedules/rag-workshop-v3.md

Then use the comms-reviewer agent to ruthlessly score all 3 announcements.
No generosity — if something is missing or weak, score it down:
- comms/rag-workshop-v1-announcement.md
- comms/rag-workshop-v2-announcement.md
- comms/rag-workshop-v3-announcement.md
```

Record the scores:

| Variant | Schedule Score | Comms Score | Total |
|---------|---------------|-------------|-------|
| V1 Community | ___/10 | ___/10 | ___/20 |
| V2 Deep-dive | ___/10 | ___/10 | ___/20 |
| V3 Workshop-lab | ___/10 | ___/10 | ___/20 |

**Key insight:** The evaluator agents have `denied_tools: Edit, Write, Bash` from Session 3 — they can critique but not fix. This separation of concerns (generator creates, evaluator judges) prevents the evaluator from silently "fixing" problems instead of surfacing them. If every variant scores above 7/10, your generators are good. If scores are low, your generators need better context — that's a signal to improve CLAUDE.md or your slash commands, not to weaken the evaluators.

**Uncorrelated perspectives:** Notice that the schedule-optimizer and comms-reviewer evaluate from completely different angles — logistics vs. communication quality. Each runs in its own context window with its own focus. This is deliberate. Multiple independent agents reviewing the same artifact catch bugs that any single reviewer misses. If you had time, you could run the *same* evaluation twice in separate sessions and compare — disagreements between runs reveal the weakest spots.

## Step 5: Select the Winner (5 min)

```
Based on the evaluation scores, select the best variant for the RAG Workshop.
Copy the winning files to:
- events/rag-workshop-final.json
- schedules/rag-workshop-final.md
- comms/rag-workshop-final-announcement.md

Explain why this variant won and what elements from the other variants could improve it.
```

**Discussion:** Why did the winner win? Would a different audience or format change the result? This is the key insight — non-deterministic generation + evaluation outperforms a single attempt.

## Step 6: Build the Post-Event System (15 min)

Create the `/post-event` slash command:

```
Create a slash command at .claude/commands/post-event.md that:
1. Takes an event plan file path as $ARGUMENTS
2. Asks for: actual attendance count, what went well, what to improve, speaker feedback, venue feedback
3. Generates a post-event recap including:
   - Summary of the event
   - Attendance vs. estimate comparison
   - Lessons learned
   - Suggestions for next time
   - Draft thank-you email to speakers
   - Draft feedback survey questions
4. Saves the recap to data/past-events/{event-name}-recap.json
5. The recap JSON should include structured fields so future /plan-event calls can learn from it

IMPORTANT: The past-events data must be in a format that /plan-event can read
to improve future event planning. Include fields like: actualAttendees,
feedbackHighlights, improvementAreas, venueRating, formatRating.
```

## Step 7: Close the Feedback Loop — Fresh Context (5 min)

**Important pattern:** When we plan the next event, the agent reads past-event files from disk — it does NOT "remember" the previous event from conversation history. This is deliberate. Archon resets context between every workflow iteration and persists state exclusively through files. Why? LLM memory drifts and hallucinates. Files don't.

Test the full loop — create a mock post-event entry, then plan a new event:

```
/post-event events/rag-workshop-final.json
```

Enter mock feedback (pretend the event happened):
- 35 attendees (estimate was 40)
- WiFi was slow — need venue with better infrastructure
- Workshop exercises were too long, attendees wanted more speaker time
- Great networking session at the end

Now plan a new event and see if the agent uses the feedback:

```
/plan-event "Advanced RAG: Multi-Modal Retrieval"
```

**Check:** Does the new plan account for the lessons learned? Does it suggest a venue with better WiFi? Does it adjust the workshop/talk ratio?

Commit your final system:
```bash
git add -A
git commit -m "feat: complete MeetupBot with parallel variants and feedback loop"
```

## Checkpoint ✓

You should now have:
- [ ] `briefs/rag-workshop.md` meetup brief
- [ ] 3 competing event plan variants generated in parallel
- [ ] All variants evaluated by schedule-optimizer and comms-reviewer
- [ ] Winning variant selected and saved as final
- [ ] `.claude/commands/post-event.md` working slash command
- [ ] `data/past-events/` with at least one recap entry
- [ ] Feedback loop working — new `/plan-event` calls learn from past events

## Bonus Challenges

1. Create a `/compare-variants` command that generates a side-by-side comparison table of multiple event plan variants
2. Add a `post-event-analyzer` subagent that reads all past events and identifies trends (e.g., "workshops consistently get higher attendance than talks")
3. Build a `/plan-series` command that plans a 3-month meetup series with progressive topics, avoiding speaker and venue repetition

## Where to Go Next: Routines & Workflow DAGs

### Routines — Cloud Automations (New!)

Claude Code now has **Routines** — cloud-based automations that run without your laptop. You define a prompt, connect a repo, and set a trigger:

| Trigger Type | Example |
|---|---|
| **Scheduled** | "Every Monday at 9am, check data/past-events/ and suggest this week's meetup topic" |
| **GitHub event** | "When a PR is opened, review the event plan changes" |
| **API call** | "When our RSVP webhook fires, update the attendee estimate" |

Routines are available on Pro (5/day), Max (15/day), and Team/Enterprise (25/day) plans. They're perfect for automating the MeetupBot feedback loop — imagine a Routine that runs after every event, reads the post-event recap, and prepares a draft plan for the next meetup.

### Workflow DAGs

Everything you've built in this course — slash commands, design docs, subagents, hooks, parallel variants, feedback loops — are the building blocks of **workflow DAGs** (Directed Acyclic Graphs). In production agent systems like [Archon](https://github.com/coleam00/archon), these building blocks get composed into declarative YAML pipelines:

```yaml
# What a production MeetupBot workflow could look like
nodes:
  - id: triage
    type: prompt
    model: claude-haiku-4-5
    systemPrompt: "Classify event brief complexity..."

  - id: generate-variants
    type: prompt
    model: claude-sonnet-4-6
    depends_on: [triage]
    when: "triage.output.complexity != 'simple'"
    allowed_tools: [Read, Write, Glob]
    denied_tools: [Bash]

  - id: adversarial-review
    type: prompt
    model: claude-opus-4-7
    depends_on: [generate-variants]
    allowed_tools: [Read, Grep, Glob]
    denied_tools: [Edit, Write, Bash]
    systemPrompt: "Your job is to BREAK what was generated..."

  - id: select-winner
    type: prompt
    depends_on: [adversarial-review]
    when: "adversarial-review.output.passCount > 0"
```

The patterns transfer: **triage -> generate -> adversarially evaluate -> select**. You've done this manually across Sessions 1-4. Workflow DAGs automate the orchestration so it runs the same way every time.

### Claude Agent SDK

If you want to build Claude Code-powered agents programmatically, the **Claude Agent SDK** (formerly Claude Code SDK) is available in Python and TypeScript:

```bash
pip install claude-agent-sdk          # Python
npm install @anthropic-ai/claude-agent-sdk  # TypeScript
```

This lets you embed everything you've learned — subagents, tool permissions, hooks — into your own applications.

## Congratulations!

You've built a complete MeetupBot that:
- Plans events with structured data and venue/speaker matching
- Schedules talks with conflict resolution and energy management
- Communicates with audience-aware announcements and personalized outreach
- Optimizes through specialist subagents (schedule optimizer, comms reviewer)
- Automates quality checks through lifecycle hooks
- Competes by generating parallel variants and selecting the best
- Learns from post-event feedback to improve future planning

These patterns — structured output, context engineering, specialist subagents with scoped permissions, quality-gate hooks, complexity triage, adversarial evaluation, file-based state over LLM memory, and feedback loops — transfer to any agent you build next.

**Current Claude models (April 2026):**
| Model | Best For | Context |
|---|---|---|
| Claude Opus 4.7 | Complex reasoning, long-horizon autonomy | 1M tokens |
| Claude Sonnet 4.6 | Fast, capable general use | 1M tokens |
| Claude Haiku 4.5 | Quick tasks, triage, cheap routing | 200K tokens |
