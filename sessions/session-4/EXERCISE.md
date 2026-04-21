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

Before throwing the full pipeline at every request, smart agent systems classify complexity first. Triage the brief to decide how much effort to invest.

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

> **How parallel subagents work in Claude Code:**
> When you ask Claude to "run 3 parallel subagents," Claude Code uses its built-in Agent tool with `isolation: "worktree"` to give each subagent an isolated copy of your repo via git worktrees. They run simultaneously without file conflicts.
>
> You don't need special syntax — just describe what you want in natural language. Claude Code handles the orchestration:
> - Each subagent gets its own context window (no cross-contamination)
> - Each works in an isolated git worktree (no file conflicts)
> - Results are merged back when all complete
>
> If Claude doesn't automatically parallelize, you can be more explicit:
> ```
> Run these as 3 separate subagents in parallel, each in its own worktree:
> - Subagent 1: [community-first instructions]
> - Subagent 2: [deep-dive instructions]
> - Subagent 3: [workshop-lab instructions]
> ```
>
> **Tip:** You'll see Claude Code mention "launching agent" in the terminal for each variant. They run concurrently — you don't wait for one to finish before the next starts.

> **What's happening under the hood:** Claude Code uses git worktrees to give each subagent an isolated copy of your repo. They run simultaneously without stepping on each other's files. You don't need to manage the git branches — Claude handles it.

## Step 4: Adversarial Evaluation (10 min)

Now the evaluators become **adversaries**. Their job is to *break* each variant, not praise it. This is the Generator -> Evaluator pattern: one agent creates, another tries to find every flaw.

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

**Key insight:** The evaluator agents have `denied_tools: Edit, Write, Bash` from Session 3 — they can critique but not fix. This separation of concerns (generator creates, evaluator judges) prevents the evaluator from silently "fixing" problems instead of surfacing them.

Record the scores:

| Variant | Schedule Score | Comms Score | Total |
|---------|---------------|-------------|-------|
| V1 Community | ___/10 | ___/10 | ___/20 |
| V2 Deep-dive | ___/10 | ___/10 | ___/20 |
| V3 Workshop-lab | ___/10 | ___/10 | ___/20 |

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

**Important pattern:** When we plan the next event, the agent reads past-event files from disk — it does NOT "remember" the previous event from conversation history. This is deliberate. LLM memory drifts and hallucinates. Files don't. Persist state through files, not conversation context.

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

> **Wiring the loop:** For `/plan-event` to actually use past feedback, your plan-event command needs to read from `data/past-events/`. If your `/plan-event` command doesn't already do this, update `.claude/commands/plan-event.md` to include:
> ```
> Before generating the plan, read all files in data/past-events/ for lessons learned
> from previous events. Apply these lessons to your recommendations:
> - Adjust venue suggestions based on past venue ratings and feedback
> - Adjust format and schedule based on past format ratings
> - Account for attendance patterns (actual vs estimated from past events)
> ```
> This is what "closing the loop" means — the output of `/post-event` becomes input for future `/plan-event` calls.

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

## Stuck?

If you're blocked or your output doesn't look right, compare your project against the reference implementation:

```bash
# See what your project should look like after this session
ls -R ../../solution/session-4/

# Compare a specific file
diff your-file.md ../../solution/session-4/equivalent-file.md
```

You can also copy the entire solution to catch up:
```bash
cp -r ../../solution/session-4/* .
cp -r ../../solution/session-4/.claude .
```

## Bonus Challenges

1. Create a `/compare-variants` command that generates a side-by-side comparison table of multiple event plan variants
2. Add a `post-event-analyzer` subagent that reads all past events and identifies trends (e.g., "workshops consistently get higher attendance than talks")
3. Build a `/plan-series` command that plans a 3-month meetup series with progressive topics, avoiding speaker and venue repetition

## Where to Go Next: Workflow DAGs

Everything you've built — slash commands, PRPs, subagents, hooks, parallel variants, feedback loops — are the building blocks of **workflow DAGs** (Directed Acyclic Graphs). In production agent systems, these building blocks get composed into declarative pipelines:

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

## Congratulations!

You've built a complete MeetupBot that:
- **Plans** events with structured data and venue/speaker matching
- **Schedules** talks with conflict resolution and energy management
- **Communicates** with audience-aware announcements and personalized outreach
- **Optimizes** through specialist subagents (schedule optimizer, comms reviewer)
- **Automates** quality checks through lifecycle hooks
- **Competes** by generating parallel variants and selecting the best
- **Learns** from post-event feedback to improve future planning

These patterns — structured output, context engineering, specialist subagents, automated hooks, parallel generation, and feedback loops — transfer to any agent you build next.

## What's New in Claude Code (April 2026)

| Feature | What It Does |
|---|---|
| **Routines** | Cloud automations — schedule prompts, react to GitHub events, or trigger via API. Automate the feedback loop! |
| **Claude Agent SDK** | Embed Claude Code agents in your own apps. `pip install claude-agent-sdk` (Python) or `npm install @anthropic-ai/claude-agent-sdk` (TypeScript) |
| **Auto Mode** | Classifier-based permissions — safe actions auto-approved, risky ones blocked |
| **Conditional hooks** | Target hooks to specific actions with `if` field |
| **Opus 4.7** | Latest model — 1M context, best for complex reasoning |
| **Claude Code surfaces** | CLI, Desktop (Mac/Windows), Web (claude.ai/code), VS Code, JetBrains |
