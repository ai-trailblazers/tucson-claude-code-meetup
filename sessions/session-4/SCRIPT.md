# Session 4 Speaker Script

**Total time:** ~60 minutes (25 min instruction + 35 min exercise)

---

## Slide 1: Title
**[~1 min]**

Welcome back to the final session. Session 4. We made it.

Over the last three sessions, you've gone from writing your first CLAUDE.md to building a full agent system with slash commands, subagents, and automated quality gates.

Today we're going to do something that might sound a little wild: we're going to take the non-determinism of LLMs -- the thing that usually frustrates people -- and turn it into a superpower.

[PAUSE]

"Non-determinism is a feature, not a bug." By the end of this session, you'll believe that.

---

## Slide 2: Recap -- The Full System So Far
**[~2 min]**

Let's take a quick inventory of what you've built. This is real. You built all of this.

`/plan-event` kicks things off -- structured event planning. `/build-schedule` creates a detailed timeline. The `schedule-optimizer` subagent reviews that schedule for quality. `/draft-announcement` writes comms. The auto-review hook fires on every commit. And the `comms-reviewer` subagent checks tone and clarity automatically.

That's a legitimate agent system. Multiple specialized components working together.

Today we add two more capabilities: parallel generation and learning from results.

---

## Slide 3: Today's Goal
**[~1 min]**

Here's what we're building: a system that generates competing variants of an event plan, evaluates them objectively, picks the best one, and then -- this is the key part -- learns from what actually happens when the event runs.

Four concepts: parallel subagents, evaluation-driven selection, git worktrees for isolation, and feedback loops.

Let's start with the idea that makes all of this possible.

---

## Slide 4: The Non-Determinism Problem
**[~2 min]**

If you ask Claude "plan a meetup about RAG pipelines" three times, you'll get three different answers. Different structures, different emphases, different ideas.

Most of the time, that's annoying. You want consistency. You want reliability.

[PAUSE]

But what if instead of fighting that, we leaned into it? What if we said: "Give me three different answers on purpose. Each one with a different strategy. Then let me pick the best one."

That's the insight. Non-determinism plus evaluation equals something better than any single attempt could give you.

This is actually how production AI systems work at companies like Anthropic. You don't just generate once and hope. You generate multiple candidates and select.

---

## Slide 5: Parallel Subagents
**[~2 min]**

Here's the architecture. The main agent spawns three subagents. Each one gets a different directive. V1 focuses on networking and community. V2 goes deep on technical content. V3 is all hands-on workshop.

Each subagent runs the full pipeline -- plan, schedule, announcement -- but with its own personality and priorities.

Then our specialists from Session 3 -- the ones you already built -- score each variant. The winner gets selected.

The beautiful thing is we're not building new evaluation logic. We're reusing the subagents we already have.

---

## Slide 6: How It Works -- Under the Hood
**[~1 min]**

Practically, each subagent needs its own workspace so they don't step on each other's files. That's where git worktrees come in.

You end up with four directories: the main workspace plus one for each variant. Each subagent works in its own isolated copy. No merge conflicts. No race conditions. Claude handles the orchestration.

---

## Slide 7: Git Worktrees -- The Concept
**[~1 min]**

Quick aside for the curious. A git worktree is a separate working directory that's linked to the same repository. Same repo, separate branches, separate file systems.

The Agent tool in Claude Code has an `isolation: "worktree"` option that sets this up automatically. You don't have to manage it yourself.

If you're not familiar with worktrees, don't worry -- Claude handles the mechanics. The important thing is understanding that each variant gets its own isolated space to work in.

"And here's the best part — you don't need special syntax to trigger this. You just describe what you want in natural language: 'run 3 parallel subagents, each in its own worktree.' Claude figures out the orchestration. If it doesn't automatically parallelize, you can be more explicit by saying 'run these as 3 separate subagents in parallel, each in its own worktree.' You'll see 'launching agent' messages in the terminal for each one."

---

## Slide 8: LIVE DEMO -- Parallel Generation
**[~3 min]**

[DEMO]

Alright, let's see this in action. I'm going to generate three variants for a RAG Workshop event.

V1 is community-first -- lots of networking time, group discussion, demos. V2 is a deep-dive -- architecture diagrams, internal mechanics, advanced patterns. V3 is a workshop-lab -- you're building a RAG pipeline from scratch during the session.

Watch the terminal. You'll see three subagents spin up simultaneously. Each one is working in its own worktree, running the full pipeline independently.

[Run the parallel generation. Let it run. Point out the three simultaneous processes.]

