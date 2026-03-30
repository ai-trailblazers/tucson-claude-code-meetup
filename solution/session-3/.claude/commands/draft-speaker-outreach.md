# Draft Speaker Outreach

Draft personalized outreach emails to suggested speakers for an event.

## Event
$ARGUMENTS

## Instructions

1. Read the event plan from `events/$ARGUMENTS.json`
2. Read `data/speakers.json` for full speaker profiles

3. For each suggested speaker in the event plan, draft a personalized email that includes:
   - Greeting using their first name
   - Reference to their specific expertise and past contributions
   - What the event is about and why they're a great fit
   - The specific ask (talk title, format, duration)
   - Logistics: proposed date, venue, expected audience size
   - A clear call to action (confirm availability, suggest alternative dates)
   - Professional but warm tone

4. Follow the communications tone from `CLAUDE.md`:
   - Professional but warm
   - Reference specific expertise
   - Be clear about the ask and logistics

5. Write all outreach emails to a single file: `comms/$ARGUMENTS-speaker-outreach.md`

6. Confirm the file was written and list the speakers contacted.
