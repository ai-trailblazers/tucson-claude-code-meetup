# Session 2 Speaker Script

**Total time:** ~70 minutes (25 min instruction, 40 min exercise, 5 min wrap)

---

## Instructor Prep — Demo Root

All live demos in this session (Slides 7, 13, 14) read files like `events/building-rag-pipelines.json` and `examples/sample-event-plan.json`. These exist in `solution/session-1/`, **not** in the course repo root.

**Before the session, from the course repo root:**
```bash
rm -rf ~/dry-run-meetup
cp -r solution/session-1 ~/dry-run-meetup
cd ~/dry-run-meetup
git init -q && git add -A && git -c user.email=you@local commit -q -m "Session 1 state"
cp ../tucson-meetup/templates/.claude/commands/*.md .claude/commands/   # generate-prp, execute-prp
cp ../tucson-meetup/templates/INITIAL_EXAMPLE.md ./INITIAL.md           # for the Slide 13 demo
claude
```

This gives you a clean post-Session-1 workspace with:
- `events/building-rag-pipelines.json`, `examples/sample-event-plan.json`, `data/{speakers,venues}.json` (used in the Slide 7 demo)
- `.claude/commands/{plan-event,generate-prp,execute-prp}.md` (used in Slides 13, 14)
- `INITIAL.md` (the MeetupBot comms-and-scheduling feature request, ready for Slide 13)

Run all live demos from this directory. Keep a second terminal at the course repo root for navigating the slides.

---

## Slide 1: Title
**[~1 min]**

"Welcome back everyone! Session 2. Last time we got our feet wet with Claude Code — you set up repos, wrote CLAUDE.md files, and built your first slash command. Today we're going to level up in a big way."

"The subtitle here is 'Blueprints Beat Prompts,' and by the end of this session you'll understand exactly what that means. We're moving past prompt engineering into something much more powerful."

**Transition:** "Let's quickly recap where we left off."

---

## Slide 2: Recap — Where We Left Off
**[~1 min]**

"So after Session 1, everyone should have a git repo with a CLAUDE.md, a working `/plan-event` command, an LLM provider connected — most of you are on Claude Code Max — and some sample data. If anyone is missing any of those pieces, flag me during the exercise and we'll get you caught up."

"Today we're building the comms and scheduling system — but we're doing it with a completely different approach than last time. Last session was about getting hands on the tool. This session is about using it *well*."

**Transition:** "Here's what we're building toward."

---

## Slide 3: Today's Goal
**[~2 min]**

"By the end of today, you'll have a pipeline. `/plan-event` generates the event plan, `/build-schedule` takes that plan and creates a schedule, and `/draft-announcement` takes that same plan and writes the announcement email. Each command feeds into the next."

"But the real learning isn't the pipeline itself. It's *how* we build it. You're going to learn about INITIAL.md — which is basically a feature request format that AI actually understands. You'll learn about PRPs, which are implementation blueprints. And you'll see how composable commands let you build complex workflows from simple pieces."

"The examples folder trick alone is going to change how you work with AI tools. Trust me on that one."

**Transition:** "But first, let's talk about why most AI agent projects fail."

---

## Slide 4: The Core Problem
**[~2 min]**

"Here's something I see constantly. Someone builds an AI agent, it produces mediocre output, and they say 'the model isn't good enough' or 'AI can't do this task.' But when you dig in, the model was perfectly capable. It just didn't have the right information."

"Wrong output format? Nobody told it the schema. Missed a constraint? It wasn't in the prompt. Generic tone? There were no examples to match against."

"The model isn't the bottleneck. Your context is. And that realization is what separates people who get good results from AI from people who don't."

[PAUSE] "Has anyone here had that experience? Where the AI gave you something technically correct but totally wrong for your use case?"

*Take 1-2 responses. Validate their experiences.*

**Transition:** "Before we get to the solution, I want to show you what 'no context' looks like in the wild."

---

## Slide 5: You've Already Seen This Problem
**[~2 min]**

"There's a researcher named Adrian Krebs who scored 500 Show HN sites for AI design markers. Two-thirds of them used the same handful of patterns. Same Inter font, same purple gradient hero, same shadcn cards with icons on top, same 'INTRODUCING' badge. It's an entire aesthetic — and it's not because designers all agreed on it. It's because the AI had nothing else to go on."

"These sites aren't bad. They're just identical. The AI fell back to the most common patterns in its training data because nobody told it what to do differently."

"I want you to hold onto this image because **the same thing happens to your agent's output.** Generic event plans, generic emails, generic schedules. No examples, no brand, no constraints — and the AI defaults to the average of everything it's seen."

[PAUSE] "The fix for design slop is the same as the fix for agent slop: give the AI a brand, examples, constraints, and a system. That's context engineering."

