#!/bin/bash
# Auto-review any drafted communications

# Read hook input from stdin
INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name',''))" 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null)

# Only trigger for Write tool on comms/ or when file contains "announcement" or "outreach"
if [[ "$TOOL_NAME" == "Write" ]]; then
    if [[ "$FILE_PATH" == *"comms/"* || "$FILE_PATH" == *"announcement"* || "$FILE_PATH" == *"outreach"* ]]; then
        mkdir -p .claude/logs
        echo "$(date): Auto-review triggered for $FILE_PATH" >> .claude/logs/reviews.log
        echo "New communication drafted: $FILE_PATH — comms-reviewer will evaluate quality."
    fi
fi
