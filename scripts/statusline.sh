#!/bin/bash
# =============================================================================
# Claude Code Status Line v2
# A real-time status bar for Claude Code with multi-theme support.
# Reads session state from stdin (JSON payload from Claude Code) and outputs
# a formatted status line to stdout, displayed at the terminal bottom.
# =============================================================================
set -euo pipefail

CONFIG_FILE="$HOME/.claude/statusline-config.json"

# --- Load config (with fallback) ---
config=$(cat "$CONFIG_FILE" 2>/dev/null) || config='{"theme":"default","separator":"|","show":["model","dir","context","think","effort","agent"]}'

CURRENT_THEME=$(echo "$config" | jq -r '.theme // "default"')
SEPARATOR_CHAR=$(echo "$config" | jq -r '.separator // "|"')

# --- Check field visibility ---
field_visible() {
  echo "$config" | jq -e --arg f "$1" '.show // ["model","dir","context","think","effort","agent"] | index($f)' > /dev/null 2>&1
}

# --- Theme definitions (SGR color codes) ---
case "$CURRENT_THEME" in
  ocean)
    C_MODEL="1;36"; C_DIR="34"; C_AGENT="33"
    C_GREEN="32"; C_YELLOW="33"; C_RED="91"
    C_THINK="2;3"; C_EFFORT="36"; SEP_DIM="2"
    ;;
  monokai)
    C_MODEL="1;33"; C_DIR="36"; C_AGENT="31"
    C_GREEN="32"; C_YELLOW="93"; C_RED="91"
    C_THINK="2;3"; C_EFFORT="35"; SEP_DIM="2"
    ;;
  minimal)
    C_MODEL="1;37"; C_DIR="37"; C_AGENT="37"
    C_GREEN="92"; C_YELLOW="93"; C_RED="91"
    C_THINK="2;37"; C_EFFORT="37"; SEP_DIM="2"
    ;;
  neon)
    C_MODEL="1;35"; C_DIR="36"; C_AGENT="93"
    C_GREEN="92"; C_YELLOW="93"; C_RED="91"
    C_THINK="2;35"; C_EFFORT="96"; SEP_DIM="2"
    ;;
  forest)
    C_MODEL="1;32"; C_DIR="33"; C_AGENT="36"
    C_GREEN="32"; C_YELLOW="93"; C_RED="91"
    C_THINK="2;3;32"; C_EFFORT="33"; SEP_DIM="2"
    ;;
  nord)
    C_MODEL="1;34"; C_DIR="36"; C_AGENT="37"
    C_GREEN="32"; C_YELLOW="93"; C_RED="91"
    C_THINK="2;3;36"; C_EFFORT="36"; SEP_DIM="2"
    ;;
  lavender)
    C_MODEL="1;35"; C_DIR="36"; C_AGENT="95"
    C_GREEN="32"; C_YELLOW="93"; C_RED="91"
    C_THINK="2;3;35"; C_EFFORT="36"; SEP_DIM="2"
    ;;
  gruvbox)
    C_MODEL="1;33"; C_DIR="32"; C_AGENT="31"
    C_GREEN="32"; C_YELLOW="93"; C_RED="91"
    C_THINK="2;3;33"; C_EFFORT="36"; SEP_DIM="2"
    ;;
  sakura)
    C_MODEL="1;95"; C_DIR="36"; C_AGENT="35"
    C_GREEN="32"; C_YELLOW="93"; C_RED="91"
    C_THINK="2;3;95"; C_EFFORT="35"; SEP_DIM="2"
    ;;
  *) # default (original style)
    C_MODEL="1;35"; C_DIR="34"; C_AGENT="33"
    C_GREEN="32"; C_YELLOW="33"; C_RED="91"
    C_THINK="2;3"; C_EFFORT="36"; SEP_DIM="2"
    ;;
esac

RESET="\033[0m"
SEP="\033[${SEP_DIM}m${SEPARATOR_CHAR}\033[0m"

# --- Read stdin (the JSON payload from Claude Code) ---
# Use || true to avoid set -e exit when stdin is empty (e.g. session startup)
read -r input || input="{}"

