# Session 3 Speaker Script

**Total time:** ~70 minutes (30 min instruction + 35 min exercise + 5 min wrap)

---

## Slide 1: Title
**Time: 1 min**

"Welcome back everyone. Session 3. This is where things get really interesting."

"Last session we built composable commands — slash commands that pass data to each other. That was great. But we were still asking one agent to do everything. Today we fix that."

"The thesis of this session is simple: one agent doing everything equals mediocre at everything. Specialists beat generalists. Let's prove it."

---

## Slide 2: Recap
**Time: 2 min**

"Quick recap. We built four slash commands — plan-event, build-schedule, draft-announcement, draft-speaker-outreach. They talk to each other through JSON contracts. Composable, reusable, clean."

"But here's the thing — when we ask Claude to optimize a schedule AND write an announcement AND review emails... it's one brain trying to do four jobs at once. Today we break the monolith into specialists."

[TRANSITION] "Let me show you exactly what I mean."

---

## Slide 3: Today's Goal
**Time: 1 min**

"Four things we're covering: why monoliths fail, how subagents fix it, hooks for lifecycle automation, and model routing — putting the right model on the right task."

"By the end of this session, you'll have specialist agents that auto-invoke and a hook system that runs quality checks without you lifting a finger."

---

## Slide 4: The Monolith Problem
**Time: 5 min**

[DEMO] **This is the key demo of the session. Set it up carefully.**

### 🎬 Quick Demo — Copy/paste ready

**Prep check (do this before class starts):**
```bash
# Confirm you have an event plan from session 2
ls events/*.json
# Confirm comms drafts exist
ls comms/
```

If `events/` is empty, generate one now (takes ~10s):

```text
/plan-event "Getting Started with AI Agents"
/build-schedule events/getting-started-with-ai-agents.json
/draft-announcement events/getting-started-with-ai-agents.json
/draft-speaker-outreach events/getting-started-with-ai-agents.json
```

**The monolith prompt — paste verbatim into Claude Code:**

```text
Read events/getting-started-with-ai-agents.json. Now do ALL of the
following in ONE response, no follow-ups:
1. Optimize the schedule to maximize networking time
2. Rewrite the announcement in comms/ for better engagement
3. Review the speaker outreach emails for tone issues
4. Suggest a better venue based on data/venues.json
```

