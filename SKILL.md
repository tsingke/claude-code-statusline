---
name: claude-statusline
description: |
  A real-time status line for Claude Code that displays the current AI model,
  working directory, context window usage (with token count and color-coded
  warnings), thinking mode indicator, and effort level.
  
  Trigger phrases: "install statusline", "enable status bar", "show status line",
  "安装状态栏", "开启状态栏".
  
  Automatically active after installation — no manual activation needed.
---

# Claude Code Status Line

A lightweight, single-line status bar for Claude Code that refreshes after every
AI response. It keeps you situationally aware during long coding sessions.

**DeepSeek-V4-flash | web test/project | 43% (86k/200k) | think | high**

## Quick Install

```bash
# 1. Ensure jq is installed
brew install jq

# 2. Install the status line
git clone https://github.com/tsingke/claude-code-statusline.git
cd claude-code-statusline
chmod +x scripts/install.sh
./scripts/install.sh

# 3. Restart Claude Code → auto-enabled
```

## Fields

| Field | Meaning | Color | Notes |
|-------|---------|-------|-------|
| Model | AI model name | Magenta | Current session model ID |
| Directory | Working directory | Blue | Auto-shortened, last 2 levels |
| Context | Usage % + tokens | Green/Yellow/Red | < 50% green, 50-80% yellow, > 80% red |
| think | Deep thinking mode | Dim italic | Shows when `thinking` is enabled |
| effort | Focus level | Cyan | `high`, `agent`, etc. |

## Uninstall

```bash
cd claude-code-statusline
./scripts/uninstall.sh
rm -rf ~/.claude/statusline.sh
```

For full documentation, see [README.md](README.md) or [README.zh-CN.md](README.zh-CN.md).
