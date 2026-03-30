# Draft Announcement

Draft an announcement email for a meetup event.

## Event Plan
$ARGUMENTS

## Instructions

1. Read the event plan JSON from `$ARGUMENTS` (e.g., `events/building-rag-pipelines.json`).

2. Read `data/venues.json` to get full venue details (address, parking, transit access).

3. Read `CLAUDE.md` for tone guidelines — announcements should be engaging for developers, direct, and slightly witty.

4. Compose the announcement email with these sections:

   **Subject line**: Catchy and informative. Include the event name and date (or "Date TBD"). Keep under 60 characters if possible.

   **Opening hook**: 1-2 sentences that speak directly to the target audience. Lead with what they'll gain, not what the event is. Be slightly witty but not corny.

   **Event details block**:
   - Event name
   - Date and time (or TBD)
   - Duration
   - Format (workshop, talk, panel, etc.)

   **What you'll learn / Why attend**: 3-4 bullet points derived from the topic tags, description, and speaker expertise. Focus on outcomes, not abstractions.

   **Speaker highlights**: For each suggested speaker, write 1-2 sentences covering their name, title, key credential, and what they'll cover. Make them sound impressive but approachable.

   **Venue info**:
   - Venue name and address
   - Parking situation
   - Transit access
   - Any relevant amenities or notes

   **RSVP call-to-action**: Use placeholder link `[RSVP HERE](https://meetup.example.com/rsvp/{event-slug})`

   **Prerequisites** (if any): List from the event plan's prerequisites field. Skip this section if empty.

5. Save the announcement to `comms/{event-slug}-announcement.md`.

6. Confirm the file was written. Print the subject line and first two sentences as a preview.
