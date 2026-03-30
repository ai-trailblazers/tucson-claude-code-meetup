# Build Schedule

Generate a detailed schedule for an existing event plan.

## Event Plan
$ARGUMENTS

## Instructions

1. Read the event plan JSON file at the path provided in $ARGUMENTS (e.g., `events/building-rag-pipelines.json`).

2. Read `CLAUDE.md` for schedule constraints:
   - Break every 60-90 minutes of content
   - 15 minutes setup at start
   - 15 minutes networking at end
   - No speaker overlaps
   - Talk slots: 20-30 min, Workshop: 30-60 min, Panel: 30-45 min

3. Use the schedule-optimizer subagent to validate the schedule.

4. Generate a markdown schedule with:
   - Event title and date
   - Time, duration, type, and title for each slot
   - Speaker names where applicable
   - Notes on setup requirements or transitions

5. Save to `schedules/{event-slug}.md`.

6. Confirm the schedule was generated and flag any constraints that were tight.
