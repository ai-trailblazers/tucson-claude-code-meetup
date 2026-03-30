## FEATURE:
Build a communications and scheduling system for MeetupBot. The system should:
- Generate event schedules that fit talks into time slots with breaks, using speaker availability from data/speakers.json
- Draft announcement emails tailored to the target audience from the event plan
- Draft personalized speaker outreach emails referencing their topics and past talks
- All commands should consume the structured event plan JSON from /plan-event output

## EXAMPLES:
- Event plan format: see examples/sample-event-plan.json
- Speaker data: see data/speakers.json (note the availability field)
- Venue data: see data/venues.json (note the capacity and amenities fields)
- Existing command pattern: see .claude/commands/plan-event.md for how slash commands are structured

## DOCUMENTATION:
- Event plan JSON schema is defined in CLAUDE.md
- Schedules should account for: talk duration, speaker availability, break intervals (every 90 min), setup/teardown time
- Announcement emails should include: event name, date, venue, speaker highlights, RSVP link placeholder, target audience hook
- Speaker outreach should include: personalized topic reference, event description, logistics, ask

## OTHER CONSIDERATIONS:
- IMPORTANT: All slash commands must read the event plan JSON as input, not ask the user to retype details
- Schedule must validate that no speaker is double-booked
- Announcements should match the tone defined in CLAUDE.md
- Use $ARGUMENTS in slash commands for the event plan file path
- The /build-schedule command should output a markdown table AND a JSON file