[PAUSE]

Three complete event plans. Three schedules. Three announcements. Generated in parallel, each with a totally different approach.

---

## Slide 9: Evaluation -- Reusing Your Specialists
**[~1 min]**

Now here's where Sessions 3 pays off. Remember `schedule-optimizer` and `comms-reviewer`? Those subagents you built?

We're going to point them at all three variants. Schedule-optimizer scores each schedule for quality, time allocation, and flow. Comms-reviewer scores each announcement for clarity, tone, and completeness.

Build once, reuse everywhere. That's the power of composable architecture.

---

## Slide 10: LIVE DEMO -- Scoring Variants
**[~2 min]**

[DEMO]

Let's run the evaluation. Each specialist scores each variant.

[Run the evaluation. Show the scoring table as it populates.]

Look at that. V3 won on schedule quality -- the hands-on format just scores better for flow and time allocation. But V1 actually won on announcement clarity -- the community angle makes for a more compelling invite.

This is why parallel generation is so powerful. You can see the tradeoffs explicitly. And you could even combine elements -- take V3's schedule with V1's announcement.

[PAUSE]

---

## Slide 11: Why This Works
**[~1 min]**

Single attempt: you hope it's good. If it's not, you re-run and hope again. No basis for comparison.

Parallel plus evaluation: three different strategies explored, objective scoring you can inspect and audit, elements you can combine, and criteria that are reproducible.

This isn't a trick. This is how production AI systems actually work. You just built one.

---

## Slide 12: The Missing Piece -- Learning
**[~2 min]**

OK. So our agent can plan great events. It can generate variants and pick the best one. But here's the problem.

[PAUSE]

It doesn't learn.

It estimated 40 attendees but only 35 showed up. The WiFi at the venue was terrible. The hands-on exercises ran 15 minutes over. The lightning talks were the highlight and we almost cut them.

All of that information... just gone. Next time it plans an event, it makes the exact same assumptions. Same venue recommendation. Same time estimates. Same structure.

Without feedback, the agent is stuck. It never gets smarter.

---

## Slide 13: The Feedback Loop
**[~1 min]**

Here's the fix. After the event runs, we capture feedback and store it in a `past-events/` directory. Next time `/plan-event` runs, it reads that feedback.

Plan, run, capture, store, read. The loop closes. The agent gets smarter with every event.

This is context engineering at its purest. We're not fine-tuning a model. We're not retraining anything. We're just putting the right information in context at the right time.

---

## Slide 14: Post-Event Data
**[~1 min]**

Here's what the feedback looks like. JSON with actual versus estimated attendees, a venue rating, highlights from attendee feedback, areas for improvement, and lessons learned.

Simple, structured data. Nothing fancy. But when the agent reads this before planning the next event, everything changes.

---

## Slide 15: How /plan-event Uses Feedback
**[~2 min]**

Look at the before and after.

Before feedback: "Maker Space Downtown, good location, affordable. Exercises: 30 minutes each."

After feedback: "Tech Hub East -- because Maker Space WiFi was rated 3 out of 10. Confirmed 100Mbps connection. Exercises: 20 minutes max -- because past events ran over. Added hard cutoff timers. Lightning talks: added a 15-minute block -- because they were the highest-rated segment."

[PAUSE]

Every single recommendation changed based on real data. The agent didn't get smarter. It got better context. That's the whole game.

"Now here's the practical part — to make this actually work, you need to update your `/plan-event` command to read from `data/past-events/`. Just add a line to plan-event.md that says 'before generating the plan, read all files in data/past-events/ for lessons learned.' That's what closes the loop. Without that line, the feedback just sits there unused."

Context engineering in action.

---

## Slide 16: LIVE DEMO -- The Full Loop
**[~3 min]**

[DEMO]

Let's close the loop live. First, I'll create mock feedback from a past event -- WiFi issues, exercises too long, lightning talks were great.

Now I'll run `/plan-event` for a new topic.

[Run the command. Wait for output.]

Watch the recommendations. There -- it recommended a different venue. It shortened the exercises. It added lightning talks.

The agent read the feedback, incorporated it, and made better decisions. No retraining. No fine-tuning. Just context.

[PAUSE]

That's the feedback loop. That's how agents learn.

---

## Slide 17: The Complete MeetupBot
**[~1 min]**

Let's zoom out. Look at what you've built across four sessions.

Session 1: an agent that plans events with structured output. Session 2: a composable pipeline of commands. Session 3: quality automation with specialist subagents. Session 4: self-improvement through parallel generation and feedback.

