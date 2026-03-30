# Build Schedule

Generate a formatted markdown schedule from an event plan.

## Event
$ARGUMENTS

## Instructions

1. Read the event plan from `events/$ARGUMENTS.json`
2. Read `data/speakers.json` for speaker details
3. Read `data/venues.json` for venue information

4. Generate a markdown schedule that includes:
   - Event title and date
   - Venue name and address
   - A markdown table with columns: Time, Duration, Type, Title, Speaker
   - Notes section with venue logistics (parking, transit, amenities)
   - Speaker bios for each presenter

5. Follow schedule constraints from `CLAUDE.md`:
   - Breaks every 60-90 minutes
   - 15 min buffer at start and end
   - No speaker double-booking

6. Write the schedule to `schedules/$ARGUMENTS.md`

7. Confirm the file was written and summarize the schedule.
