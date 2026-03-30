# Build Schedule

Generate an optimized event schedule from an existing event plan.

## Event Plan
$ARGUMENTS

## Instructions

1. Read the event plan JSON from `$ARGUMENTS` (e.g., `events/building-rag-pipelines.json`).

2. Read `data/speakers.json` to cross-reference speaker availability and talk formats.

3. Read `CLAUDE.md` for schedule constraints and output format rules.

4. Validate speaker availability:
   - Determine if the event falls on a weekday evening, Saturday, Sunday, or weekend based on the `date` field
   - Check each speaker in `suggestedSpeakers` against their `availability` array in speakers.json
   - If a speaker is unavailable, flag the conflict and suggest an alternative speaker with overlapping topics
   - If the date is null/TBD, note that availability cannot be fully validated yet

5. Build the schedule respecting these constraints:
   - **Setup buffer**: Start with a 15-minute "Doors Open & Setup" slot
   - **Content slots**: Assign talks (20-30 min) and workshops (30-60 min) based on speaker formats and the event format
   - **Break rule**: Insert a 15-minute break after every 60-90 minutes of continuous content — never go longer than 90 minutes without a break
   - **No double-booking**: Ensure no speaker appears in two slots that overlap in time
   - **Networking**: End with a 15-minute networking/Q&A slot
   - **Duration**: Total schedule should match the event plan's `suggestedDuration`
   - Arrange speakers so the most engaging/highest-rated speakers anchor key slots (opener, post-break)

6. Output a markdown schedule to `schedules/{event-slug}.md` using this format:

   ```
   # Schedule: {eventName}

   **Date**: {date or TBD}
   **Venue**: {venue name} — {venue address}
   **Duration**: {suggestedDuration}

   | Time | Duration | Type | Title | Speaker |
   |------|----------|------|-------|---------|
   | 6:00 PM | 15 min | Setup | Doors Open & Setup | — |
   | ... | ... | ... | ... | ... |
   ```

7. Update the `schedule` field in the event plan JSON with the generated slots and write it back to the original file path.

8. Print a summary:
   - List the generated schedule
   - Note any speaker availability warnings
   - Confirm both output files were written
