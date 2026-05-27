#!/bin/bash
# =============================================================================
# Claude Code Status Line — Uninstaller
# =============================================================================
set -euo pipefail

SCRIPT_DST="$HOME/.claude/statusline.sh"
SETTINGS="$HOME/.claude/settings.json"

echo "🗑️  Claude Code Status Line Uninstaller"
echo "========================================"

# Remove script
if [ -f "$SCRIPT_DST" ]; then
  rm "$SCRIPT_DST"
  echo "✅ Removed $SCRIPT_DST"
else
  echo "ℹ️  Script not found, skipping"
fi

# Remove config from settings.json
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
echo "✅ Uninstallation complete. Restart Claude Code to apply."
