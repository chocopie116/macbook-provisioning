#!/usr/bin/env bash

# Read JSON input from stdin
input=$(cat)

MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
DIR_NAME="${CURRENT_DIR##*/}"

# Get git branch
GIT_BRANCH=""
if git rev-parse &>/dev/null; then
  BRANCH=$(git branch --show-current)
  if [ -n "$BRANCH" ]; then
    GIT_BRANCH="$BRANCH"
  else
    GIT_BRANCH="HEAD ($(git rev-parse --short HEAD 2>/dev/null))"
  fi
fi

# Get context_window information
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
USAGE=$(echo "$input" | jq '.context_window.current_usage // null')

if [ "$USAGE" != "null" ]; then
  current_tokens=$(echo "$USAGE" | jq '(.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)')
else
  current_tokens=0
fi

percentage=$((current_tokens * 100 / CONTEXT_SIZE))

format_tokens() {
  local tokens=$1
  if [ "$tokens" -ge 1000000 ]; then
    local millions=$((tokens / 1000000))
    local remainder=$(( (tokens % 1000000) / 100000 ))
    if [ "$remainder" -gt 0 ]; then
      echo "${millions}.${remainder}M"
    else
      echo "${millions}M"
    fi
  elif [ "$tokens" -ge 1000 ]; then
    local thousands=$((tokens / 1000))
    echo "${thousands}k"
  else
    echo "$tokens"
  fi
}

current_display=$(format_tokens "$current_tokens")
context_display=$(format_tokens "$CONTEXT_SIZE")

# Color coding
if [ "$percentage" -ge 80 ]; then
  bar_color="\033[31m"  # Red
elif [ "$percentage" -ge 50 ]; then
  bar_color="\033[33m"  # Yellow
else
  bar_color="\033[32m"  # Green
fi
reset="\033[0m"

# Build progress bar with block characters
bar_width=20
filled=$(( percentage * bar_width / 100 ))
empty=$(( bar_width - filled ))
bar=""
for ((i=0; i<filled; i++)); do bar="${bar}█"; done
for ((i=0; i<empty; i++)); do bar="${bar}░"; done

# Format: [Opus 4.6] DirName/branch | ctx [bar] used/total
LABEL="${DIR_NAME}"
[ -n "$GIT_BRANCH" ] && LABEL="${LABEL}/${GIT_BRANCH}"

echo -e "[${MODEL_DISPLAY}] ${LABEL} | ctx ${bar_color}${bar}${reset} ${current_display}/${context_display}"
