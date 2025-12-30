#!/usr/bin/env bash

# Read JSON input from stdin
input=$(cat)

TRANSCRIPT_PATH=$(echo "$input" | jq -r '.transcript_path // empty')

# Get the first user message as task summary
TASK_SUMMARY=""
if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
  TASK_SUMMARY=$(jq -r '
    [.[] | select(.type == "human")] | first |
    .message.content |
    if type == "array" then
      [.[] | select(.type == "text")] | first | .text
    else
      .
    end
  ' "$TRANSCRIPT_PATH" 2>/dev/null | head -c 100)
fi

# Truncate if too long
if [ ${#TASK_SUMMARY} -ge 100 ]; then
  TASK_SUMMARY="${TASK_SUMMARY}..."
fi

# Default message if no task found
if [ -z "$TASK_SUMMARY" ]; then
  TASK_SUMMARY="タスクが完了しました"
fi

terminal-notifier -title 'Claude Code' -message "$TASK_SUMMARY" -sound default
