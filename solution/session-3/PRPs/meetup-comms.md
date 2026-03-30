# PRP: Meetup Communications Feature

## Problem
MeetupBot can plan events and build schedules, but has no way to generate outward-facing communications. Organizers need to manually write announcement emails and speaker outreach, which is time-consuming and inconsistent.

## Proposed Solution
Add two new slash commands and supporting infrastructure for drafting meetup communications.

### New Commands
1. **`/draft-announcement {event-slug}`** — Generates a public announcement email
2. **`/draft-speaker-outreach {event-slug}`** — Generates personalized speaker invitation emails

### New Directory
- `comms/` — Stores all generated communication drafts

### CLAUDE.md Updates
- Add "Communications Tone" section with guidelines for announcements and outreach
- Add naming conventions for comms files
- Add `comms/` to Data Locations

### File Naming
- `comms/{event-slug}-announcement.md`
- `comms/{event-slug}-speaker-outreach.md`

## Announcement Format
- Subject line (attention-grabbing)
- Opening hook targeting the audience
- What attendees will learn/build
- Speaker highlights with bios
- Full logistics (date, time, venue, address, parking)
- Prerequisites if applicable
- RSVP call to action
- Share encouragement

## Speaker Outreach Format
- Personalized greeting
- Reference to speaker's specific expertise and past work
- Event description and why they're a fit
- Specific ask (title, format, duration)
- Logistics (date, venue, audience size)
- Clear CTA (confirm availability)

## Tone Guidelines
- **Announcements**: Direct, engaging, slightly witty. No buzzwords or corporate speak.
- **Outreach**: Professional but warm. Specific, not generic.

## Dependencies
- Requires existing event plan in `events/`
- Reads from `data/speakers.json` and `data/venues.json`

## Testing
- Generate announcement for `prompt-engineering-vs-context-engineering`
- Generate speaker outreach for the same event
- Verify all logistics are included and tone matches guidelines
