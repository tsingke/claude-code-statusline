#!/bin/bash
# =============================================================================
# Claude Code Status Line — Installer
# =============================================================================
set -euo pipefail

SCRIPT_SRC="$(cd "$(dirname "$0")" && pwd)/statusline.sh"
SCRIPT_DST="$HOME/.claude/statusline.sh"
SETTINGS="$HOME/.claude/settings.json"

echo "🔧 Claude Code Status Line Installer"
echo "======================================"

# Step 1: Check for jq
if ! command -v jq &>/dev/null; then
  echo "❌ 'jq' is required. Install it first:"
  echo "   brew install jq"
  exit 1
fi
echo "✅ jq detected"

# Step 2: Copy script
mkdir -p "$HOME/.claude"
cp "$SCRIPT_SRC" "$SCRIPT_DST"
chmod +x "$SCRIPT_DST"
echo "✅ Script installed to $SCRIPT_DST"

# Step 3: Configure statusLine in settings.json
if [ ! -f "$SETTINGS" ]; then
  echo '{}' > "$SETTINGS"
fi

python3 -c "
import json, os
path = os.path.expanduser('$SETTINGS')
with open(path) as f:
    cfg = json.load(f)
cfg['statusLine'] = {'type': 'command', 'command': os.path.expanduser('$SCRIPT_DST')}
with open(path, 'w') as f:
    json.dump(cfg, f, indent=2)
    f.write('\n')
"
echo "✅ statusLine added to $SETTINGS"

echo ""
echo "🎉 Installation complete! Restart Claude Code to see the status bar."
echo ""
