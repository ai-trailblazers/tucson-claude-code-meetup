# Draft Announcement

Draft a meetup announcement for the given event plan.

## Event Plan
$ARGUMENTS

## Instructions

1. Read the event plan JSON file at the path provided in $ARGUMENTS.

2. Read `CLAUDE.md` for communications tone guidelines:
   - Engaging for developers, direct, slightly witty
   - Hook the target audience in the first sentence
   - Highlight what attendees will walk away with

3. Generate an announcement that includes:
   - A compelling headline/hook
   - What the event is about (1-2 paragraphs)
   - Key details: date, time, venue, format
   - What attendees will learn or gain
   - Prerequisites (if any)
   - How to RSVP
   - Speaker highlights

4. Use the comms-reviewer subagent to review the draft and improve it.

5. Save to `comms/{event-slug}-announcement.md`.

6. Confirm the announcement was written and summarize the key messaging.
