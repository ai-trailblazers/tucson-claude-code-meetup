# Session 1 Speaker Script

Total time: ~60 minutes (25 min instruction, 30 min exercise, 5 min wrap-up)

---

## Slide 1: Title
**Time: 1 min**

"Hey everyone, welcome to the Tucson Claude Code Meetup. I'm [name], and today we're doing something fun — we're going to build an AI agent feature from scratch. Not a toy demo. An actual slash command that generates structured event plans. By the end of tonight, you'll have something working on your machine."

"This is Session 1 of four. Each session builds on the last, so by Session 4 you'll have a full agent with subagents, hooks, and a feedback loop. But tonight — fundamentals. Let's get into it."

**Transition:** "First, let me show you the big picture."

---

## Slide 2: What We're Building
**Time: 2 min**

"We're building MeetupBot — an agent that helps run a tech meetup like this one. It plans events, schedules talks, drafts communications, and eventually learns from feedback."

"Why a meetup bot? Because it's a real problem with real constraints. You need dates that work, venues that fit, speakers who are available. It's messy enough to be interesting, but scoped enough to build in four sessions."

[PAUSE] "Quick show of hands — who here has used any AI coding tool before? ChatGPT, Copilot, Cursor, anything? Cool. And who's used Claude Code specifically? Great, we've got a mix. That's perfect."

**Transition:** "So what are we actually building tonight?"

---

## Slide 3: Today's Goal
**Time: 1 min**

"By the end of tonight, you'll type `/plan-event "Building RAG pipelines"` and get back structured JSON. A full event plan — date, speakers, agenda, logistics. All from a single command."

"To get there, we need to cover five things: git basics, Claude Code setup, CLAUDE.md, ngrok AI Gateway, and slash commands. Sounds like a lot, but each piece is small. They snap together like Legos."

**Transition:** "Let's start with what Claude Code actually is."

---

## Slide 4: What is Claude Code?
**Time: 2 min**

"Claude Code is not a chatbot. It's not autocomplete. It's an agent that lives in your terminal and understands your entire project."

"It reads your files, edits them, runs commands, searches your codebase. And the key thing — it follows rules you write in a file called CLAUDE.md. We'll get to that in a minute."

"Think of it as a really skilled junior developer who never gets tired, reads incredibly fast, but needs clear instructions to do good work. The quality of your instructions determines the quality of the output. That's the whole game."

**Transition:** "Let's get it installed."

---

## Slide 5: Installation
**Time: 3 min**

"Installation is one line. npm install, global flag, done."

[DEMO] Open terminal. Run:
```
npm install -g @anthropic-ai/claude-code
mkdir meetup-bot && cd meetup-bot
git init
claude
```

"That's it. Four commands and you're in Claude Code. You'll see it scan your project — right now it's empty, so there's not much to scan."

[PAUSE] "If you're following along and hit an issue with npm, make sure you're on Node 18 or higher. Run `node --version` to check. If you're stuck, flag me down during build time."

**Tip for common questions:** "If someone asks about Homebrew installation — yes, `brew install claude-code` works too. npm is just the universal path."

**Transition:** "Before we do anything in Claude Code, let's make sure you know the one git skill that matters."

---

## Slide 6: Git Basics — Just Enough
**Time: 1 min**

"I'm not going to teach you git. I'm going to teach you three commands. Think of commits as save points in a video game. You save before the boss fight, right? Same idea."

"`git init` — start tracking. `git add -A` — select everything. `git commit -m` with a message — save it."

"If you mess something up later tonight, you can always get back to a commit. That's why we commit early and often. It's your safety net."

**Transition:** "Now for the most important file in any Claude Code project."

---

## Slide 7: CLAUDE.md — Your Agent's Rulebook
**Time: 2 min**

"CLAUDE.md is the single most important concept tonight. It lives at your project root and Claude reads it at the start of every single conversation. Every time."

"This is where you define how your agent behaves. Output formats, constraints, personality, conventions. Whatever you put in here becomes law."

"This is what people mean when they say 'context engineering.' You're not writing a one-off prompt. You're programming persistent behavior. The difference is huge."

**Transition:** "So what actually goes in this file?"

---

## Slide 8: What Goes in CLAUDE.md?
**Time: 1 min**

"Here's a real example. We've got three sections: output format, schema, and personality."

"The output format says 'always return JSON.' The schema lists every field we expect. The personality section keeps things concise and practical."

"Notice how specific this is. We're not saying 'be helpful.' We're saying 'every event plan must include these seven fields.' Specificity is everything."

**Transition:** "And here's why we care so much about structure."

---

## Slide 9: Why Structured Output Matters
**Time: 1 min**

"Look at this table. On the left, freeform text. 'The event could be on March 15th...' On the right, a clean JSON date field."

