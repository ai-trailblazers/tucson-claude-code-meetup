# Feature Request: Meetup Communications

## What we need
MeetupBot should be able to draft two types of communications:

1. **Event Announcements** — Public-facing emails/posts to attract attendees
2. **Speaker Outreach** — Personalized emails to invite speakers

## Requirements
- Announcements should be engaging and developer-friendly (no corporate speak)
- Speaker outreach should reference the speaker's specific expertise
- Both should include all relevant logistics (date, venue, time)
- Output as markdown files in a `comms/` directory

## Acceptance Criteria
- [ ] New slash command: `/draft-announcement {event-slug}`
- [ ] New slash command: `/draft-speaker-outreach {event-slug}`
- [ ] Announcement includes: subject line, hook, speaker highlights, logistics, RSVP CTA
- [ ] Speaker outreach is personalized per speaker with specific expertise references
- [ ] Communications tone guidelines added to CLAUDE.md
- [ ] Naming convention: `comms/{event-slug}-announcement.md`, `comms/{event-slug}-speaker-outreach.md`
