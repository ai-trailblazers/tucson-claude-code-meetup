# PRP: MeetupBot Communications & Scheduling System

## Context

MeetupBot currently supports event planning via the `/plan-event` slash command, which generates a structured JSON event plan with speakers, venue, schedule, and cost estimates. This PRP extends MeetupBot with three new slash commands for communications and scheduling workflows that consume the event plan JSON as input.

### Relevant Files
- `CLAUDE.md` — Agent personality, output format, event plan schema, naming conventions, tone guidelines, schedule constraints
- `data/speakers.json` — Speaker roster with topics, availability, past talk counts, ratings, and preferred formats
- `data/venues.json` — Venue list with addresses, capacity, amenities, cost, and parking/transit info
- `examples/sample-event-plan.json` — Reference event plan showing the correct JSON schema
- `.claude/commands/plan-event.md` — Existing slash command pattern to follow for new commands
- `events/` — Directory where event plan JSON files are stored (output of /plan-event)

### Key Constraints from CLAUDE.md
- All event data uses camelCase JSON keys and kebab-case file names
- Schedule constraints: breaks every 60-90 min, 15 min setup buffer, 15 min networking at end
- Talk slots: 20-30 min. Workshop slots: 30-60 min. Panel slots: 30-45 min.
- Announcement tone: engaging for developers, direct, slightly witty
- Speaker outreach tone: professional but warm, reference specific expertise

## Implementation Plan

### Command 1: `/build-schedule`

**File**: `.claude/commands/build-schedule.md`

**Purpose**: Generate an optimized event schedule from an event plan JSON, respecting speaker availability and timing constraints.

**Input**: Event plan file path via `$ARGUMENTS` (e.g., `events/building-rag-pipelines.json`)

**Steps**:
1. Read the event plan JSON from the provided file path
2. Read `data/speakers.json` to cross-reference speaker availability
3. Validate that all suggested speakers are available for the event's time slot:
   - Parse the event date to determine if it falls on a weekday evening, Saturday, Sunday, or weekend
   - Check each speaker's `availability` array against the event timing
   - Flag any conflicts and suggest alternatives if a speaker is unavailable
4. Build the schedule respecting these rules:
   - Start with a 15-minute setup/doors-open slot
   - Assign talk slots (20-30 min) and workshop slots (30-60 min) based on speaker formats
   - Insert a 15-minute break after every 60-90 minutes of continuous content
   - End with a 15-minute networking/Q&A slot
   - Ensure no speaker appears in overlapping time slots
   - Total duration should match the event plan's `suggestedDuration`
5. Output a markdown table to `schedules/{event-slug}.md` with columns: Time, Duration, Type, Title, Speaker
6. Update the `schedule` field in the event plan JSON and write it back to the original file
7. Print a summary of the generated schedule and any availability warnings

**Output files**:
- `schedules/{event-slug}.md` — Human-readable markdown schedule
- `events/{event-slug}.json` — Updated event plan with schedule embedded

### Command 2: `/draft-announcement`

**File**: `.claude/commands/draft-announcement.md`

**Purpose**: Draft an announcement email for the event, ready to send to the mailing list.

**Input**: Event plan file path via `$ARGUMENTS`

**Steps**:
1. Read the event plan JSON from the provided file path
2. Read `data/venues.json` to get full venue details (address, parking, transit)
3. Compose an announcement email with these sections:
   - **Subject line**: Catchy, includes event name and date
   - **Opening hook**: 1-2 sentences targeting the specific audience, slightly witty
   - **Event details**: Name, date, time, duration
   - **What you'll learn**: 3-4 bullet points derived from the topic tags and description
   - **Speaker highlights**: Brief intro for each speaker with their key credential
   - **Venue info**: Name, address, parking, transit access
   - **RSVP link**: Placeholder `[RSVP HERE](https://meetup.example.com/rsvp/{event-slug})`
   - **Prerequisites** (if any): Listed from the event plan
4. Apply the tone defined in CLAUDE.md: engaging for developers, direct, slightly witty
5. Save to `comms/{event-slug}-announcement.md`
6. Confirm the file was written and print a preview of the subject line and opening

**Output file**: `comms/{event-slug}-announcement.md`

### Command 3: `/draft-speaker-outreach`

**File**: `.claude/commands/draft-speaker-outreach.md`

**Purpose**: Draft personalized outreach emails to each suggested speaker for the event.

**Input**: Event plan file path via `$ARGUMENTS`

