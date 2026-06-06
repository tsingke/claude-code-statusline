#!/bin/bash
# =============================================================================
# Claude Code Status Line — Configuration CLI
# Switch themes, change separator, toggle field visibility.
# =============================================================================
set -euo pipefail

CONFIG_FILE="$HOME/.claude/statusline-config.json"

# --- Helpers ---
ensure_config() {
  if [ ! -f "$CONFIG_FILE" ]; then
    mkdir -p "$(dirname "$CONFIG_FILE")"
    cat > "$CONFIG_FILE" << 'EOF'
{"theme":"default","separator":"|","show":["model","dir","context","think","effort","agent"]}
EOF
  fi
}

list_themes() {
  echo "Available themes:"
  echo "  default    - Original style (magenta/blue/green)"
  echo "  ocean      - Cool blue/cyan tones"
  echo "  monokai    - Monokai-inspired warm palette"
  echo "  minimal    - Clean, low contrast"
  echo "  neon       - Bright neon colors"
  echo "  forest     - Earthy green & amber, nature-inspired"
  echo "  nord       - Arctic blue-grey, clean & crisp"
  echo "  lavender   - Soft purple & violet, elegant"
  echo "  gruvbox    - Retro warm, vim colorscheme-inspired"
  echo "  sakura     - Cherry blossom pink, delicate"
}

# --- Commands ---

cmd_theme() {
  local new_theme="${1:-}"
  if [ -z "$new_theme" ]; then
    local current
    current=$(jq -r '.theme' "$CONFIG_FILE")
    echo "Current theme: ${current}"
    list_themes
    return 0
  fi

  case "$new_theme" in
    default|ocean|monokai|minimal|neon|forest|nord|lavender|gruvbox|sakura) ;;
    *) echo "Unknown theme: ${new_theme}"; list_themes; return 1 ;;
  esac

  jq --arg t "$new_theme" '.theme = $t' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" \
    && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
  echo "Theme changed to: ${new_theme}"
  echo "Restart Claude Code (or wait for next response) to apply."
}

cmd_separator() {
  local new_sep="${1:-}"
  if [ -z "$new_sep" ]; then
    local current
    current=$(jq -r '.separator' "$CONFIG_FILE")
    echo "Current separator: '${current}'"
    return 0
  fi

  jq --arg s "$new_sep" '.separator = $s' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" \
    && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
  echo "Separator changed to: '${new_sep}'"
}

cmd_show() {
  local action="${1:-}"
  if [ -z "$action" ]; then
    echo "Visible fields:"
    jq -r '.show // [] | .[] | "  - \(.)"' "$CONFIG_FILE"
    echo ""
    echo "Available fields: model, dir, context, think, effort, agent, fast, duration"
    echo "Usage: statusline show +field   (add field)"
    echo "       statusline show -field   (remove field)"
    return 0
  fi

  case "$action" in
    +*)
      local field="${action#+}"
      jq --arg f "$field" \
        'if (.show // []) | index($f) then . else .show += [$f] end' \
        "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" \
        && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
      echo "Field added: ${field}"
      ;;
    -*)
      local field="${action#-}"
      jq --arg f "$field" \
        'if (.show // []) | index($f) then .show |= map(select(. != $f)) else . end' \
        "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" \
        && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
      echo "Field removed: ${field}"
      ;;
    *)
      echo "Usage: statusline show [+field|-field]"
      ;;
  esac
}

cmd_status() {
  echo "Status Line Configuration:"
  echo "  Theme:     $(jq -r '.theme' "$CONFIG_FILE")"
  echo "  Separator: '$(jq -r '.separator' "$CONFIG_FILE")'"
  echo "  Fields:    $(jq -r '.show // [] | join(", ")' "$CONFIG_FILE")"
}

# --- Main ---
ensure_config

case "${1:-help}" in
  theme)      cmd_theme "${2:-}" ;;
  separator)  cmd_separator "${2:-}" ;;
  show)       cmd_show "${2:-}" ;;
  status)     cmd_status ;;
  themes|list-themes) list_themes ;;
  help|--help|-h)
    echo "Claude Code Status Line Configuration"
    echo ""
    echo "Usage: statusline <command> [options]"
    echo ""
    echo "Commands:"
    echo "  theme [name]             Switch theme or list available themes"
    echo "  separator [char]         View or change the field separator"
    echo "  show [+field|-field]     Toggle field visibility"
    echo "  status                   Show current configuration"
    echo "  help                     Show this help"
    echo ""
    echo "Themes: default, ocean, monokai, minimal, neon"
    echo "Fields: model, dir, context, think, effort, agent, fast, duration"
    ;;
  *)
    echo "Unknown command: ${1}"
    echo "Usage: statusline <command> [options]"
    echo "Commands: theme, separator, show, status, help"
    ;;
esac
