#!/usr/bin/env bash

# Read JSON input from stdin
input=$(cat)

TRANSCRIPT_PATH=$(echo "$input" | jq -r '.transcript_path // empty')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir // empty')

# Get repository name from current directory
REPO_NAME=""
if [ -n "$CURRENT_DIR" ]; then
  REPO_NAME=$(basename "$CURRENT_DIR")
fi

# Get the first user message as task summary
TASK_SUMMARY=""
LAST_ASSISTANT_MSG=""
if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
  # First user message (what was requested)
  TASK_SUMMARY=$(jq -r '
    [.[] | select(.type == "human")] | first |
    .message.content |
    if type == "array" then
      [.[] | select(.type == "text")] | first | .text
    else
      .
    end
  ' "$TRANSCRIPT_PATH" 2>/dev/null | head -c 80)

  # Last assistant message (what user needs to do)
  LAST_ASSISTANT_MSG=$(jq -r '
    [.[] | select(.type == "assistant")] | last |
    .message.content |
    if type == "array" then
      [.[] | select(.type == "text")] | map(.text) | join("")
    else
      .
    end
  ' "$TRANSCRIPT_PATH" 2>/dev/null | tail -c 200 | head -c 100)
fi

# Truncate task summary if too long
if [ ${#TASK_SUMMARY} -ge 80 ]; then
  TASK_SUMMARY="${TASK_SUMMARY}..."
fi

# Build notification message
MESSAGE=""
if [ -n "$TASK_SUMMARY" ]; then
  MESSAGE="$TASK_SUMMARY"
fi
if [ -n "$LAST_ASSISTANT_MSG" ]; then
  MESSAGE="${MESSAGE}\n---\n${LAST_ASSISTANT_MSG}"
fi

# Default message if nothing found
if [ -z "$MESSAGE" ]; then
  MESSAGE="タスクが完了しました"
fi

# Build title with repo name
TITLE="Claude Code"
if [ -n "$REPO_NAME" ]; then
  TITLE="Claude Code - ${REPO_NAME}"
fi

terminal-notifier -title "$TITLE" -message "$MESSAGE" -sound default
