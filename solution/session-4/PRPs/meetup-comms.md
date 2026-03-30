# PRP: Meetup Communications Feature

## Problem
MeetupBot generates event plans and schedules but lacks the ability to draft communications. Organizers manually write announcements and speaker outreach, leading to inconsistent tone and wasted time.

## Proposed Solution
Add two new slash commands and supporting infrastructure:
1. `/draft-announcement` — generates a meetup announcement from an event plan
2. `/draft-speaker-outreach` — generates personalized speaker invitation emails

## Design Decisions

### Output Location
All communications saved to `comms/` directory with naming convention:
- `comms/{event-slug}-announcement.md`
- `comms/{event-slug}-speaker-outreach.md`

### Tone Guidelines
- **Announcements**: Developer-friendly, direct, slightly witty. Lead with what attendees gain.
- **Speaker outreach**: Professional but warm. Reference specific expertise. Clear logistics.

### Integration Points
- Reads event plan JSON from `events/` for context
- Reads `data/speakers.json` for speaker details in outreach
- Comms-reviewer subagent validates drafts before finalizing
- Auto-review hook triggers on file writes to `comms/`

## Implementation Steps
1. Create `/draft-announcement` slash command
2. Create `/draft-speaker-outreach` slash command
3. Create `comms-reviewer` subagent for quality checks
4. Add auto-review hook for `comms/` directory
5. Update CLAUDE.md with communications tone guidelines

## Success Criteria
- Announcements are engaging and match target audience
- Speaker outreach is personalized per speaker
- All output follows naming conventions
- Comms-reviewer catches quality issues before finalization

## Risks
- Tone may need iteration — plan for human review of first few outputs
- Speaker outreach must not feel templated — each email should feel personal

## Timeline
Single session implementation. All components are additive — no breaking changes.
