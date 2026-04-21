# Instructor Preparation & Dry Run Guide

Last updated: 2026-04-21

---

## Pre-Teaching Checklist

Complete these **before** your first dry run.

### Environment Setup
- [ ] Node.js 18+ installed: `node --version`
- [ ] Git installed: `git --version`
- [ ] Claude Code installed and updated: `npm install -g @anthropic-ai/claude-code && claude --version`
- [ ] Anthropic API key set: `export ANTHROPIC_API_KEY=...` (or ngrok AI Gateway configured)
- [ ] VS Code with Claude Code extension (optional but recommended for showing the IDE surface)
- [ ] Terminal with readable font size for projection (16pt+ recommended)

### Repo Setup
- [ ] Clone the course repo: `git clone https://github.com/nickyeager/tucson-claude-code-meetup.git`
- [ ] Verify data files exist: `ls data/venues.json data/speakers.json data/sample-event-plan.json`
- [ ] Verify solution snapshots: `ls solution/session-{1,2,3,4}/`
- [ ] Verify templates: `ls templates/.claude/commands/generate-prp.md templates/.claude/commands/execute-prp.md`
- [ ] Test that Claude Code launches in a fresh directory: `mkdir /tmp/test-meetup && cd /tmp/test-meetup && git init && claude`

### ngrok AI Gateway (if using)
- [ ] Gateway endpoint accessible: `curl -s https://your-gateway.ngrok.app/v1/models -H "Authorization: Bearer YOUR_KEY"`
- [ ] Credits/accounts available for students
- [ ] Fallback config tested (direct OpenAI or Anthropic)

---

## Dry Run Protocol (~4-5 hours)

Run through all 4 sessions in sequence in a fresh repo. Time each section. Note what breaks.

### Setup (15 min)
```bash
mkdir ~/dry-run-meetup && cd ~/dry-run-meetup
git init
echo "# MeetupBot" > README.md
git add README.md && git commit -m "Initial commit"
claude
```

### Session 1 Dry Run (~60 min)

**Goal:** `/plan-event "Building RAG pipelines"` returns structured JSON.

| Step | What to Do | Time Target | Watch For |
|------|-----------|-------------|-----------|
| CLAUDE.md | Ask Claude to create it per exercise instructions | 5 min | Does it include all schema fields? |
| Project structure | Scaffold data/, examples/, config/ | 5 min | File paths match exercise expectations? |
| Copy data | `cp ../data/*.json data/` (use course repo data) | 2 min | speakers.json has 8 entries, venues.json has 5 |
| ngrok config | Create config/ngrok-gateway.json | 3 min | API key works? Fallback config ready? |
| /plan-event | Build the slash command and test it | 10 min | JSON schema matches CLAUDE.md? Speakers from data? |
| Commit | `git add -A && git commit -m "Session 1 complete"` | 1 min | |
| **Before/after demo** | Show output without CLAUDE.md vs. with | 3 min | This is the key teaching moment |

**Common failure points:**
- CLAUDE.md schema doesn't match sample-event-plan.json — tighten rules
- `/plan-event` doesn't read data files — update command to explicitly reference them
- JSON output has extra fields or missing fields — add IMPORTANT rule about strict schema

**Note time:** How long did the live demos actually take? _____ min

### Session 2 Dry Run (~60 min)

**Goal:** Pipeline where `/plan-event` feeds `/build-schedule` and `/draft-announcement`.

| Step | What to Do | Time Target | Watch For |
|------|-----------|-------------|-----------|
| Context demo | Run both prompts from exercise Step 1 | 5 min | Quality difference visible? |
| INITIAL.md | Write it per exercise | 10 min | All 4 sections filled? File paths correct? |
| Copy PRP commands | `cp ../templates/.claude/commands/*.md .claude/commands/` | 1 min | Both generate-prp.md and execute-prp.md? |
| /generate-prp | Run on INITIAL.md | 5 min | PRP captures constraints? Review it! |
| /execute-prp | Run on the generated PRP | 10 min | All 3 commands created? |
| Pipeline test | Run plan -> schedule -> announcement | 10 min | Data flows through JSON? |
| Commit | | 1 min | |

**Common failure points:**
- `/generate-prp` not found — forgot to copy from templates/
- PRP misunderstands speaker availability constraint — edit PRP and re-execute
- `/build-schedule` doesn't read speakers.json — check $ARGUMENTS handling

### Session 3 Dry Run (~60 min)

**Goal:** Specialist subagents + auto-review hook firing.