"Freeform is fine if a human is reading it. But if another agent needs to consume this output — and in Session 3, it will — you need structure. JSON schemas make agents reliable. Full stop."

"This is one of those things that feels like extra work now but saves you hours later. Trust me on this one."

**Transition:** "Let me show you this in action."

---

## Slide 10: LIVE DEMO — Creating CLAUDE.md
**Time: 3 min**

[DEMO] In Claude Code:
1. First, ask Claude something without CLAUDE.md: "Plan a meetup about Python testing" — note the freeform response
2. Create CLAUDE.md with the schema from slide 8
3. Ask the same question — note the structured JSON response
4. Point out: "Same question, completely different output. The only thing that changed was CLAUDE.md."

"See that? Before CLAUDE.md, you get a nice essay. After CLAUDE.md, you get JSON that a machine can parse. That's the power of context engineering."

[PAUSE] "Any questions about CLAUDE.md before we move on? This is the foundation — everything else builds on it."

**Tip for common questions:** "Someone might ask 'can I have multiple CLAUDE.md files?' Yes — you can have them at different directory levels. Claude reads the nearest one first, then walks up. But for now, one at the root is all you need."

**Transition:** "Quick note on permissions before we get to the fun stuff."

---

## Slide 11: Permissions
**Time: 1 min**

"Claude Code asks permission before running commands. That's good — you want that guardrail. But if it's asking you to approve `git commit` for the twentieth time, it gets old."

"You can pre-approve commands in `.claude/settings.local.json`. Add git, python, whatever you trust. This stays local to your machine — it doesn't get committed to the repo."

"For tonight, interactive mode is fine. You'll set up allow lists during build time if you want."

**Transition:** "Now let's talk about how we're actually connecting to the AI models."

---

## Slide 12: ngrok AI Gateway — The Big Picture
**Time: 2 min**

"Here's the problem. You want to use Anthropic. Maybe you also want OpenAI as a fallback. Maybe Google for something else. That's three API keys, three billing accounts, three sets of rate limits. It's a mess."

"ngrok AI Gateway solves this. One endpoint, one API key, multiple providers behind it. Your app talks to the gateway. The gateway talks to the providers."

"Think of it like a reverse proxy for AI. Same idea as putting nginx in front of your web servers, but for language models."

[PAUSE] "Quick note — ngrok is actually sponsoring this meetup series, which is awesome. They're giving everyone gateway access tonight."

**Transition:** "Let me show you what it can actually do."

---

## Slide 13: ngrok AI Gateway — Key Features
**Time: 1 min**

"The headline features: one API key for everything, automatic failover if a provider goes down, cost-based routing — it can pick the cheapest model for a task — and PII redaction, which strips sensitive data before it leaves your network."

"And the best part — it's SDK compatible. You don't change your code. You change the base URL. That's it."

**Transition:** "Let me show you the setup."

---

## Slide 14: Setting Up ngrok Gateway
**Time: 2 min**

[DEMO] Show the config file:
1. Create `config/ngrok-gateway.json`
2. Walk through each field — gateway URL, API key, default model, fallbacks
3. Show how Claude Code can use `--api-base` to point at the gateway
4. "If the gateway isn't working for you tonight, no worries. You can fall back to your direct Anthropic key. The exercises work either way."

**Tip for common questions:** "If someone asks about latency — the gateway adds minimal overhead. We're talking single-digit milliseconds for routing. The model inference time dwarfs it."

**Transition:** "Alright, now for the payoff. Slash commands."

---

## Slide 15: Slash Commands
**Time: 1 min**

"Slash commands are custom workflows that live in your project. You create a markdown file in `.claude/commands/`, and it becomes a command you can run."

"plan-event.md becomes `/plan-event`. draft-email.md becomes `/draft-email`. The file name is the command name. Dead simple."

"And they take arguments. `$ARGUMENTS` in the file gets replaced with whatever the user types after the command."

**Transition:** "Let's look at what goes inside one."

---

## Slide 16: Anatomy of a Slash Command
**Time: 1 min**

"Here's our plan-event command. It's just markdown with instructions. Step 1: read CLAUDE.md. Step 2: generate the plan. Step 3: include all the required fields. Step 4: save it. Step 5: commit."

"Notice it references CLAUDE.md. The command says 'go read the rules, then follow them.' This is how you chain context — the command points to the rulebook, the rulebook defines the schema."

"And that IMPORTANT keyword at the bottom? That's not decoration. Claude actually weighs that higher. We'll talk about power keywords in a sec."

**Transition:** "Let me build this live."

---

## Slide 17: LIVE DEMO — Building /plan-event
**Time: 3 min**

