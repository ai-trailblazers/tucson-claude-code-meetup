#!/bin/bash
# Auto-review hook for MeetupBot communications
# Triggers when files are written to the comms/ directory
# Logs the event and flags for comms-reviewer evaluation

COMMS_DIR="comms"
LOG_FILE=".claude/logs/comms-review.log"

# Check if the changed file is in comms/
for file in "$@"; do
  if [[ "$file" == ${COMMS_DIR}/* ]]; then
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] New comms draft detected: $file — flagged for review" >> "$LOG_FILE"
    echo "AUTO-REVIEW: Draft '$file' has been logged. Run comms-reviewer agent to validate quality."
  fi
done
