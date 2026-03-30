# Post-Event Recap

Generate a post-event recap for a completed meetup.

## Event Plan
$ARGUMENTS

## Instructions

1. Read the event plan JSON file at the path provided in $ARGUMENTS.

2. Gather feedback by asking the organizer about:
   - **Actual attendance** vs estimated attendance
   - **What went well** — highlights from the event
   - **Improvement areas** — what could be better next time
   - **Speaker feedback** — how each speaker performed (rating 1-5)
   - **Venue feedback** — was the venue a good fit? (rating 1-5)
   - **Format feedback** — did the format work? (rating 1-5)

3. Generate a structured post-event recap JSON with these fields:
   ```json
   {
     "eventName": "string — from the event plan",
     "eventFile": "string — path to the event plan file",
     "date": "string — ISO date of the event",
     "estimatedAttendees": "number — from the event plan",
     "actualAttendees": "number — reported by organizer",
     "feedbackHighlights": ["array of strings — what went well"],
     "improvementAreas": ["array of strings — what to improve"],
     "venueRating": "number — 1-5 scale",
     "formatRating": "number — 1-5 scale",
     "speakerRatings": {
       "speaker-id": "number — 1-5 scale per speaker"
     },
     "lessonsLearned": ["array of strings — actionable takeaways for future events"],
     "nextEventSuggestions": ["array of strings — ideas for follow-up events or improvements"]
   }
   ```

4. Save the recap to `data/past-events/{event-name-slug}-recap.json` where `{event-name-slug}` is derived from the event file name (e.g., `events/rag-workshop-final.json` becomes `rag-workshop-recap.json`).

5. **Important**: The recap JSON must be machine-readable so that `/plan-event` can parse past events to improve future planning. Keep all fields structured — no free-form text blocks.

6. Confirm the recap was saved and summarize key findings:
   - Attendance rate (actual / estimated)
   - Top highlights
   - Most critical improvement area
   - Recommended follow-up actions
