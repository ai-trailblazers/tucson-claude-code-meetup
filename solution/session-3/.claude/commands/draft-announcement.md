# Draft Announcement

Draft a public announcement email for a meetup event.

## Event
$ARGUMENTS

## Instructions

1. Read the event plan from `events/$ARGUMENTS.json`
2. Read `data/venues.json` for venue details
3. Read `data/speakers.json` for speaker bios

4. Draft an announcement that includes:
   - Attention-grabbing subject line
   - Hook in the first sentence targeting the audience
   - What attendees will learn/build/experience
   - Speaker highlights (name, title, why they're exciting)
   - Date, time, venue with address
   - Prerequisites if any
   - Clear RSVP call to action with placeholder link
   - A line encouraging people to share

5. Follow the communications tone from `CLAUDE.md`:
   - Engaging for developers, direct, slightly witty
   - No buzzword salad or corporate speak
   - Respect the reader's time

6. Write to `comms/$ARGUMENTS-announcement.md`

7. Confirm the file was written.
