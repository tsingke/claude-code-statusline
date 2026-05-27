#!/bin/bash
# =============================================================================
# Claude Code Status Line — Installer
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"
DST_SCRIPT="$CLAUDE_DIR/statusline.sh"
DST_CONFIG="$CLAUDE_DIR/statusline-config.sh"
CONFIG_FILE="$CLAUDE_DIR/statusline-config.json"
SETTINGS="$CLAUDE_DIR/settings.json"
SKILL_NAME="claude-statusline"

echo "============================================"
echo " Claude Code Status Line Installer"
echo "============================================"
echo ""

# Step 1: Check jq
if ! command -v jq &>/dev/null; then
  echo "❌ 'jq' is required. Install it first:"
  echo "   brew install jq"
  exit 1
fi
echo "✅ jq detected: $(command -v jq)"

# Step 2: Create directories
mkdir -p "$CLAUDE_DIR" "$SKILLS_DIR"

# Step 3: Install core statusline script
cp "$SCRIPT_DIR/statusline.sh" "$DST_SCRIPT"
chmod +x "$DST_SCRIPT"
echo "✅ Core script: $DST_SCRIPT"

# Step 4: Install config CLI
cp "$SCRIPT_DIR/statusline-config.sh" "$DST_CONFIG"
chmod +x "$DST_CONFIG"
echo "✅ Config CLI: $DST_CONFIG"

# Step 5: Register as Claude Code skill
SKILL_TARGET="$SKILLS_DIR/$SKILL_NAME"
mkdir -p "$SKILL_TARGET/scripts"
if [ -f "$SCRIPT_DIR/../SKILL.md" ]; then
  cp "$SCRIPT_DIR/../SKILL.md" "$SKILL_TARGET/SKILL.md"
  cp "$SCRIPT_DIR/statusline.sh" "$SKILL_TARGET/scripts/statusline.sh"
  cp "$SCRIPT_DIR/statusline-config.sh" "$SKILL_TARGET/scripts/statusline-config.sh"
  echo "✅ Skill registered: $SKILL_TARGET"
fi

# Step 6: Create default config if not exists
if [ ! -f "$CONFIG_FILE" ]; then
  cat > "$CONFIG_FILE" << 'EOF'
{"theme":"default","separator":"|","show":["model","dir","context","think","effort","agent"]}
EOF
  echo "✅ Config created: $CONFIG_FILE"
else
  echo "ℹ️  Config exists: $CONFIG_FILE"
fi

# Step 7: Add statusLine to settings.json
if [ ! -f "$SETTINGS" ]; then
  echo '{}' > "$SETTINGS"
fi

python3 -c "
import json, os
path = os.path.expanduser('$SETTINGS')
with open(path) as f:
    cfg = json.load(f)
cfg['statusLine'] = {'type': 'command', 'command': os.path.expanduser('$DST_SCRIPT')}
with open(path, 'w') as f:
    json.dump(cfg, f, indent=2)
    f.write('\n')
"
echo "✅ statusLine added to $SETTINGS"

echo ""
echo "============================================"
echo " Installation complete!"
echo "============================================"
echo ""
echo "Quick start:"
echo "  ~/.claude/statusline-config.sh theme        # List themes"
echo "  ~/.claude/statusline-config.sh theme ocean   # Switch theme"
echo "  ~/.claude/statusline-config.sh separator '•' # Change separator"
echo "  ~/.claude/statusline-config.sh show +fast    # Add fast mode field"
echo "  ~/.claude/statusline-config.sh status        # Show current config"
echo ""
echo "Add alias to ~/.zshrc:"
echo "  alias statusline='~/.claude/statusline-config.sh'"
echo ""
echo "Restart Claude Code to see the status bar."
