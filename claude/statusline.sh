#!/usr/bin/env bash

# Read JSON input from stdin
input=$(cat)

MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')

# Get git information
GIT_BRANCH=""
GIT_STATUS=""
if git rev-parse &>/dev/null; then
  BRANCH=$(git branch --show-current)
  if [ -n "$BRANCH" ]; then
    GIT_BRANCH="@ $BRANCH"
  else
    COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null)
    if [ -n "$COMMIT_HASH" ]; then
      GIT_BRANCH="@ HEAD ($COMMIT_HASH)"
    fi
  fi

  # Get number of changed files by type
  modified_count=$(git status --porcelain 2>/dev/null | grep -c '^.M\|^M')
  added_count=$(git status --porcelain 2>/dev/null | grep -c '^??\|^A')

  GIT_STATUS=""
  [ "$modified_count" -gt 0 ] && GIT_STATUS="${modified_count}M"
  [ "$added_count" -gt 0 ] && GIT_STATUS="${GIT_STATUS} ${added_count}A"
  GIT_STATUS=$(echo "$GIT_STATUS" | xargs)  # trim spaces
fi

# Get context_window information
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
USAGE=$(echo "$input" | jq '.context_window.current_usage // null')

# Calculate current context usage
if [ "$USAGE" != "null" ]; then
  current_tokens=$(echo "$USAGE" | jq '(.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)')
else
  current_tokens=0
fi

# Calculate percentage
percentage=$((current_tokens * 100 / CONTEXT_SIZE))

# Format display
format_tokens() {
  local tokens=$1
  if [ "$tokens" -ge 1000 ]; then
    local thousands=$((tokens / 1000))
    local remainder=$((tokens % 1000))
    if [ "$remainder" -ge 100 ]; then
      local decimal=$((remainder / 100))
      echo "${thousands}.${decimal}K"
    else
      echo "${thousands}K"
    fi
  else
    echo "$tokens"
  fi
}

current_display=$(format_tokens "$current_tokens")
context_display=$(format_tokens "$CONTEXT_SIZE")

# Color coding for percentage
if [ "$percentage" -ge 80 ]; then
  color="\033[31m"  # Red
elif [ "$percentage" -ge 50 ]; then
  color="\033[33m"  # Yellow
else
  color="\033[32m"  # Green
fi

# Format output (single line)
STATUS_LINE="${CURRENT_DIR##*/} ${GIT_BRANCH} | ${MODEL_DISPLAY} | ${current_display}/${context_display} (${color}${percentage}%\033[0m)"
[ -n "$GIT_STATUS" ] && STATUS_LINE="${STATUS_LINE} | ${GIT_STATUS}"
echo -e "$STATUS_LINE"