**Transition:** "Now let's compare prompt engineering and context engineering side by side."

---

## Slide 6: Prompt Engineering vs. Context Engineering
**[~2 min]**

"Prompt engineering is what most people think AI work is. You craft the perfect sentence, you add 'think step by step,' you try different phrasings until something works. It's like writing a sticky note and hoping the person reading it has enough background to figure out what you mean."

"Context engineering is different. Instead of crafting clever wording, you build a complete system. You give the AI the schema, the examples, the rules, the audience data, the tone guide — everything it needs to do the job right."

"The key mental shift is in that last row. Prompt engineering *hopes* the AI guesses right. Context engineering *gives* the AI everything it needs. When something goes wrong, the question isn't 'why is the AI dumb?' — it's 'what context did I forget to include?'"

**Transition:** "Let me show you what this looks like in practice."

---

## Slide 7: LIVE DEMO — The Difference
**[~3 min]**

> **Cwd:** Run from the post-Session-1 demo workspace described in "Instructor Prep — Demo Root" at the top of this file. The prompts below reference `events/`, `data/`, and `examples/` paths that only exist in that pre-staged directory — they will fail from the course-repo root.

[DEMO] Open Claude Code.

"I'm going to run the same task with two different approaches. Watch the output quality."

*Type Prompt 1:* `Write an announcement email for a RAG meetup`

"Okay, it wrote something. It's... fine. Generic. It made up a date, made up speakers, used a bland tone. This is what prompt engineering gets you."

*Now type Prompt 2:* `Read the event plan at events/building-rag-pipelines.json, read data/speakers.json for speaker bios, and read examples/sample-event-plan.json for the expected format. Write an announcement email targeting intermediate Python developers. Keep it under 200 words, include the date, venue, and speaker highlights.`

"Now look at this. Real speaker names. Actual date from the event plan. Venue details. The tone matches our examples. It's specific, it's accurate, it's usable."

[PAUSE] "See the difference? Same model, same task. Completely different results. The only thing that changed was the context."

**This is the aha moment.** Let it land. Give people a few seconds to process.

> **Common question:** "Isn't the second prompt just longer? Isn't this just writing better prompts?"
> **Answer:** "Sort of, but the key difference is *where* the information comes from. In context engineering, you're not putting knowledge in the prompt — you're pointing to files, schemas, and examples that already exist in your system. The prompt says 'read this file,' not 'here's everything about the event.' That's what makes it scalable."

**Transition:** "So how do we systematize this? Let me show you the full stack."

---

## Slide 8: The Context Engineering Stack
**[~1 min]**

"Think of this as layers of a briefing packet. CLAUDE.md is always loaded — it's the baseline rules. Examples give the AI patterns to match. Data gives it real information. INITIAL.md tells it what feature to build. PRPs tell it exactly how. And slash commands make it all reusable."

"Each layer adds context. You've already built the first three layers in Session 1. Today we're adding INITIAL.md, PRPs, and more slash commands."

**Transition:** "Let's start with INITIAL.md."

---

## Slide 9: INITIAL.md — The Feature Request
**[~2 min]**

"INITIAL.md is a structured feature request. Four sections. FEATURE is what to build — be specific about inputs and outputs. EXAMPLES points to files the AI should learn from. DOCUMENTATION covers schemas and constraints. And OTHER CONSIDERATIONS is where you put the gotchas."

"This replaces the vague Slack message that says 'hey can you build a scheduling thing.' Instead, you're giving Claude a complete brief."

"There's a blank template at `templates/INITIAL.md` and a filled-out example at `templates/INITIAL_EXAMPLE.md` in the repo. But I'd encourage you to write your own from scratch first — that's where the learning happens."

"The magic is that this format works for *any* feature, not just our meetup bot. You could use this for building API endpoints, data pipelines, UI components — anything."

> **Common question:** "Does INITIAL.md have to be called INITIAL.md?"
> **Answer:** "No, you can call it whatever you want. The name is a convention. What matters is the structure — those four sections. Some teams use FEATURE_REQUEST.md or just put it in an issue template."

**Transition:** "Let me show you what good vs. bad looks like."

---

## Slide 10: Good vs. Bad Feature Requests
**[~1 min]**

"The bad example is six words. 'Build a scheduling system for meetups.' What does Claude do with that? It guesses. And it guesses wrong."

"The good example says exactly where data comes from, what constraints exist, and what the output looks like. Claude can execute this without asking a single clarifying question."

"The rule is simple: specific beats vague, always. If you find yourself writing something vague, stop and add details. Point to files. Name constraints. Describe the output format."

**Transition:** "Once you have a good INITIAL.md, the next step is turning it into a PRP."

---

## Slide 11: PRPs — Implementation Blueprints
**[~2 min]**

