# Session 2 Exercise: Context Engineering + Comms & Scheduling

## Goal
Write an INITIAL.md for the comms and scheduling system, generate a PRP from it, execute the PRP, and watch Claude Code build the entire system from a blueprint.

## Step 1: Understand Context Engineering (10 min)

**The core idea:** Most agent failures aren't model failures — they're context failures. Context engineering means giving the AI a complete blueprint, not a clever prompt.

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

> **Template available:** This repo includes an INITIAL.md template at `templates/INITIAL.md` and a filled-out example at `templates/INITIAL_EXAMPLE.md`. You can reference these for the expected structure, but writing your own from scratch is part of the learning. The four sections are:
> - **FEATURE:** What to build (be specific about functionality)
> - **EXAMPLES:** Which files to learn from (point to specific paths)
> - **DOCUMENTATION:** Schemas, constraints, API docs
> - **OTHER CONSIDERATIONS:** Edge cases, gotchas, things AI commonly misses

## Step 2: Write Your INITIAL.md (15 min)

Create `INITIAL.md` in your project root:

```markdown
## FEATURE:
Build a communications and scheduling system for MeetupBot. The system should:
- Generate event schedules that fit talks into time slots with breaks, using speaker
  availability from data/speakers.json
- Draft announcement emails tailored to the target audience from the event plan
- Draft personalized speaker outreach emails referencing their topics and past talks
- All commands should consume the structured event plan JSON from /plan-event output

## EXAMPLES:
- Event plan format: see examples/sample-event-plan.json
- Speaker data: see data/speakers.json (note the availability field)
- Venue data: see data/venues.json (note the capacity and amenities fields)
- Existing command pattern: see .claude/commands/plan-event.md for how slash commands are structured

## DOCUMENTATION:
- Event plan JSON schema is defined in CLAUDE.md
- Schedules should account for: talk duration, speaker availability, break intervals (every 90 min), setup/teardown time
- Announcement emails should include: event name, date, venue, speaker highlights, RSVP link placeholder, target audience hook
- Speaker outreach should include: personalized topic reference, event description, logistics, ask

## OTHER CONSIDERATIONS:
- IMPORTANT: All slash commands must read the event plan JSON as input, not ask the user to retype details
- Schedule must validate that no speaker is double-booked
- Announcements should match the tone defined in CLAUDE.md
- Use $ARGUMENTS in slash commands for the event plan file path
- The /build-schedule command should output a markdown table AND a JSON file
```

> **Where does `/generate-prp` come from?** It's a custom slash command defined in `.claude/commands/generate-prp.md`. You can find a ready-made version in the course repo's `templates/.claude/commands/` folder. Copy it into your project's `.claude/commands/` directory before running Step 3:
> ```bash
> mkdir -p .claude/commands
> cp /path/to/course-repo/templates/.claude/commands/generate-prp.md .claude/commands/
> cp /path/to/course-repo/templates/.claude/commands/execute-prp.md .claude/commands/
> ```
> Replace `/path/to/course-repo/` with the actual path where you cloned the course materials.
> These commands tell Claude how to research your codebase, generate implementation blueprints, and execute them with validation gates.

## Step 3: Generate the PRP (10 min)

Run in Claude Code:
```
/generate-prp INITIAL.md
```

Watch Claude:
1. Read your INITIAL.md
2. Analyze your existing codebase (CLAUDE.md, existing commands, data files)
3. Research patterns from your examples/ folder
4. Create a comprehensive PRP at `PRPs/meetup-comms.md`

**Open `PRPs/meetup-comms.md` and review it:**
- Does it understand the data flow (event plan → schedule, event plan → emails)?
- Did it pick up the speaker availability constraint?
- Are there validation steps?

## Step 4: Execute the PRP (15 min)

Run:
```
/execute-prp PRPs/meetup-comms.md
```

Claude will:
1. Create `.claude/commands/build-schedule.md`
2. Create `.claude/commands/draft-announcement.md`
3. Create `.claude/commands/draft-speaker-outreach.md`
4. Validate the commands work with existing event plan data
5. Run its own tests

## Step 5: Test the Full Pipeline (10 min)

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
git commit -m "feat: comms and scheduling system via PRP"
```

## Checkpoint ✓

You should now have:
- [ ] INITIAL.md with complete feature request
- [ ] `PRPs/meetup-comms.md` generated PRP
- [ ] `.claude/commands/build-schedule.md` working command
- [ ] `.claude/commands/draft-announcement.md` working command
- [ ] `.claude/commands/draft-speaker-outreach.md` working command
- [ ] At least 2 event plans with matching schedules and announcements
- [ ] All commands consume structured JSON, not freeform input

## When the PRP or generated commands are wrong

Most failures are catchable at review time. Diagnose at the right level — don't start over.

| Symptom | How to spot it | How to fix |
|---|---|---|
| PRP missed a constraint from your INITIAL.md | Open `PRPs/meetup-comms.md`, search for the keyword from your OTHER CONSIDERATIONS — it's not there | Add a step or risk to the PRP that addresses it. Save. Re-run `/execute-prp`. |
| Generated command hardcodes a value instead of using `$ARGUMENTS` | Open the new command file — paths or topics are baked in instead of parameterized | Edit the command directly, OR fix the PRP's pattern reference (e.g., "follow the `$ARGUMENTS` pattern from `plan-event.md`") and re-execute |
| Output doesn't match the schema in `CLAUDE.md` | Run the command — JSON keys don't match, or fields are missing | Tighten the schema rules in `CLAUDE.md` (the source of truth). Every future command benefits. |
| `/execute-prp` left files half-done (some commands missing) | `ls .claude/commands/` shows only some of the files the PRP described | Re-run `/execute-prp` on the same PRP. Existing files are read and respected — missing ones get created. |
| Schedule has speaker double-booked or missing breaks | Run `/build-schedule`, scan output — same speaker id appears in overlapping slots, or 90+ min of content with no break | Add explicit validation to `CLAUDE.md` Schedule Constraints. Re-run the command. |
| Announcement tone feels off | Read the draft against your CLAUDE.md tone rules | Tone rules are too vague — make them specific (vocabulary, length, opening style), or add a real announcement to `examples/`. |

**The leverage points are the PRP and `CLAUDE.md`.** Generated command files are downstream artifacts. Fix upstream, regenerate downstream.

If you've made a hand-edit to a generated command that you want to keep, mirror the change back into the PRP — otherwise a future re-execute will overwrite it.

## Stuck?

If you're blocked or your output doesn't look right, compare your project against the reference implementation:

In the course repo, the `solution/session-2/` directory has a complete reference implementation. Compare your files against it:

```bash
# See what your project should look like after this session
ls -R /path/to/course-repo/solution/session-2/

# Compare a specific file (adjust paths to your setup)
diff INITIAL.md /path/to/course-repo/solution/session-2/INITIAL.md
```

You can also copy the entire solution to catch up:
```bash
cp -r /path/to/course-repo/solution/session-2/* .
cp -r /path/to/course-repo/solution/session-2/.claude .
```

> Replace `/path/to/course-repo/` with the actual path where you cloned the course materials.

## Bonus Challenges

1. Edit the PRP to add a `/draft-followup` command for post-RSVP confirmation emails, then re-execute
2. Add more examples to `examples/` — sample announcement emails from real meetups — and regenerate the PRP to see if quality improves
3. Build a `/validate-schedule` command that checks a schedule for conflicts, missing breaks, and overtime
