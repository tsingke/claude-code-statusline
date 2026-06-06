---
name: claude-statusline
description: |
  A real-time status line for Claude Code that displays the current AI model,
  working directory, context usage (color-coded with thresholds), thinking
  mode indicator, effort level, fast mode, and session duration. Supports 10
  color themes and per-field visibility toggling.
  
  Trigger phrases: "install statusline", "enable status bar", "show status line",
  "安装状态栏", "开启状态栏", "切换主题", "change theme".
---

# Claude Code Status Line

A lightweight, single-line status bar for Claude Code that refreshes after every
AI response. Keeps you situationally aware during long coding sessions.

**Field reference:**

```
DeepSeek-V4-flash | src/components | 43% (86k/200k) | think | high
├── model ─────── ┬── dir ─────── ┬── context ─────── ┬── think ┬── effort
                  │               │
              magenta bold    green(<50%)/
                              yellow(50-80%)/
                              red(>80%)
```

## Quick Install

```bash
brew install jq
git clone https://github.com/tsingke/claude-code-statusline.git
cd claude-code-statusline
chmod +x scripts/install.sh
./scripts/install.sh
# Restart Claude Code
```

## Configuration

```bash
# List / switch theme
~/.claude/statusline-config.sh theme
~/.claude/statusline-config.sh theme ocean

# Change field separator
~/.claude/statusline-config.sh separator '•'

# Toggle field visibility
~/.claude/statusline-config.sh show +fast     # add field
~/.claude/statusline-config.sh show -duration # remove field

# Show current config
~/.claude/statusline-config.sh status
```

Recommended alias: `alias statusline='~/.claude/statusline-config.sh'`

## Themes (10)

| Theme | Palette |
|-------|---------|
| default | Magenta model, blue dir, green/yellow/red context |
| ocean | Cyan model, blue dir, cool tones |
| monokai | Yellow model, cyan dir, warm Monokai-inspired palette |
| minimal | Low contrast, clean and unobtrusive |
| neon | Bright neon colors for dark terminals |
| forest | Green model, amber dir, nature-inspired earthy palette |
| nord | Blue model, cyan dir, arctic blue-grey clean palette |
| lavender | Magenta model, cyan dir, soft purple elegant palette |
| gruvbox | Yellow model, green dir, retro warm vim-inspired palette |
| sakura | Pink model, cyan dir, cherry blossom delicate palette |

## Available Fields

`model` `dir` `context` `think` `effort` `agent` `fast` `duration`

## Uninstall

```bash
cd claude-code-statusline
./scripts/uninstall.sh
```

Full documentation: [README.md](README.md) | [README.zh-CN.md](README.zh-CN.md)