[DEMO] In Claude Code:
1. Create `.claude/commands/` directory
2. Create `plan-event.md` with the content from the slide
3. Run `/plan-event "Building RAG pipelines"`
4. Watch Claude read CLAUDE.md, generate the plan, save it
5. Open the output file and show the JSON structure
6. "Look at that — date, speakers, agenda, logistics. All structured. All from one command."

[PAUSE] "Pretty cool, right? And this took us what, two minutes to set up? The command file is like ten lines of markdown."

**Tip for common questions:** "Someone will ask 'can I call one command from another?' Not directly in this version, but you can have Claude read multiple command files. We'll do exactly that in Session 3 with subagents."

**Transition:** "Before build time, a few pro tips."

---

## Slide 18: Power Keywords
**Time: 1 min**

"There are certain words that Claude pays extra attention to. IMPORTANT elevates priority. MUST and NEVER are hard constraints. 'Proactively' means 'do this without asking me first.'"

"But here's the thing — use these sparingly. If every sentence has IMPORTANT in it, Claude treats none of them as important. It's like the boy who cried wolf. Save these for the rules that really, truly matter."

"For us, 'always return JSON' is an IMPORTANT rule. 'Use a friendly tone' is not."

**Transition:** "A few more tips before I set you loose."

---

## Slide 19: Tips & Gotchas
**Time: 1 min**

"Quick hits. Be specific in CLAUDE.md — give it schemas and examples, not vibes. Commit before you experiment — save points, remember? And don't say 'production-ready' in your instructions. It means nothing to an AI. Say exactly what you mean."

"The biggest mistake I see beginners make: vague rules. 'Make good code' is useless. 'All functions must have type hints and Google-style docstrings' is useful. Be the annoyingly specific tech lead."

**Transition:** "Alright, it's build time."

---

## Slide 20: BUILD TIME
**Time: 30 min (exercise)**

"Here's where you get your hands dirty. The exercise is in `session-1/EXERCISE.md`. Your goal: get `/plan-event` generating structured JSON."

"You've got about 30 minutes. Here's my advice:"

"Step 1: get your repo set up and commit. Step 2: write CLAUDE.md. Step 3: build the slash command. Step 4: test it."

"If you finish early, try different topics. Try breaking your CLAUDE.md and see what happens. Try adding fields to the schema."

"Help your neighbor if they're stuck. Teaching is the best way to learn this stuff."

[PAUSE] "Raise your hand if you need help getting started."

**While students work:** Walk the room. Common issues to watch for:
- Node.js version too old
- Forgot to `git init`
- CLAUDE.md in wrong directory
- Typo in `.claude/commands/` path
- API key not set

---

## Slide 21: Checkpoint
**Time: 2 min**

"Alright, let's check in. Go through this list. Git repo — check? CLAUDE.md — check? Project structure with a data directory? ngrok configured or at least direct API working? The slash command runs? And you've got at least one event plan saved?"

[PAUSE] "Anyone missing something? Let's get you caught up real quick."

"If you've got all six, you're in great shape for Session 2."

**Tip for common questions:** "If someone didn't finish, reassure them: 'The exercise file has everything you need to finish at home. The key thing is you understand the concepts — CLAUDE.md, structured output, slash commands.'"

**Transition:** "Let me give you a taste of what's coming."

---

## Slide 22: What's Next — Session 2
**Time: 1 min**

"Session 2 is where it gets really interesting. We're going to talk about context engineering — and I don't mean prompting. I mean building blueprints that shape how your agent thinks about entire workflows."

"We'll cover INITIAL.md — that's your project bootstrap file. PRPs — prompt-reusable patterns. And we'll build a comms system so MeetupBot can draft emails and social posts."

"Session 1 gave you the tools. Session 2 teaches you to think in systems."

**Transition:** "Quick recap and we're out."

---

## Slide 23: Session 1 Recap
**Time: 1 min**

"Three things. Write them down if you want."

"One: CLAUDE.md is your agent's brain. Every rule shapes every response. Invest time here."

"Two: Structured output beats freeform text. Every time. JSON schemas make agents reliable and composable."

"Three: ngrok AI Gateway gives you one endpoint for many providers. Simplify your keys, add failover, control costs."

"You just built your first agent feature. That's not nothing. Nice work tonight."

[PAUSE] "Questions before we wrap? ... Great. See you at Session 2. And commit your work before you close your laptop."

---

## Timing Summary

| Section | Slides | Time |
|---|---|---|
| Intro & Setup | 1-6 | 8 min |
| CLAUDE.md & Structure | 7-10 | 7 min |
| Permissions & ngrok | 11-14 | 6 min |
| Slash Commands & Tips | 15-19 | 4 min |
| **Build Time** | **20** | **30 min** |
| Wrap-up | 21-23 | 5 min |
| **Total** | | **~60 min** |
