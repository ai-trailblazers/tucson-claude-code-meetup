# Draft Speaker Outreach

Draft personalized speaker outreach emails for the given event plan.

## Event Plan
$ARGUMENTS

## Instructions

1. Read the event plan JSON file at the path provided in $ARGUMENTS.

2. Read `data/speakers.json` to get full details on each suggested speaker.

3. Read `CLAUDE.md` for communications tone guidelines:
   - Professional but warm
   - Reference the speaker's specific expertise and past contributions
   - Be clear about the ask and logistics

4. For each suggested speaker in the event plan, draft a personalized email that includes:
   - A warm greeting referencing their work
   - What the event is about and why they are a great fit
   - The specific role/slot they are being asked to fill
   - Logistics: date, time, venue, expected audience size
   - What MeetupBot will provide (AV equipment, travel, etc.)
   - A clear call to action

5. Use the comms-reviewer subagent to review the drafts.

6. Save all outreach emails to `comms/{event-slug}-speaker-outreach.md`.

7. Confirm the outreach was drafted and list the speakers contacted.
