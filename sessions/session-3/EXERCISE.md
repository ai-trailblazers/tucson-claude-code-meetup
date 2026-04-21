# Session 3 Exercise: Subagents & Hooks — Specialist Agents

## Goal
Break the monolithic agent into specialists — a schedule optimizer and a comms reviewer — then wire hooks to automate quality checks. Experience why orchestrated specialists beat one-agent-does-everything.

## Step 1: Experience the Problem (10 min)

Before building subagents, see why they're needed. Try this all-in-one prompt:

```
Read events/prompt-engineering-vs-context-engineering.json.
Now do ALL of the following in one response:
1. Optimize the schedule to maximize networking time
2. Rewrite the announcement email to be more engaging
3. Review the speaker outreach emails for tone issues
4. Suggest a better venue based on the attendee count
```

**Notice the output quality.** It tries to do everything and does nothing well. The context is overloaded — scheduling constraints compete with email tone feedback.

Now let's fix this with specialists.

## Step 2: Build the Schedule Optimizer Subagent (15 min)

Create `.claude/agents/schedule-optimizer.md`:

```markdown
---
name: schedule-optimizer
description: "Schedule optimization specialist. Proactively optimizes any meetup schedule for speaker conflicts, break intervals, and audience energy. Reads event plans and speaker data to produce conflict-free schedules with reasoning."
tools: Read, Grep, Glob
initialPrompt: "Read the event plan and speaker data, then produce a schedule optimization report."
---

You are a meetup schedule optimization specialist.

When given an event plan, you optimize the schedule by:

1. **Conflict check**: Verify no speaker is double-booked
2. **Energy management**: Place engaging talks after breaks, lighter content before breaks
3. **Break intervals**: Ensure a break every 60-90 minutes
4. **Setup/teardown**: Add 15 min buffer at start and end
5. **Networking**: Place networking slots strategically (after talks, before closing)

## Input
- Event plan JSON file path
- data/speakers.json for speaker availability
- data/venues.json for room constraints

## Output Format

```
SCHEDULE OPTIMIZATION REPORT
============================

EVENT: {event name}
DURATION: {total hours}

OPTIMIZED SCHEDULE:
| Time | Slot | Speaker | Notes |
|------|------|---------|-------|
| ... | ... | ... | ... |

CHANGES MADE:
- {what was changed and why}

CONFLICTS RESOLVED: {count}
WARNINGS: {any remaining issues}
```

## Rules
- Never exceed the venue's capacity
- Always check speaker availability before assigning slots
- If a conflict can't be resolved, flag it clearly — don't silently drop a speaker
- Prefer 30-min talk slots and 15-min breaks unless the event format specifies otherwise
```

Test it manually:
```
Use the schedule-optimizer agent to optimize the schedule for events/prompt-engineering-vs-context-engineering.json
```

## Step 3: Build the Comms Reviewer Subagent (10 min)

Create `.claude/agents/comms-reviewer.md`:

```markdown
---
name: comms-reviewer
description: "Communications quality reviewer. Proactively reviews any drafted email or announcement for tone, completeness, and missing information. Scores 1-10 and suggests specific improvements."
tools: Read, Grep, Glob
initialPrompt: "Read the drafted communication and produce a quality review with a score and specific suggestions."
---

You are a communications quality reviewer for AI developer meetup announcements.

When given a drafted email or announcement, evaluate it on:

1. **Completeness** (1-3): Does it include date, time, venue, speakers, topic, RSVP link?
2. **Tone** (1-3): Is it engaging for developers without being cringey or corporate?
3. **Clarity** (1-2): Can someone skim it in 30 seconds and know what, when, where?
4. **Call to Action** (1-2): Is there a clear next step (RSVP, share, submit a talk)?

## Output Format

```
COMMS REVIEW
============

PIECE: {what was reviewed}
SCORE: {total}/10

BREAKDOWN:
- Completeness: {score}/3 — {reason}
- Tone: {score}/3 — {reason}
- Clarity: {score}/2 — {reason}
- Call to Action: {score}/2 — {reason}

VERDICT: {SEND if ≥7, REVISE if 5-6, REWRITE if <5}
SUGGESTIONS:
- {specific improvement 1}
- {specific improvement 2}
```

## Rules
- Be honest — vague praise helps no one
- Suggest specific rewrites for weak sections, not just "make it better"
- Developer audiences hate: buzzword salad, excessive emojis, "synergy"-type language
- Good developer comms are: direct, informative, slightly witty, respectful of time
```