"PRP stands for Product Requirements Prompt. Think of it like a PRD — a product requirements document — but designed specifically for an AI coding assistant to execute."

"A PRP includes complete context, a step-by-step implementation plan, validation gates — which are basically tests that must pass before moving to the next step — and error handling patterns."

"The key idea is that you don't write PRPs by hand. Claude generates them from your INITIAL.md using a custom slash command called `/generate-prp`. This isn't built into Claude Code — it's a slash command we provide in the repo at `templates/.claude/commands/`. You'll copy it into your project before using it."

"The command reads your codebase, understands your patterns, and creates a blueprint that it can then follow."

"Why not just let Claude code from INITIAL.md directly? Because the PRP step gives you a checkpoint. You can review the plan before any code gets written. Catching a misunderstanding in a PRP is way cheaper than catching it in working code."

> **Common question:** "How is this different from just asking Claude to build the feature?"
> **Answer:** "Two reasons. First, the PRP step lets you review the plan before execution — it's a human checkpoint. Second, PRPs are reusable. If the execution goes sideways, you can re-run it from the same PRP. You separate the planning from the doing."

**Transition:** "Here's the full workflow."

---

## Slide 12: The PRP Workflow
**[~1 min]**

"You write INITIAL.md — that's the WHAT. You run `/generate-prp` and Claude creates the PRP — that's the HOW. Then you run `/execute-prp` and Claude builds the code."

"Notice the review step in the middle. You open the PRP, you check that it understood your intent, and only then do you execute. This is where you catch the 'oh it thinks I want X but I actually want Y' moments."

**Transition:** "Let me demo this live."

---

## Slide 13: LIVE DEMO — /generate-prp
**[~3 min]**

> **Cwd:** Run from the post-Session-1 demo workspace described in "Instructor Prep — Demo Root" at the top of this file. The prep step already copied `INITIAL.md` into the workspace.

[DEMO] In Claude Code, run: `/generate-prp INITIAL.md`

"Watch what Claude does here. It's not just reading INITIAL.md. It's reading CLAUDE.md for the rules, looking at existing commands to understand patterns, checking the data files to know what's available."

*Wait for generation to complete.*

"Now let's open the PRP it generated."

*Open PRPs/meetup-comms.md and scroll through it.*

"Look at this — it picked up the speaker availability constraint from data/speakers.json. It knows the event plan schema from CLAUDE.md. It planned out three commands. And there are validation steps."

[PAUSE] "Any questions about what you see in this PRP?"

**Transition:** "Now let's execute it."

---

## Slide 14: LIVE DEMO — /execute-prp
**[~3 min]**

> **Cwd:** Same demo workspace as Slide 13. Run `/execute-prp` immediately after `/generate-prp` so the PRP file is fresh.

[DEMO] Run: `/execute-prp PRPs/meetup-comms.md`

"Now Claude is following the blueprint. Watch it create the slash command files one by one."

*Let it run. Point out key moments as they happen.*

"See how it's creating build-schedule.md, draft-announcement.md, draft-speaker-outreach.md. Each one follows the pattern from our existing plan-event command."

"And now it's validating — checking that the commands reference the right data files and schemas."

"The key observation: Claude isn't guessing. It's following a blueprint you reviewed before any code got written."

> **Common question:** "What if the PRP is wrong? Do I have to regenerate the whole thing?"
> **Answer:** "No! You can edit the PRP directly. It's just a markdown file. Fix the part that's wrong and re-run /execute-prp. That's another benefit of the two-step process."

**Transition:** "Let me show you one more trick that makes all of this work better."

---

## Slide 15: The Examples/ Folder Trick
**[~1 min]**

"This is maybe the highest-leverage thing you'll learn today. If you want the AI to produce a specific style of output, don't describe it — show it. Put example files in an examples/ folder and point to them."

"More examples means dramatically better output. One example is good. Three examples and the AI starts pattern-matching style, tone, structure, formatting — things that are really hard to describe in words."

"This is why sample-event-plan.json exists in your repo. Every command that generates event data matches that format because Claude has a concrete example to reference."

**Transition:** "Now let's talk about how these commands fit together."

---

## Slide 16: Composable Slash Commands
**[~1 min]**

"This is the architecture. `/plan-event` outputs JSON. `/build-schedule` reads that JSON. `/draft-announcement` reads the same JSON. Each command is simple on its own, but they compose into a pipeline."

"This only works because of structured data. If `/plan-event` output freeform text, the next command would have to parse and guess. JSON schemas make the contract explicit. Every command knows exactly what it's getting and what it should produce."

**Transition:** "And the mechanism that makes this work is dollar-sign ARGUMENTS."

---

## Slide 17: $ARGUMENTS in Slash Commands
**[~1 min]**

