# Plan Event

Plan a meetup event for the given topic.

## Topic
$ARGUMENTS

## Instructions

1. Read the available data:
   - `data/venues.json` for venue options
   - `data/speakers.json` for the speaker roster
   - `examples/sample-event-plan.json` for the expected output format

2. Follow all rules in `CLAUDE.md`, especially:
   - Output must be structured JSON matching the event plan schema
   - Use camelCase for JSON keys and kebab-case for file names and topic tags
   - Be concise and actionable

3. Generate a complete event plan:
   - Choose a descriptive `eventName` based on the topic
   - Write a 2-3 sentence `description`
   - Pick the best `format` (workshop, talk, panel, or hackathon)
   - Identify the `targetAudience`
   - Estimate attendee count realistically
   - Suggest 2-3 speakers from `data/speakers.json` whose topics align, with a `reason` for each
   - Recommend a venue from `data/venues.json` that fits the estimated attendance and event format
   - Build a detailed schedule with logical flow (setup, content, breaks, networking)
   - Calculate realistic cost estimates

4. Write the plan to `events/{topic-slug}.json` where `{topic-slug}` is the topic converted to kebab-case (e.g., "Building RAG Pipelines" becomes `building-rag-pipelines`).

5. Confirm the file was written and summarize the key decisions (speakers, venue, format).
