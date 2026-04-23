# Session 1 Exercise: Set Up Your MeetupBot + Event Planning

## Goal
Create a new repo from scratch, set up Claude Code with a CLAUDE.md, connect to ngrok AI Gateway, and build your first slash command that generates structured event plans.

## Step 1: Install & Authenticate (10 min)

```bash
# Install Claude Code
npm install -g @anthropic-ai/claude-code

# Create your project from scratch
mkdir meetup-agent && cd meetup-agent

# Initialize a git repo
git init

# Create a README
echo "# MeetupBot" > README.md
echo "An AI-powered agent for organizing AI developer meetups." >> README.md

# First commit
git add README.md
git commit -m "Initial commit"

# Launch Claude Code
claude
```

> **Multiple ways to use Claude Code:** The CLI is the core experience, but Claude Code also runs as a Desktop app (Mac/Windows), a Web app at `claude.ai/code`, and as extensions for VS Code and JetBrains IDEs. We'll use the CLI in this course, but the features and patterns are identical across all surfaces.

> **Tip:** Once you're in Claude Code, try `/powerup` — it launches interactive lessons that teach you features through animated demos. Great for discovering capabilities you didn't know existed.

## Step 2: Create Your CLAUDE.md (15 min)

Ask Claude to help you create a CLAUDE.md for your meetup agent:

```
Create a CLAUDE.md for a meetup planning agent called MeetupBot. This agent helps organize AI developer meetups.

Include rules for:
- Agent personality: friendly, organized, opinionated about good event structure
- Output format: all event data must be structured JSON, not freeform text
- Event plan schema: name, description, format (workshop/talk/panel/hackathon), targetAudience, estimatedAttendees, suggestedDuration, topicTags, prerequisites
- Data locations: venues in data/venues.json, speakers in data/speakers.json, past events in data/past-events/
- Naming conventions: kebab-case for files, camelCase for JSON keys
- Style: concise, actionable recommendations over vague suggestions
- A "Known Gotchas" section (start empty — we'll fill this in Step 6 as we discover failure points)
```

**Review the CLAUDE.md** — does it capture the rules you'd want for a meetup agent? Edit anything that feels off.

## Step 3: Set Up Project Structure (10 min)

Ask Claude to scaffold the project:

```
Create the project structure for MeetupBot:
- data/ folder with sample venues.json (5 venues with name, capacity, address, amenities, costPerHour)
- data/ folder with sample speakers.json (8 speakers with name, topics, bio, availability)
- data/past-events/ empty folder with a .gitkeep
- examples/sample-event-plan.json showing the expected output format
- events/ empty folder for generated event plans
- schedules/ empty folder for generated schedules
- comms/ empty folder for drafted communications
- config/ngrok-gateway.json with placeholder values for baseUrl and apiKey
- .claude/settings.local.json with permissions for Edit, Read, Write, Glob, Grep, Bash(git *)

Follow the rules in CLAUDE.md.
```

> **Permission modes:** Claude Code has three ways to handle permissions:
> - **Interactive** (default): Approve each tool use individually
> - **Auto Mode** (`Shift+Tab` to toggle): A classifier handles permissions — safe actions run uninterrupted, risky ones get blocked. Good middle ground for development.
> - **Allowlist**: Pre-configure allowed tools in `.claude/settings.local.json` (what we're doing above)

## Step 4: Connect to ngrok AI Gateway (10 min)

Update `config/ngrok-gateway.json` with your actual credentials:

```json
{
  "baseUrl": "https://your-gateway.ngrok.app/v1",
  "apiKey": "your-ngrok-ai-gateway-key",
  "defaultModel": "ngrok/auto",
  "fallbackModel": "gpt-4o-mini"
}
```

> **No ngrok account?** You can use a direct provider URL instead:
> ```json
> {
>   "baseUrl": "https://api.openai.com/v1",
>   "apiKey": "your-openai-key",
>   "defaultModel": "gpt-4o",
>   "fallbackModel": "gpt-4o-mini"
> }
> ```
> The agent works identically — ngrok adds routing and failover on top.

## Step 5: Build /plan-event (10 min)

Create your first slash command. Ask Claude:

```
Create a slash command at .claude/commands/plan-event.md that:
1. Takes a topic as $ARGUMENTS (e.g., "Building RAG pipelines")
2. Reads data/venues.json and data/speakers.json for context
3. Generates a structured event plan as JSON matching the schema in CLAUDE.md
4. Suggests 2-3 speakers from the speakers.json who match the topic
5. Recommends a venue from venues.json based on estimated attendance
6. Writes the plan to a file like events/building-rag-pipelines.json

IMPORTANT: The output must be valid JSON matching the schema defined in CLAUDE.md.
Use the ngrok AI Gateway config from config/ngrok-gateway.json.
```

## Step 6: Test, Diagnose, and Self-Correct (10 min)

Test your slash command:

```
/plan-event Building RAG pipelines
```

**Now look for problems in the output.** Common issues on first runs:
- JSON keys don't match the schema in CLAUDE.md
- Speaker suggestions don't reference actual speakers from `data/speakers.json`
- Venue recommendation ignores capacity vs. estimated attendees
- Missing fields or inconsistent formatting

**This is the key pattern: CLAUDE.md is a self-correcting system.** When you spot a problem, don't just re-prompt — update CLAUDE.md to prevent it from ever happening again:

```
The /plan-event output had [describe the problem]. Update CLAUDE.md to add a 
"Known Gotchas" section that documents this failure and adds a rule to prevent it.
```

For example, if speakers weren't matched from the data file:
```markdown
## Known Gotchas
- Speaker suggestions MUST reference actual entries from data/speakers.json by name — never invent speakers
- Venue recommendations MUST compare estimatedAttendees against venue capacity — never suggest a venue that's too small
- All JSON output MUST validate against the schema above — missing fields are a failure
```

**Why this matters:** Every correction you encode in CLAUDE.md prevents the same mistake across all future commands, all future sessions, and all team members. This is what makes CLAUDE.md the highest-leverage file in your project — it compounds.

Now test again with the fix in place:
```
/plan-event Introduction to AI Agents
```

```
/plan-event Fine-tuning LLMs on a budget
```

Compare the outputs — are they more consistent after updating CLAUDE.md? This diagnose -> fix -> retest loop is how production agent systems are tuned.

Commit your work:
```bash
git add -A
git commit -m "feat: MeetupBot project setup with plan-event command"
```

## Checkpoint ✓

You should now have:
- [ ] Claude Code installed and authenticated
- [ ] A git repo with at least 2 commits
- [ ] CLAUDE.md with meetup agent rules and JSON schemas
- [ ] `data/venues.json` with 5 sample venues
- [ ] `data/speakers.json` with 8 sample speakers
- [ ] `config/ngrok-gateway.json` configured
- [ ] `.claude/commands/plan-event.md` working slash command
- [ ] `examples/sample-event-plan.json` reference output
- [ ] At least one generated event plan in `events/`

## Bonus Challenges

1. Add a `data/topics-calendar.json` with seasonal AI topics (e.g., "NeurIPS recap" in December) and have `/plan-event` suggest timely topics
2. Try the `IMPORTANT` keyword in your CLAUDE.md and see how it changes the agent's behavior
3. Generate 3 event plans and compare — is the JSON schema consistent? If not, tighten your CLAUDE.md rules
4. Try `/fast` to toggle fast mode (same model, faster output) and compare the experience
5. Experiment with effort levels: type `/effort low` for quick tasks and `/effort high` for complex reasoning