"When you type `/build-schedule events/rag-pipelines.json`, everything after the command name becomes $ARGUMENTS. Inside the command markdown file, $ARGUMENTS gets replaced with that file path."

"This is how you make commands reusable. The command doesn't hardcode which event — it takes the path as input. Same command works for any event plan."

"Simple mechanism, powerful result. This is what makes the pipeline composable."

**Transition:** "Before we jump into the exercise, a few tips."

---

## Slide 18: Tips & Gotchas
**[~1 min]**

"Biggest mistake I see: people skip INITIAL.md and go straight to asking Claude to build things. Don't do that. The 15 minutes you spend on INITIAL.md saves you an hour of debugging."

"Second biggest mistake: not reviewing the PRP before executing. The PRP is your checkpoint. Read it. If something looks off, fix it before you execute."

"And the examples thing — if your EXAMPLES section says 'see the examples folder' instead of pointing to specific files, you're being vague. Be specific."

[PAUSE] "Any questions before we start building?"

*Take 2-3 questions if any.*

**Transition:** "Alright, let's build."

---

## Slide 19: BUILD TIME
**[~40 min — exercise time]**

"Open `sessions/session-2/EXERCISE.md` and follow the steps. You're building the full pipeline: plan-event into build-schedule into draft-announcement."

"The exercise has five steps. Step 1 is understanding the concepts — you just sat through that, so skim it. Step 2 is writing your INITIAL.md — that's the hardest part, spend time on it. Steps 3 and 4 are running generate-prp and execute-prp. Step 5 is testing the full pipeline."

"I'll be walking around. The most common place people get stuck is writing INITIAL.md. If you're staring at a blank file for more than 5 minutes, raise your hand and we'll talk through it."

"You've got about 40 minutes. Go."

*Walk around the room. Common issues to watch for:*
- **INITIAL.md too vague** — Help them add specific file paths and constraints
- **PRP looks wrong** — Remind them they can edit it before executing
- **Commands not finding data** — Check file paths in $ARGUMENTS
- **Schema mismatch** — Make sure CLAUDE.md schema matches sample data

> **Common question:** "My PRP looks different from my neighbor's. Is that okay?"
> **Answer:** "Totally fine. PRPs will vary based on your INITIAL.md and what Claude finds in your codebase. As long as it captures the right intent and constraints, different approaches are valid."

> **Common question:** "The execute-prp made a mistake. What do I do?"
> **Answer:** "Two options. You can edit the PRP and re-execute, or you can tell Claude what's wrong and ask it to fix it. The PRP approach means you can always re-run from a known starting point."

> **Common question:** "Do I need to run all three commands in the exercise, or just one?"
> **Answer:** "Try to get all three working. The pipeline is the whole point — each command should consume the JSON from the previous step. If you're running low on time, prioritize build-schedule since it's the most complex."

---

## Slide 20: Checkpoint
**[~2 min]**

"Alright, let's check in. Raise your hand if you have a working INITIAL.md."

*Wait for hands.*

"PRP generated?"

*Wait.*

"At least one of the three commands working — build-schedule, draft-announcement, or draft-speaker-outreach?"

*Wait.*

"Full pipeline end-to-end — plan-event feeding into at least one other command?"

*Wait.*

"Great. If you didn't get everything done, that's okay. The key concepts are INITIAL.md and PRPs. You can finish the implementation at home. Make sure you commit what you have."

**Transition:** "Let me give you a preview of what's coming next."

---

## Slide 21: What's Next — Session 3
**[~1 min]**

"Right now your MeetupBot is a solo performer. One agent does everything — planning, scheduling, writing emails. It works, but it doesn't scale well."

"Next session we're splitting it into specialists. A schedule optimizer that only thinks about scheduling. A comms reviewer that only critiques emails. And we'll wire up hooks that automate quality checks."

"Think of it as the difference between one person doing everything and a coordinated team of experts. Same work, much better results."

**Transition:** "Let's wrap up."

---

## Slide 22: Session 2 Recap
**[~2 min]**

"Three things to take away from today."

"One: context engineering beats prompt engineering. Stop trying to craft the perfect prompt. Instead, build a system that gives the AI complete information. Files, schemas, examples — that's what drives quality."

"Two: the workflow is INITIAL.md to PRP to execute. You describe what you want, Claude figures out how to build it, then Claude builds it. The PRP is your checkpoint — review before you execute."

"Three: composable commands via structured JSON. When your commands output structured data, they can feed into each other. That's how you build real workflows, not just one-off tasks."

"Before next session, make sure your pipeline works end-to-end. If you got stuck, the exercise file has everything you need. And add more examples to your examples/ folder — you'll see the quality improve."

"Thanks everyone. See you at Session 3."

[PAUSE] "Any final questions?"

*Take 2-3 questions if time permits.*