| Step | What to Do | Time Target | Watch For |
|------|-----------|-------------|-----------|
| Monolith demo | Run the all-in-one prompt | 5 min | Output visibly mediocre? Save it for comparison |
| schedule-optimizer | Create agent file per exercise | 10 min | Frontmatter correct? Tools limited? |
| Test optimizer | Run it on an event plan | 5 min | Better than monolith? |
| comms-reviewer | Create agent file per exercise | 5 min | Scoring format works? |
| Test reviewer | Run it on an announcement | 5 min | Gives actionable feedback? |
| Hook script | Create auto-review.sh, make executable | 5 min | chmod +x! |
| Register hook | Update settings.local.json | 3 min | JSON syntax correct? |
| Full loop test | Plan -> schedule -> optimize -> announce -> hook fires | 10 min | Hook log written? |
| Commit | | 1 min | |

**Common failure points:**
- Hook doesn't fire — check settings.local.json JSON syntax (missing commas, wrong nesting)
- Hook doesn't receive stdin — test manually: `echo '{"tool_name":"Write","tool_input":{"file_path":"comms/test.md"}}' | bash .claude/hooks/auto-review.sh`
- Subagent can't find files — check that event plan exists from previous session

### Session 4 Dry Run (~60 min)

**Goal:** 3 parallel variants, evaluated, winner selected, feedback loop working.

| Step | What to Do | Time Target | Watch For |
|------|-----------|-------------|-----------|
| Brief | Create briefs/rag-workshop.md | 2 min | |
| Parallel variants | Ask Claude to run 3 subagents | 15 min | Do all 3 actually run? Files created? |
| Evaluate | Use schedule-optimizer + comms-reviewer on all 3 | 10 min | Scores differ? Meaningful evaluation? |
| Select winner | Copy winning files to *-final | 3 min | |
| /post-event | Build the command | 10 min | Saves to data/past-events/? |
| Feedback test | Run /post-event with mock data, then /plan-event again | 5 min | New plan reflects feedback? |
| Commit | | 1 min | |

**Common failure points:**
- Parallel subagents don't actually parallelize — be more explicit: "run as 3 separate subagents in parallel, each in its own worktree"
- Variants saved to wrong paths — check the prompt specifies exact file paths
- Feedback loop doesn't close — update plan-event.md to read from data/past-events/

---

## Timing Notes (fill in during dry run)

| Session | Instruction Time | Exercise Time | Total | Notes |
|---------|-----------------|---------------|-------|-------|
| 1 | _____ min | _____ min | _____ min | |
| 2 | _____ min | _____ min | _____ min | |
| 3 | _____ min | _____ min | _____ min | |
| 4 | _____ min | _____ min | _____ min | |

**Live demo observations:**
- Demo that took longest: _____
- Demo that needed retry: _____
- Demo that got best reaction: _____

---

## Day-of Checklist

### 30 min before
- [ ] Test internet connection
- [ ] Test API key / ngrok gateway still works
- [ ] Open terminal at readable font size
- [ ] Have course repo open in a separate tab
- [ ] Have solution/ folder ready for quick reference
- [ ] Clear terminal history (students don't need to see your debugging)

### Between sessions
- [ ] Verify your demo project is at the right checkpoint
- [ ] Review the next session's SCRIPT.md talking points
- [ ] Clear old output from terminal

### Emergency fallbacks
- **Claude Code won't install:** Have students use `claude.ai/code` web version instead
- **API key issues:** Have 2-3 spare API keys ready, or switch to direct provider
- **ngrok down:** Config swap to direct OpenAI/Anthropic (2-line change)
- **Student falls behind:** Point them to `solution/session-N/` to copy and catch up
- **Demo fails live:** "This is actually a great teaching moment — let's debug it together." Then fix it. Showing recovery is more valuable than a perfect demo.
- **Time running short:** Cut bonus challenges first, then skip the less critical demo (usually the ngrok setup demo — students can do it during exercise time)

---

## Key Teaching Moments to Nail

These are the moments that stick with students. Practice them.

1. **Session 1: Before/After CLAUDE.md** — Same question, with and without CLAUDE.md. The quality difference is the aha moment. Practice this transition.

2. **Session 2: Context engineering demo** — Two prompts, same task. "Same model. Same task. Only the context changed." Let it land. Give students 3 seconds of silence.

3. **Session 3: Monolith vs. Specialists** — Keep the monolith output visible. Show the specialist output side-by-side. "Same model. Same data. Different architecture."

4. **Session 4: Feedback loop** — After mock post-event feedback, run /plan-event again. Watch the recommendations change. "No retraining. No fine-tuning. Just context."

---

## Post-Dry-Run Actions

- [ ] Fix any broken exercise steps discovered during dry run
- [ ] Update timing estimates if significantly off from SCRIPT.md
- [ ] Note any questions you'd expect from students and prepare answers
- [ ] Commit any fixes back to the repo
