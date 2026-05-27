#!/bin/bash
# =============================================================================
# Claude Code Status Line
# A real-time status bar for Claude Code that displays model, working directory,
# context usage, thinking mode, and effort level at the bottom of your terminal.
#
# Installation:  ./scripts/install.sh
# Uninstallation: ./scripts/uninstall.sh
# =============================================================================

set -euo pipefail

# Read the JSON payload from Claude Code (passed via stdin)
read -r input

# --- Extract fields ---
model=$(echo "$input"   | jq -r '.model.display_name // "?"')
cwd=$(echo "$input"     | jq -r '.workspace.current_dir // .cwd // ""')
agent=$(echo "$input"   | jq -r '.agent.name // ""')
ctx=$(echo "$input"     | jq -r '.context_window.used_percentage // ""')
effort=$(echo "$input"  | jq -r '.effort.level // ""')
tokens=$(echo "$input"  | jq -r '.context_window.total_input_tokens // ""')
maxtok=$(echo "$input"  | jq -r '.context_window.context_window_size // ""')
thin=$(echo "$input"    | jq -r '.thinking.enabled // false')

# --- Shorten working directory ---
# Replace $HOME with ~, then keep only the last two path components
short_cwd=$(echo "$cwd" | sed "s|^$HOME|~|" | awk -F/ '{n=NF; if(n>2) print $(n-1)"/"$n; else print}')

# --- ANSI color codes ---
BOLD='\033[1m'
DIM='\033[2m'
BLUE='\033[34m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
MAGENTA='\033[35m'
RED='\033[91m'
RESET='\033[0m'
SEP=" ${DIM}|${RESET} "

# --- Build the status line ---
line="${BOLD}${MAGENTA}${model}${RESET}"

# Working directory (blue)
if [ -n "$short_cwd" ]; then
  line+="${SEP}${BLUE}${short_cwd}${RESET}"
fi

# Agent name (yellow)
if [ -n "$agent" ]; then
  line+="${SEP}${YELLOW}${agent}${RESET}"
fi

# Context usage (green/yellow/red depending on usage level)
if [ -n "$ctx" ]; then
  ctx_int=${ctx%.*}
  if [ "$ctx_int" -gt 80 ] 2>/dev/null; then
    ctx_color="$RED"
  elif [ "$ctx_int" -gt 50 ] 2>/dev/null; then
    ctx_color="$YELLOW"
  else
    ctx_color="$GREEN"
  fi
  line+="${SEP}${ctx_color}${ctx}%"
  if [ -n "$tokens" ] && [ -n "$maxtok" ] && [ "$maxtok" != "0" ]; then
    used_k=$(awk "BEGIN {printf \"%.0f\", $tokens/1000}")
    max_k=$(awk "BEGIN {printf \"%.0f\", $maxtok/1000}")
    line+=" (${used_k}k/${max_k}k)"
  fi
  line+="${RESET}"
fi

# Thinking mode indicator (dim italic)
if [ "$thin" = "true" ]; then
  line+="${SEP}${DIM}think${RESET}"
fi

# Effort level (cyan)
if [ -n "$effort" ]; then
  line+="${SEP}${CYAN}${effort}${RESET}"
fi

echo -e "$line"
