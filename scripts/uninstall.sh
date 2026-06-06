#!/bin/bash
# =============================================================================
# Claude Code Status Line — Uninstaller
# =============================================================================
set -euo pipefail

CLAUDE_DIR="$HOME/.claude"
DST_SCRIPT="$CLAUDE_DIR/statusline.sh"
DST_CONFIG="$CLAUDE_DIR/statusline-config.sh"
CONFIG_FILE="$CLAUDE_DIR/statusline-config.json"
SETTINGS="$CLAUDE_DIR/settings.json"
SKILL_DIR="$CLAUDE_DIR/skills/claude-statusline"

echo "============================================"
echo " Claude Code Status Line Uninstaller"
echo "============================================"
echo ""

# Remove scripts
for f in "$DST_SCRIPT" "$DST_CONFIG" "$CONFIG_FILE"; do
  if [ -f "$f" ]; then
    rm "$f"
    echo "✅ Removed: $f"
  fi
done

# Remove skill
if [ -d "$SKILL_DIR" ]; then
  rm -rf "$SKILL_DIR"
  echo "✅ Removed skilL: $SKILL_DIR"
fi

# Remove statusLine entry from settings.json
if [ -f "$SETTINGS" ]; then
  python3 -c "
import json, os
path = os.path.expanduser('$SETTINGS')
with open(path) as f:
    cfg = json.load(f)
if 'statusLine' in cfg:
    del cfg['statusLine']
    with open(path, 'w') as f:
        json.dump(cfg, f, indent=2)
        f.write('\n')
    print('✅ statusLine removed from settings.json')
else:
    print('ℹ️  statusLine not found in settings.json')
  "
fi

echo ""
echo "✅ Uninstall complete. Restart Claude Code to apply."