Six slash commands. Two subagents. One hook. One feedback loop.

[PAUSE]

That's a real agent system. Not a toy. Not a demo. A real, composable, self-improving system.

---

## Slide 18: Production Decision Framework
**[~1 min]**

Here's your cheat sheet for building agents beyond this course. When do you use each pattern?

CLAUDE.md for global rules and constraints. Slash commands for repeatable, composable tasks. Subagents when you need domain-specific expertise. Hooks for automatic quality gates. Examples directory for few-shot learning. PRPs for complex multi-step plans.

You don't need all of them every time. Pick the patterns that fit your problem.

---

## Slide 19: Transferable Patterns
**[~2 min]**

This is the slide I want you to remember. Everything we built with MeetupBot maps to general patterns you can use anywhere.

Event JSON output? That's structured output for any domain. Composable commands? Task pipelines. Schedule-optimizer and comms-reviewer? Domain specialist agents. The auto-review hook? Quality gates. Three competing variants? Non-determinism plus evaluation. Past-events feedback? Learning loops.

[PAUSE]

MeetupBot was the vehicle. These patterns are the destination. Take them to your own projects. They work everywhere.

---

## Slide 20: BUILD TIME
**[~1 min]**

Alright, your turn. Last exercise of the course. Make it count.

You're going to build the parallel variant system, wire up evaluation using your existing subagents, build the `/post-event` command, and connect feedback into `/plan-event`.

35 minutes. This is the capstone. Everything you've learned comes together here.

Go.

[PAUSE -- students begin exercise]

---

## Slide 21: Checkpoint
**[~1 min | after exercise]**

Welcome back. Let's check in.

Three variants generated? Evaluated by your subagents? Winner selected? `/post-event` working? Feedback influencing plans?

[PAUSE -- ask for hands or thumbs up]

If you got through all five, that's the full system. If you got through three or four, you're in great shape -- the rest is straightforward to finish on your own.

---

## Slide 22: Where to Go Next
**[~1 min]**

So where do you go from here?

First — Routines. This is brand new. Claude Code now has cloud-based automations that run without your laptop. You define a prompt, connect a repo, and set a trigger. Scheduled cadences — 'every Monday, suggest this week's meetup topic.' GitHub events — 'when a PR is opened, review the changes.' API calls — 'when our RSVP webhook fires, update the attendee estimate.' Pro plan gets 5 per day, Max gets 15. It's the natural next step for MeetupBot — automate the feedback loop on a schedule.

Second — the Claude Agent SDK. Formerly called the Claude Code SDK, it's available in Python and TypeScript. It lets you embed everything you've learned — subagents, tool permissions, hooks — into your own applications. `pip install claude-agent-sdk` or `npm install @anthropic-ai/claude-agent-sdk`.

You can extend MeetupBot. Add MCP servers for Eventbrite, Google Calendar, Slack. Add more specialist subagents — budget optimization, sponsor outreach. Use Routines to automate the whole thing. Build with the Agent SDK to embed it in your own tools.

Or take these patterns to a completely different project. Internal tools. Content pipelines. Code review agents. The architecture is the same. The domain is just a variable.

---

## Slide 23: Course Recap
**[~2 min]**

Let me leave you with the arc of what we learned.

Session 1: CLAUDE.md rules shape agent behavior. You learned that the instructions you write matter more than the model you use.

Session 2: Context is greater than prompts. Structure beats cleverness. Building composable commands gives you more power than any single clever prompt.

Session 3: Specialists beat monoliths. Composed expert agents produce better results than one agent trying to do everything.

Session 4: Non-determinism plus evaluation beats single attempts. And feedback loops make everything get better over time.

[PAUSE]

The meta-lesson across all four sessions: better context, better architecture, better feedback matter more than smarter models. That's context engineering. That's what you now know how to do.

---

## Slide 24: Thank You
**[~1 min]**

Resources are on the screen. Claude Code docs, the Agent SDK, ngrok AI Gateway, the context engineering guide, and the course repo with everything we built.

Quick reference on current models — Opus 4.7 is the latest, a million-token context, best for complex reasoning. Sonnet 4.6 is fast and capable for general use. Haiku 4.5 is cheap and fast for triage and routing. That model routing we talked about in Session 3? Now you know the current lineup.

[PAUSE]

Look at what you built in four sessions. You walked in knowing how to prompt an LLM. You're walking out knowing how to architect agent systems. That's a real skill. Take it and build something great.

Thank you. Questions?
