# Session 3 Speaker Script

**Total time:** ~60 minutes (25 min instruction + 35 min exercise)

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

"Okay, I want you to watch this closely. I'm going to give Claude one big prompt — the kind of prompt you'd write if you didn't know about subagents."

[PAUSE] "Watch the quality of what comes back."

Open terminal. Type the monolith prompt:

```
Optimize the schedule for conflicts, rewrite the announcement
for better engagement, review the speaker outreach emails for
tone, and suggest a better venue layout — all at once.
```

"Look at this. The schedule analysis is surface-level — 'looks fine, maybe move this talk.' The announcement rewrite is generic. The email review is one sentence. The venue suggestion is an afterthought."

[PAUSE] "It's not wrong. It's just... mediocre. At everything. This is what context overload looks like."

**Keep this output visible. You'll compare it to the specialist output later.**

"Remember this output. We're coming back to it."

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

"A subagent is just a markdown file in `.claude/agents/`. It has frontmatter — name, description, and the tools it's allowed to use. Then the body: instructions, expected input, output format, and rules."

"Notice the tools list. This agent only gets Read and Glob. It can look at files but it can't write anything. That's intentional. A schedule optimizer shouldn't be modifying your comms folder."

"The output format is specified as JSON. This is how subagents talk back to the orchestrator — structured data, not prose."

---

## Slide 8: Key Subagent Concepts
**Time: 2 min**

"Five things to internalize. Own context window — the subagent starts fresh, no bleed from the parent conversation. Limited tools — only what it needs. The word 'Proactively' in the description — this is a magic word. It tells Claude to invoke this agent automatically when the situation calls for it. One-shot design — do the job, return, done. And structured output — JSON, so the result is machine-parseable."

[PAUSE] "That 'Proactively' keyword is important. Write it down. It's the difference between a subagent you have to manually call and one that Claude calls for you."

---

## Slide 9: LIVE DEMO — Schedule Optimizer
**Time: 3 min**

[DEMO]

"Let's build the schedule optimizer and test it."

Create the file, then run:

```
claude "Use schedule-optimizer agent to optimize
the Python meetup schedule for next month"
```

"Look at this output compared to what we got from the monolith. Specific conflicts identified. Concrete time-slot suggestions. Structured JSON output."

[PAUSE] "Same model. Same underlying data. Completely different quality. The only thing that changed is the architecture."

**Side-by-side the monolith output if possible.** This contrast is the aha moment.

---

## Slide 10: LIVE DEMO — Comms Reviewer
**Time: 2 min**

[DEMO]

"Now the comms reviewer. This one scores communications on four dimensions — completeness, tone, clarity, and call-to-action — each on a 1-to-10 scale. Then it gives a verdict: SEND, REVISE, or REWRITE."

Build the agent, then test it against the announcement from session 2.

"See that? It caught the missing RSVP link. It flagged the weak call-to-action. It gave specific, actionable feedback. The monolith said 'the announcement is good, consider adding more detail.' This specialist tells you exactly what's wrong and how to fix it."

---

## Slide 11: The Quality Jump
**Time: 1 min**

"Let's put them side by side. Before — monolith — generic, surface-level, 'looks fine.' After — specialists — three conflicts detected, email scored 6 out of 10 with specific issues, focused and thorough."

[PAUSE] "Same model. Same data. Different architecture. That's the lesson."

"This is why companies that are good at AI aren't just picking better models — they're designing better architectures around the same models everyone else has access to."

---

## Slide 12: Model Routing with ngrok
**Time: 1 min**

"Quick aside on model routing. Not every task needs your most expensive model. Drafting email copy? gpt-4o-mini is fast and cheap and perfectly good at prose. Schedule optimization needs structured reasoning — that's Claude Sonnet. Quality review needs nuance — Sonnet again."

"ngrok AI Gateway handles this routing. You set the rules, the gateway picks the model. Or use 'auto' and let it decide. This is about cost efficiency at scale — don't overspend on easy tasks."

---

## Slide 13: Hooks — Lifecycle Automation
**Time: 2 min**

"Now hooks. If subagents are your specialists, hooks are your automation layer. Hooks are code that runs when things happen inside Claude Code."

"Four hook events: PreToolUse fires before a tool executes — you could block dangerous operations. PostToolUse fires after — perfect for triggering reviews. UserPromptSubmit fires when the user sends a message — you could log or validate input. Stop fires when the agent finishes."

"Think of this as CI/CD for your agent workflow. Same concept — automated checks triggered by events."

---

## Slide 14: Auto-Review Hook
**Time: 1 min**

"Here's our hook. It's a bash script. It reads the tool event from stdin as JSON, checks if the Write tool hit something in the comms folder, and if so, triggers the comms-reviewer."

"Simple. Any time anything gets written to the comms directory, automatic quality review. No human has to remember to run it."

---

## Slide 15: Registering Hooks
**Time: 1 min**

"You register hooks in `.claude/settings.local.json`. PostToolUse event, matcher set to 'Write' — so it only fires on Write tool calls — and the command points to our script."

"The hook receives the full tool event as JSON on stdin. That's how the script knows what file was written and where."

---

## Slide 16: LIVE DEMO — The Full Loop
**Time: 3 min**

[DEMO] **This is the payoff demo. Run through the whole chain.**

"Watch the whole thing connect. I start with /plan-event. It produces a plan. I run /build-schedule. Schedule comes out. The schedule-optimizer auto-invokes — I didn't ask for it, Claude saw the opportunity and called the specialist. Then /draft-announcement. It writes to the comms folder. The hook fires. The comms-reviewer scores it automatically."

Run through each step. Let students see the chain.

"Zero manual review steps. The architecture handles quality. You set up the system once and it enforces standards every time."

[PAUSE] "Questions before we move to the exercise?"

---

## Slide 17: MCP — Connecting External Tools
**Time: 1 min**

"Quick aside on MCP — Model Context Protocol. This is the standard interface for connecting Claude Code to external services. Databases, APIs, monitoring tools."

"For MeetupBot in production, you could wire up Eventbrite to auto-publish events, Google Calendar for venue availability, Slack for posting announcements. We're not building these today, but the architecture supports it. Just know it exists."

---

## Slide 18: Tips & Gotchas
**Time: 1 min**

"Do use 'Proactively' in descriptions. Do make descriptions self-contained — the subagent doesn't see your conversation history. Do give minimal tool sets. Do return structured JSON. Do test in isolation first."

"Don't give subagents tools they don't need. Don't assume they share context with the parent. Don't hook every tool event — that kills performance. Don't make subagents that depend on each other's state. Don't skip the one-shot pattern."

---

## Slide 19: BUILD TIME
**Time: 35 min (exercise)**

"Alright, build time. You've got 35 minutes. The exercise is in `class/session-3/EXERCISE.md`."

"Your goal: build specialist subagents that visibly outperform the monolith, plus an automated review hook. You saw me do it — now you build your own."

"Start with the schedule-optimizer. Get it working. Then the comms-reviewer. Then wire up the hook. If you finish early, experiment with the 'Proactively' keyword — see if you can get Claude to auto-invoke your subagents."

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

"And the big one — can you see a visible quality improvement over the monolith approach? That's the whole point."

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
