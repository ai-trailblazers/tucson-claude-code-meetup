# Session 2 Exercise: Context Engineering + Comms & Scheduling

## Goal
Use context engineering to design and build a complete comms and scheduling system. You'll brainstorm the design interactively, generate an implementation plan, and execute it in batches — experiencing the difference between "clever prompts" and "complete blueprints."

> **Time budget:** Steps 1-2 are setup (15 min). Steps 3-5 are the core build (35 min). Step 6 is testing (10 min). If time is tight, `/execute-plan` can be stopped between batches — the remaining commands can be created manually with simple prompts.

## Step 1: Understand Context Engineering (10 min)

**The core idea:** Most agent failures come from missing context, not model limitations. Context engineering means giving the AI a complete blueprint, not a clever prompt.

| Prompt Engineering | Context Engineering |
|---|---|
| "Write me a meetup announcement" | Here's the event plan JSON, the audience profile, the tone rules, 3 example announcements, and the email template — now write the announcement |
| Clever wording | Complete system |
| Sticky note | Full screenplay |

**Try the difference yourself** — in Claude Code, try these two prompts and compare the output quality:

Prompt 1 (no context):
```
Write an announcement email for a RAG pipelines meetup
```

Prompt 2 (with context):
```
Read the event plan at events/building-rag-pipelines.json, read data/speakers.json
for speaker bios, and read examples/sample-event-plan.json for the expected format.
Now write an announcement email targeting intermediate Python developers.
Keep it under 200 words, include the date, venue, and speaker highlights.
```

## Step 2: Install the Superpowers Plugin (5 min)

The superpowers plugin adds a powerful design-to-implementation workflow to Claude Code: interactive brainstorming, structured planning, and batch execution with review checkpoints.

```bash
claude plugin add superpowers
```

This gives you three new slash commands:
- `/brainstorm` — interactive Socratic design (asks one question at a time)
- `/write-plan` — generates a detailed implementation plan with bite-sized tasks
- `/execute-plan` — executes the plan in batches, stopping for your review between batches

> **Why a plugin?** Plugins are how Claude Code's capabilities grow beyond the defaults. The superpowers plugin is a community-maintained set of development workflows. Installing it teaches a real production pattern — extending your agent with composable capabilities from a marketplace.

## Step 3: Brainstorm the Design (15 min)

Start the interactive brainstorming session:

```
/brainstorm
```

When it asks what you're building, describe the comms and scheduling system:

```
Build a communications and scheduling system for MeetupBot. I need:
- A /build-schedule command that generates event schedules with time slots and breaks,
  using speaker availability from data/speakers.json
- A /draft-announcement command that creates audience-tailored announcement emails
- A /draft-speaker-outreach command that drafts personalized speaker invitation emails
- All commands should consume the structured event plan JSON from /plan-event output
```

**Let the brainstorm guide you.** It will:
1. Ask clarifying questions one at a time (answer them!)
2. Propose 2-3 approaches with trade-offs
3. Present the design in sections, checking each one with you
4. Save the validated design to `docs/plans/`

**Key things to mention when asked:**
- Schedules need breaks every 60-90 minutes
- Speaker availability is in `data/speakers.json`
- The event plan JSON schema is in CLAUDE.md
- Announcements should hook the audience in the first sentence
- Speaker outreach should reference their specific expertise
- Look at `.claude/commands/plan-event.md` for the existing command pattern
- Look at `examples/sample-event-plan.json` for the output format

> **This is context engineering in action.** The brainstorm session builds up context piece by piece through dialogue, rather than hoping you write the perfect spec on the first try. Each question it asks prevents a misunderstanding that would have caused a failure later.

## Step 4: Generate the Implementation Plan (5 min)

Once the design is validated, generate the plan:

```
/write-plan
```

Claude will:
1. Read your brainstorm design document
2. Analyze your existing codebase (CLAUDE.md, existing commands, data files)
3. Create a detailed implementation plan with bite-sized tasks
4. Save it to `docs/plans/`

**Review the plan before executing.** Check:
- Does it create all three commands (`build-schedule`, `draft-announcement`, `draft-speaker-outreach`)?
- Does it understand the data flow (event plan JSON -> schedule, event plan JSON -> emails)?
- Did it pick up the speaker availability constraint?
- Are the tasks ordered correctly?

## Step 5: Execute the Plan (15 min)

Run:
```
/execute-plan
```

Claude will:
1. Read the implementation plan
2. Execute the first batch of tasks (usually 3)
3. **Stop and show you what it built**
4. Wait for your feedback before continuing

**This is the key difference from one-shot execution.** You review between batches. If something's off, you say so and it adjusts. If it looks good, say "continue" and it executes the next batch.

By the end, you should have:
- `.claude/commands/build-schedule.md`
- `.claude/commands/draft-announcement.md`
- `.claude/commands/draft-speaker-outreach.md`

## Step 6: Test the Full Pipeline (10 min)

Run the commands in sequence, each consuming data from the previous step:

```
/plan-event "Prompt Engineering vs Context Engineering"
```

Then use the generated event plan:
```
/build-schedule events/prompt-engineering-vs-context-engineering.json
```

```
/draft-announcement events/prompt-engineering-vs-context-engineering.json
```

```
/draft-speaker-outreach events/prompt-engineering-vs-context-engineering.json
```

**Check the outputs:**
- Does the schedule avoid speaker conflicts?
- Does the announcement reference the right speakers and venue?
- Are the speaker outreach emails personalized?

Commit your work:
```bash
git add -A
git commit -m "feat: comms and scheduling system"
```

## Checkpoint ✓

You should now have:
- [ ] Superpowers plugin installed
- [ ] Design document in `docs/plans/`
- [ ] Implementation plan with bite-sized tasks
- [ ] `.claude/commands/build-schedule.md` working command
- [ ] `.claude/commands/draft-announcement.md` working command
- [ ] `.claude/commands/draft-speaker-outreach.md` working command
- [ ] At least 2 event plans with matching schedules and announcements
- [ ] All commands consume structured JSON, not freeform input

## Bonus Challenges

1. Run `/brainstorm` again to design a `/draft-followup` command for post-RSVP confirmation emails, then plan and execute it
2. Add more examples to `examples/` — sample announcement emails from real meetups — and re-run `/draft-announcement` to see if quality improves
3. Build a `/validate-schedule` command that checks a schedule for conflicts, missing breaks, and overtime