Test it:
```
Use the comms-reviewer agent to review the announcement for events/prompt-engineering-vs-context-engineering.json
```

## Step 4: Wire the Auto-Review Hook (15 min)

Create `.claude/hooks/auto-review.sh`:

> **What is this?** This is a PostToolUse hook — a shell script that Claude Code runs automatically every time Claude uses the Write tool. It checks if the file being written is in the `comms/` directory, and if so, logs a review trigger. The hook reads JSON from stdin containing the tool name and file path.

```bash
#!/bin/bash
# Auto-review any drafted communications

# Read hook input from stdin
INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name',''))" 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null)

# Only trigger for Write tool on comms/ or when file contains "announcement" or "outreach"
if [[ "$TOOL_NAME" == "Write" ]]; then
    if [[ "$FILE_PATH" == *"comms/"* || "$FILE_PATH" == *"announcement"* || "$FILE_PATH" == *"outreach"* ]]; then
        mkdir -p .claude/logs
        echo "$(date): Auto-review triggered for $FILE_PATH" >> .claude/logs/reviews.log
        echo "📬 New communication drafted: $FILE_PATH — comms-reviewer will evaluate quality."
    fi
fi
```

Make it executable:
```bash
chmod +x .claude/hooks/auto-review.sh
```

> **How hooks work:** Claude Code supports 4 lifecycle events:
> - `PreToolUse` — runs before Claude uses a tool (can block it)
> - `PostToolUse` — runs after Claude uses a tool (can react to it)
> - `UserPromptSubmit` — runs when you send a message
> - `Stop` — runs when Claude finishes responding
>
> Each hook is a shell script that receives JSON on stdin with details about the event. The script below is a `PostToolUse` hook that fires on every `Write` tool use.
>
> **Conditional hooks (new):** You can make hooks more targeted with an `if` field. For example, to only fire on git commits: `"if": "Bash(git commit *)"`. This prevents the hook from firing on every Bash call.
>
> **More hook events:** Beyond the four above, Claude Code now also supports `CwdChanged` (working directory changes) and `FileChanged` (file modifications).

Register the hook in `.claude/settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "Edit", "Read", "Write", "Glob", "Grep",
      "Bash(git *)", "Bash(chmod *)", "Bash(mkdir *)"
    ]
  },
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

## Step 5: Test the Full Loop (10 min)

Now run the full pipeline and watch the specialists work:

```
/plan-event "Getting Started with AI Agents"
```

Then:
```
/build-schedule events/getting-started-with-ai-agents.json
```

Now ask Claude to optimize it:
```
Use the schedule-optimizer agent to optimize the schedule we just built
```

Draft an announcement:
```
/draft-announcement events/getting-started-with-ai-agents.json
```

The hook should fire and log the review trigger. Then manually invoke the reviewer:
```
Use the comms-reviewer agent to review the announcement we just drafted
```

**Compare the quality** to Step 1's all-in-one attempt. The specialists should produce noticeably better, more focused output.

Commit your work:
```bash
git add -A
git commit -m "feat: schedule-optimizer and comms-reviewer subagents with auto-review hook"
```

## Checkpoint ✓

You should now have:
- [ ] `.claude/agents/schedule-optimizer.md` working subagent
- [ ] `.claude/agents/comms-reviewer.md` working subagent
- [ ] Schedule optimizer successfully optimized at least one schedule
- [ ] Comms reviewer scored at least one announcement
- [ ] `.claude/hooks/auto-review.sh` hook script (executable)
- [ ] Hook registered in `.claude/settings.local.json`
- [ ] Hook fires when a comm is written (check `.claude/logs/reviews.log`)
- [ ] Visible quality improvement vs. the monolithic approach from Step 1

## Stuck?

If you're blocked or your output doesn't look right, compare your project against the reference implementation:

```bash
# See what your project should look like after this session
ls -R ../../solution/session-3/

# Compare a specific file
diff your-file.md ../../solution/session-3/equivalent-file.md
```

You can also copy the entire solution to catch up:
```bash
cp -r ../../solution/session-3/* .
cp -r ../../solution/session-3/.claude .
```

## Bonus Challenges

1. Add a `speaker-matcher` subagent that takes a topic and recommends the best speakers from `data/speakers.json` with reasoning
2. Enhance the hook to automatically invoke the comms-reviewer (not just log) when a comm is drafted
3. Add a `PreToolUse` hook that warns before overwriting an existing event plan file