**Steps**:
1. Read the event plan JSON from the provided file path
2. Read `data/speakers.json` to get full speaker profiles
3. For each speaker in `suggestedSpeakers`, compose a personalized email:
   - **Subject line**: Personalized with speaker name and event topic
   - **Greeting**: Use the speaker's first name
   - **Personal hook**: Reference 1-2 of their specific topics from speakers.json, mention their past talk count and rating
   - **Event description**: What the event is about, who the audience is, expected attendance
   - **The ask**: Specific talk format and topic area they'd cover, based on the `reason` field
   - **Logistics**: Date (or TBD), venue name and address, duration of their slot
   - **Closing**: Express genuine interest, provide next steps (confirm interest, discuss topic details)
4. Apply the speaker outreach tone from CLAUDE.md: professional but warm
5. Save all outreach emails to a single file `comms/{event-slug}-speaker-outreach.md` with clear separators between each email
6. Confirm the file was written and list which speakers were included

**Output file**: `comms/{event-slug}-speaker-outreach.md`

## Directory Structure (New)

```
schedules/
  {event-slug}.md          # Markdown schedule tables
comms/
  {event-slug}-announcement.md       # Announcement email drafts
  {event-slug}-speaker-outreach.md   # Speaker outreach email drafts
PRPs/
  meetup-comms.md           # This PRP
```

## Validation Gates

### Gate 1: Command Files Exist
- [ ] `.claude/commands/build-schedule.md` exists and follows the pattern from `plan-event.md`
- [ ] `.claude/commands/draft-announcement.md` exists and follows the pattern
- [ ] `.claude/commands/draft-speaker-outreach.md` exists and follows the pattern
- [ ] All three commands accept `$ARGUMENTS` as the event plan file path

### Gate 2: Schedule Generation
- [ ] Running `/build-schedule events/building-rag-pipelines.json` produces `schedules/building-rag-pipelines.md`
- [ ] The markdown file contains a properly formatted table with Time, Duration, Type, Title, Speaker columns
- [ ] The schedule includes setup, content, breaks, and networking slots
- [ ] No speaker is double-booked in overlapping time slots
- [ ] Breaks appear at least every 90 minutes of content
- [ ] The event plan JSON is updated with the schedule

### Gate 3: Announcement Draft
- [ ] Running `/draft-announcement events/building-rag-pipelines.json` produces `comms/building-rag-pipelines-announcement.md`
- [ ] The announcement includes: event name, date, venue with address, speaker highlights, topic description
- [ ] Contains an RSVP link placeholder
- [ ] Tone matches CLAUDE.md guidelines (engaging, direct, slightly witty)
- [ ] Prerequisites are listed if present in the event plan

### Gate 4: Speaker Outreach
- [ ] Running `/draft-speaker-outreach events/building-rag-pipelines.json` produces `comms/building-rag-pipelines-speaker-outreach.md`
- [ ] Each suggested speaker has a personalized email
- [ ] Emails reference the speaker's specific topics and past talk count
- [ ] Emails include event logistics (date, venue, their specific role)
- [ ] Tone is professional but warm per CLAUDE.md

### Gate 5: Integration
- [ ] CLAUDE.md is updated with new data locations (schedules/, comms/)
- [ ] CLAUDE.md includes communications tone guidelines
- [ ] CLAUDE.md includes schedule constraint rules
- [ ] All file naming follows kebab-case convention

## Success Criteria

1. **A user can go from event idea to ready-to-send communications in three commands**: `/plan-event` -> `/build-schedule` -> `/draft-announcement` + `/draft-speaker-outreach`
2. **No manual data re-entry**: Every command reads from the event plan JSON, not from user input
3. **Schedule constraints are enforced**: Breaks, buffers, and no double-booking
4. **Communications are personalized**: Announcements target the right audience, outreach references individual speaker expertise
5. **All outputs follow naming conventions**: kebab-case files, camelCase JSON, consistent directory structure
6. **The pattern is extensible**: Adding a new communication type (e.g., sponsor outreach) would follow the same slash command pattern

## Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Speaker availability doesn't match event date | build-schedule validates availability and flags conflicts |
| Schedule math errors (overlapping slots) | build-schedule calculates cumulative time and validates no overlaps |
| Announcement tone too casual or too formal | CLAUDE.md defines tone explicitly; sample output serves as reference |
| Event plan JSON missing required fields | Commands should fail gracefully with clear error messages |

## Estimated Effort

- `/build-schedule` command: Medium complexity (availability validation, time math, dual output)
- `/draft-announcement` command: Low complexity (template-style generation from JSON)
- `/draft-speaker-outreach` command: Low-medium complexity (personalization per speaker)
- CLAUDE.md updates: Low complexity (adding sections for tone and schedule rules)
- Total: ~45 minutes of focused work with Claude Code
