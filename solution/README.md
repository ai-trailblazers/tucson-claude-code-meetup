# Solution / Reference Implementation

Each session folder contains a complete snapshot of the MeetupBot project as it should look **after completing that session's exercises**.

## How to Use

**Compare your work:**
```bash
# See what files you should have after Session 1
ls -R solution/session-1/

# Diff a specific file against the reference
diff my-project/CLAUDE.md solution/session-1/CLAUDE.md
```

**Catch up if you fall behind:**
```bash
# Reset to the Session 2 checkpoint
cp -r solution/session-2/* my-project/
cp -r solution/session-2/.claude my-project/
```

**Preview the finished product:**
```bash
# See the complete MeetupBot
ls -R solution/session-4/
```

## Session Snapshots

### Session 1: Fundamentals
- CLAUDE.md with agent rules and JSON schemas
- Project structure with data files
- `/plan-event` slash command
- Sample event plan output

### Session 2: Context Engineering
- Everything from Session 1, plus:
- INITIAL.md feature request
- Generated PRP at PRPs/meetup-comms.md
- `/build-schedule`, `/draft-announcement`, `/draft-speaker-outreach` commands
- Sample schedule, announcement, and speaker outreach outputs

### Session 3: Subagents & Hooks
- Everything from Sessions 1-2, plus:
- `schedule-optimizer` subagent
- `comms-reviewer` subagent
- `auto-review.sh` hook with PostToolUse registration
- Additional event plans and outputs

### Session 4: Parallel Agents & Feedback (Complete System)
- Everything from Sessions 1-3, plus:
- Meetup brief for parallel generation
- 3 competing event plan variants (community, deep-dive, workshop-lab)
- Matching schedules and announcements for each variant
- Final winning variant
- `/post-event` slash command
- Post-event feedback recap in data/past-events/

## Note on API Keys

The `config/ngrok-gateway.json` files contain placeholder values. You'll need to add your own ngrok AI Gateway or provider API key to run the slash commands.