**Expected result (what you'll point at):**
- Schedule analysis: 1–2 generic sentences, no specific time slots moved
- Announcement rewrite: surface-level, often loses the original CTA
- Email review: one sentence per email or skipped entirely
- Venue suggestion: hedged, doesn't reference attendee count

---

### Talking points

"Okay, I want you to watch this closely. I'm going to give Claude one big prompt — the kind of prompt you'd write if you didn't know about subagents."

[PAUSE] "Watch the quality of what comes back."

[Paste the monolith prompt above. Wait for the response.]

"Look at this. The schedule analysis is surface-level — 'looks fine, maybe move this talk.' The announcement rewrite is generic. The email review is one sentence. The venue suggestion is an afterthought."

[PAUSE] "It's not wrong. It's just... mediocre. At everything. This is what context overload looks like."

**Keep this output visible — split your terminal or screenshot it. You'll compare it to the specialist output on Slide 11.**

"Remember this output. We're coming back to it."

> **If the demo runs long:** hit Esc to stop generation as soon as you have enough mediocrity to point at. You don't need the full response.

---

## Slide 5: Why Monolithic Fails
**Time: 2 min**

"Four problems. Context overload — the agent is juggling schedule data, email drafts, venue layouts, all in one context window. No specialization — it's a generalist being asked to be an expert at four things simultaneously. No quality gates — there's no review step, whatever it produces just passes through. And you can't parallelize — it's one sequential prompt."

"The agent isn't bad. We're using it badly. It's like asking your best engineer to simultaneously write code, review PRs, update docs, and plan the sprint. They can do all those things — just not all at once."

---

## Slide 6: Subagents — The Fix
**Time: 2 min**

"Here's the architecture. Main agent at the top — that's your orchestrator. Below it: schedule-optimizer, comms-reviewer, speaker-matcher. Each one gets its own context window, its own limited set of tools, and one job."

"Key insight: these are one-shot agents. They do their job, return the result, and exit. No state. No side effects. Just focused work."

[TRANSITION] "Let me show you what one of these looks like inside."

---

## Slide 7: Anatomy of a Subagent
**Time: 2 min**

"A subagent is just a markdown file in `.claude/agents/`. Frontmatter on top: name, description, the tools it's allowed to use, and optionally a `model` field. Then the body — instructions, expected input, output format, rules."

"Notice the tools list. This agent only gets Read, Grep, and Glob. It can look at files but it can't write anything. That's intentional. A schedule optimizer shouldn't be modifying your comms folder."

"And `model: sonnet` here — that's a per-subagent override. We'll come back to that on the model routing slide. The point is: cheap fast model for cheap fast tasks, big model where you need real reasoning."

"The output format is whatever's easiest to parse — a markdown table works great for human-in-the-loop review, JSON if you're chaining into another command. Pick a structure and stick to it."

---

## Slide 8: Key Subagent Concepts
**Time: 2 min**

"Five things to internalize. Own context window — the subagent starts fresh, no bleed from the parent. Limited tools — only what it needs. The phrase 'use proactively' in the description — that's a nudge to Claude that this agent is a candidate for auto-delegation. It's not magic. Claude still picks based on whether your description matches the current task."

"One-shot design — do the job, return, done. And structured output — pick a parseable format so the orchestrator can act on it."

[PAUSE] "Be careful how you frame 'proactively.' I used to call it the magic word. The honest version: it's a hint. The real trigger is description quality. Write descriptions that say *exactly* when to invoke this agent and what it does, and Claude will pick it up."

---

## Slide 9: LIVE DEMO — Schedule Optimizer
**Time: 3 min**

[DEMO]

"Let's build the schedule optimizer. Two ways to do this — I'll show you both quickly."

"Option A is `/agents`. Built-in slash command. Opens a Library tab, you pick 'Create new agent', pick Project scope, and Claude can even generate the system prompt for you. This is the recommended path. Big advantage: changes apply immediately."

"Option B is what we'll do for the workshop because it's clearer what's happening — write the file by hand at `.claude/agents/schedule-optimizer.md`."

[PAUSE] "Quick gotcha for option B — when you save the file, the running session doesn't see it. You have to restart the session. The `/agents` UI doesn't have that issue. If you forget this, you'll spend ten minutes wondering why nothing's happening."

Then run:

```
Use the schedule-optimizer agent to optimize
the Python meetup schedule for next month
```

"Look at this output compared to what we got from the monolith. Specific conflicts identified. Concrete time-slot suggestions. Structured, scannable output."

[PAUSE] "Same model. Same underlying data. Completely different quality. The only thing that changed is the architecture."

**Side-by-side the monolith output if possible.** This contrast is the aha moment.

---

## Slide 10: LIVE DEMO — Comms Reviewer
**Time: 2 min**

[DEMO]

"Now the comms reviewer. This one scores communications on four weighted dimensions — completeness up to 3, tone up to 3, clarity up to 2, call-to-action up to 2. Adds up to a /10 total. Then it gives a verdict: SEND if 7 or higher, REVISE if 5 to 6, REWRITE below that."

Build the agent, then test it against the announcement from session 2.

"See that? It caught the missing RSVP link. It flagged the weak call-to-action. It gave specific, actionable feedback. The monolith said 'the announcement is good, consider adding more detail.' This specialist tells you exactly what's wrong and how to fix it."

---

## Slide 11: The Quality Jump
**Time: 1 min**

"Let's put them side by side. Before — monolith — generic, surface-level, 'looks fine.' After — specialists — three conflicts detected, email scored 6 out of 10 with specific issues, focused and thorough."

[PAUSE] "Same model. Same data. The only thing that changed was the architecture — one focused agent per task instead of one agent doing everything."

---

## Slide 12: Model Routing — The `model:` Field
**Time: 1 min**

"Quick win on cost. Claude Code has native model routing per subagent. Just add `model: haiku` or `model: sonnet` to the frontmatter."

"Use Haiku for triage and scoring — comms-reviewer is a perfect candidate. It's reading text and assigning numbers. Haiku will smoke that, fast and cheap. Use Sonnet for things that need real reasoning over structured data — schedule optimization, dependency analysis. Default is `inherit`, which matches the parent session."

"This is the idiomatic answer. If you also need to mix providers — Claude plus GPT plus open-source models — that's where ngrok AI Gateway comes in, sitting in front of Claude Code. But for routing within Claude itself, the `model:` field is the right tool."

---

## Slide 13: Hooks — Lifecycle Automation
**Time: 2 min**

"Now hooks. If subagents are your specialists, hooks are your automation layer. Hooks are code that runs when things happen inside Claude Code."

"There are 30+ hook events. The table on the slide is the ones you'll reach for ninety percent of the time. PreToolUse before a tool executes — block dangerous operations, validate input. PostToolUse after — trigger reviews, log actions. UserPromptSubmit when the user sends a message. Stop and SubagentStop when the agent or a subagent finishes. SessionStart and SessionEnd are useful for bootstrapping environments and archiving transcripts. PreCompact fires before context gets compacted — handy for persisting state you don't want compressed away."

"Every hook receives JSON on stdin with the event details — tool name, file path, session ID, working directory, whatever the context is. Your script reads that JSON and decides what to do."

"Conditional hooks — you can add an `if` field that uses permission-rule syntax. `if: Bash(git commit *)` means the hook only fires on git commits, not every Bash call. The `if` field only works on tool events — PreToolUse, PostToolUse, that family — but that's where you usually want it anyway."

"Think of this as CI/CD for your agent workflow. Same concept — automated checks triggered by events."

---

## Slide 14: Auto-Review Hook
**Time: 1 min**

"Here's our hook. It's a bash script. It reads the tool event from stdin as JSON, checks if the Write tool hit something in the comms folder, and if so, triggers the comms-reviewer."

"Simple. Any time anything gets written to the comms directory, automatic quality review. No human has to remember to run it."

---

## Slide 15: Registering Hooks
**Time: 1 min**

"You register hooks in `.claude/settings.local.json`. PostToolUse event, matcher set to 'Write' — so it only fires on Write tool calls — and inside the hooks array, you specify the type as 'command' and point to your script."

"The hook receives the full tool event as JSON on stdin. That's how the script knows what file was written and where."

---

## Slide 16: LIVE DEMO — The Full Loop
**Time: 3 min**

[DEMO] **This is the payoff demo. Run through the whole chain.**

"Watch the whole thing connect. I start with /plan-event. It produces a plan. I run /build-schedule. Schedule comes out. Now I'll explicitly call the schedule-optimizer — I'm naming it because I want it to run reliably in front of you. Then /draft-announcement. It writes to the comms folder. The hook fires automatically — that's hooks doing their job. Then I call comms-reviewer to score the result."

[PAUSE] "Quick honesty note: with strong descriptions, Claude will sometimes pick up subagents on its own. But for live demos and production pipelines, **name the agent you want.** Auto-delegation is a nice bonus, not something to bet on."

Run through each step. Let students see the chain.

"Zero manual review steps for the *quality check* — the architecture handles that. The hook is the deterministic part. The subagents are the focused part. Together: a system that enforces standards every time."

[PAUSE] "Questions before we move to the exercise?"

---

## Slide 17: MCP — Connecting External Tools
**Time: 1 min**

"Quick aside on MCP — Model Context Protocol. This is the standard interface for connecting Claude Code to external services. Databases, APIs, monitoring tools."

"A recent improvement: Tool Search. MCP used to load every tool into context upfront, which burned tokens. Now it defers tool definitions until Claude actually needs them. That keeps your context lean when you're connecting to services with dozens of endpoints."

"There's also Channels — a research preview where MCP servers can push messages into your Claude session. Imagine Telegram or Discord messages flowing directly into your agent conversation. Early days, but powerful."

"For MeetupBot in production, you could wire up Eventbrite to auto-publish events, Google Calendar for venue availability, Slack for posting announcements. We're not building these today, but the architecture supports it. Just know it exists."

---

## Slide 18: Tips & Gotchas
**Time: 1 min**

"Do include 'use proactively' in descriptions. Do make descriptions self-contained — the subagent doesn't see your conversation history. Do give minimal tool sets, or use `disallowedTools` to inherit-minus. Do set `model:` per task — Haiku for triage, Sonnet for reasoning. Do return a parseable, structured format. Do test in isolation first. And restart your session after editing agent files by hand."

"Don't give subagents tools they don't need. Don't assume they share context with the parent. Don't hook every tool event — that kills performance. Don't make subagents that depend on each other's state. Don't skip the one-shot pattern."

---

## Slide 19: BUILD TIME
**Time: 35 min (exercise)**

"Alright, build time. You've got 35 minutes. The exercise is in `sessions/session-3/EXERCISE.md`."

"Your goal: build specialist subagents that visibly outperform the monolith, plus an automated review hook. You saw me do it — now you build your own."

"Start with the schedule-optimizer. Get it working. Then the comms-reviewer. Then wire up the hook. If you finish early, experiment with description wording — try removing 'use proactively', try making the description vague, try making it razor-sharp. Watch how Claude's invocation behavior changes. The description is the real lever."

[PAUSE] "Go. I'll circulate."

**During exercise:**
- Walk the room
- Common issues: forgetting frontmatter format, wrong tool names, hook not receiving stdin correctly
- If someone's stuck on hooks, have them test the shell script manually first with `echo '{"tool_name":"Write","tool_input":{"file_path":"comms/test.md"}}' | bash .claude/hooks/auto-review.sh`

---

## Slide 20: Checkpoint
**Time: 2 min**

"Okay, let's check in. Hands up if your schedule-optimizer is working and producing structured output."

[PAUSE — count hands]

"Comms-reviewer scoring and giving verdicts?"

[PAUSE — count hands]

"Hook firing automatically on comms writes?"

[PAUSE — count hands]

"And the big one — can you see a visible quality improvement over the monolith approach?"

"If you're not there yet, that's fine. The exercise files have the complete solutions. Catch up before next session."

---

## Slide 21: What's Next — Session 4
**Time: 1 min**

"Next session we go further. Three competing agents generating different approaches to the same problem. Specialist evaluators scoring each approach. A feedback system that picks the best one and iterates."

"If subagents are specialists, session 4 is a tournament. We make the agents compete."

---

## Slide 22: Session 3 Recap
**Time: 1 min**

"Three things. One: specialists beat generalists. Same model, focused context, dramatically better output. Two: hooks automate quality. No manual review steps — code runs when things happen. Three: route models to tasks. Right model for the right job."

"Great session everyone. See you next time — we make the agents compete."

[END]
