## FEATURE:
Build a communications and scheduling system for MeetupBot. The system should:
- Generate event schedules that fit talks into time slots with breaks, using speaker availability from `data/speakers.json`
- Draft announcement emails tailored to the target audience from the event plan
- Draft personalized speaker outreach emails referencing their topics and past talks
- All commands should consume the structured event plan JSON from `/plan-event` output

## EXAMPLES:
- Event plan format: see `examples/sample-event-plan.json`
- Speaker data: see `data/speakers.json` (note the `availability` field)
- Venue data: see `data/venues.json` (note `capacity` and `amenities`)
- Existing command pattern: see `.claude/commands/plan-event.md` for how slash commands are structured

## DOCUMENTATION:
- Event plan JSON schema is defined in `CLAUDE.md`
- Schedules should account for: talk duration, speaker availability, break intervals (every 60–90 min), 15-min setup buffer, 15-min networking at end
- Announcement emails should include: event name, date, venue, speaker highlights, RSVP link placeholder, target-audience hook
- Speaker outreach should include: personalized topic reference, event description, logistics, the ask

## OTHER CONSIDERATIONS:
- IMPORTANT: All slash commands must read the event plan JSON as input — never ask the user to retype event details
- Schedule must validate that no speaker is double-booked
- Announcements should match the tone defined in `CLAUDE.md`
- Use `$ARGUMENTS` in slash commands for the event plan file path
- `/build-schedule` should output both a markdown table and a JSON file
