# Draft Speaker Outreach

Draft personalized outreach emails to speakers for a meetup event.

## Event Plan
$ARGUMENTS

## Instructions

1. Read the event plan JSON from `$ARGUMENTS` (e.g., `events/building-rag-pipelines.json`).

2. Read `data/speakers.json` to get full speaker profiles (topics, bio, past talks, rating, availability).

3. Read `CLAUDE.md` for tone guidelines — speaker outreach should be professional but warm, referencing specific expertise.

4. For EACH speaker listed in the event plan's `suggestedSpeakers` array, draft a personalized outreach email:

   **Subject line**: Include the speaker's name and the event topic. e.g., "Sarah — Speaking at our RAG Pipelines workshop?"

   **Greeting**: Use the speaker's first name.

   **Personal hook** (1-2 sentences): Reference 1-2 of their specific topics from speakers.json. Mention something concrete — their past talk count, a detail from their bio, or their rating. Show you know who they are, not just their name.

   **Event description** (2-3 sentences): What the event is about, who the target audience is, expected attendance count. Connect it to why their expertise matters for this audience.

   **The ask** (1-2 sentences): Be specific about what you're asking. Reference the talk format (talk, workshop, live-coding) and the topic area you'd like them to cover, based on the `reason` field from the event plan.

   **Logistics**:
   - Date: from event plan (or "we're flexible on dates" if TBD)
   - Venue: name and address from the event plan
   - Their slot: estimated duration based on the schedule
   - Audience size: estimated attendees

   **Closing** (1-2 sentences): Express genuine interest. Provide clear next steps — e.g., "If you're interested, just reply and we'll work out the details."

   **Sign-off**: "Best, [Meetup Organizer Name]" (use a placeholder)

5. Write ALL outreach emails to a single file: `comms/{event-slug}-speaker-outreach.md`
   - Separate each email with a horizontal rule (`---`) and a clear header
   - Include the speaker's name and email subject as the header

6. Confirm the file was written and list which speakers were included.