# --- Single jq call: extract all fields at once ---
eval "$(echo "$input" | jq -r '
  {
    model:    (.model.display_name // "?"),
    cwd:      (.workspace.current_dir // .cwd // ""),
    agent:    (.agent.name // ""),
    ctx:      (.context_window.used_percentage // ""),
    effort:   (.effort.level // ""),
    tokens:   (.context_window.total_input_tokens // ""),
    maxtok:   (.context_window.context_window_size // ""),
    thin:     (.thinking.enabled // false),
    fast:     (.fast_mode // false),
    duration: (.cost.total_duration_ms // "")
  } | to_entries[] | "\(.key)=\(.value | @sh)"
')" 2>/dev/null || true

# --- Shorten working directory: ~/.../last-two-levels ---
short_cwd=""
if [ -n "$cwd" ]; then
  short_cwd=$(echo "$cwd" | sed "s|^$HOME|~|" | awk -F/ '{n=NF; if(n>2) print $(n-1)"/"$n; else print}')
fi

# --- Format session duration ---
duration_str=""
if [ -n "$duration" ]; then
  seconds=$(awk "BEGIN {printf \"%.0f\", $duration/1000}" 2>/dev/null || echo "0")
  if [ "$seconds" -ge 60 ]; then
    minutes=$((seconds / 60))
    secs=$((seconds % 60))
    duration_str="${minutes}m${secs}s"
  elif [ "$seconds" -gt 0 ]; then
    duration_str="${seconds}s"
  fi
fi

# --- Build status line ---
line=""

# Model
if field_visible "model"; then
  line="\033[${C_MODEL}m${model}\033[0m"
fi

# Working directory
if field_visible "dir" && [ -n "$short_cwd" ]; then
  [ -n "$line" ] && line+=" ${SEP} "
  line+="\033[${C_DIR}m${short_cwd}\033[0m"
fi

# Agent name
if field_visible "agent" && [ -n "$agent" ]; then
  [ -n "$line" ] && line+=" ${SEP} "
  line+="\033[${C_AGENT}m${agent}\033[0m"
fi

# Context usage with color thresholds (<50% green / 50-80% yellow / >80% red)
if field_visible "context" && [ -n "$ctx" ]; then
  [ -n "$line" ] && line+=" ${SEP} "
  ctx_int=${ctx%.*}
  if [ "$ctx_int" -gt 80 ] 2>/dev/null; then
    C_CTX="$C_RED"
  elif [ "$ctx_int" -gt 50 ] 2>/dev/null; then
    C_CTX="$C_YELLOW"
  else
    C_CTX="$C_GREEN"
  fi
  line+="\033[${C_CTX}m${ctx}%"
  if [ -n "$tokens" ] && [ -n "$maxtok" ] && [ "$maxtok" != "0" ]; then
    used_k=$(awk "BEGIN {printf \"%.0f\", $tokens/1000}")
    max_k=$(awk "BEGIN {printf \"%.0f\", $maxtok/1000}")
    line+=" (${used_k}k/${max_k}k)"
  fi
  line+="\033[0m"
fi

# Thinking mode indicator
if field_visible "think" && [ "$thin" = "true" ]; then
  [ -n "$line" ] && line+=" ${SEP} "
  line+="\033[${C_THINK}mthink\033[0m"
fi

# Fast mode indicator
if field_visible "fast" && [ "$fast" = "true" ]; then
  [ -n "$line" ] && line+=" ${SEP} "
  line+="\033[${C_EFFORT}mfast\033[0m"
fi

# Session duration
if field_visible "duration" && [ -n "$duration_str" ]; then
  [ -n "$line" ] && line+=" ${SEP} "
  line+="\033[${C_EFFORT}m${duration_str}\033[0m"
fi

# Effort level
if field_visible "effort" && [ -n "$effort" ]; then
  [ -n "$line" ] && line+=" ${SEP} "
  line+="\033[${C_EFFORT}m${effort}\033[0m"
fi

echo -e "$line"
