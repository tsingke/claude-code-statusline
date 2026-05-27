<h1 align="center">Claude Code Status Line</h1>

<p align="center">
  <em>A real-time status bar for Claude Code — stay situationally aware during long coding sessions.</em>
  <br>Supports 5 color themes and per-field visibility toggling
</p>

<p align="center">
  <a href="#-features">Features</a> •
  <a href="#-screenshots">Screenshots</a> •
  <a href="#-field-reference">Field Reference</a> •
  <a href="#-themes">Themes</a> •
  <a href="#-quick-install">Install</a> •
  <a href="#-configuration-cli">Configuration</a> •
  <a href="README.md">中文</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/license-MIT-blue" alt="MIT License">
  <br>
  <img src="screenshots/statusbar-normal.png" alt="Normal mode" width="600">
</p>

---

## 📸 Screenshots

| Normal Mode | Context Warning | Agent Mode |
|:---:|:---:|:---:|
| ![Normal](screenshots/statusbar-normal.png) | ![Warning](screenshots/statusbar-warning.png) | ![Agent](screenshots/statusbar-agent.png) |
| Healthy context (< 50%) | Elevated usage (50-80%) | Context danger (> 80%) |

![Full Interface](screenshots/statusbar-simulator.png)

---

## ✨ Features

- **⚡ Real-time updates** — refreshes automatically after every AI response
- **📏 One line** — compact, non-intrusive display at the bottom of your terminal
- **🧠 Model & Reasoning** — shows current AI model name; `think` indicator appears during deep reasoning
- **📂 Smart directory** — auto-shortened path (last 2 levels), `~` for home
- **📊 Context monitoring** — usage percentage + precise token count with color-coded warnings
- **🎨 5 color themes** — switch between default, ocean, monokai, minimal, neon
- **🔧 Field toggling** — show/hide any individual field
- **⏱️ Session duration** — elapsed time since session start
- **🤖 Agent indicator** — shows agent subprocess name in yellow

---

## 📊 Field Reference

| Field | Meaning | Color | Example |
|-------|---------|-------|---------|
| **Model** | Current AI model | 🔮 Magenta bold | `DeepSeek-V4-flash` |
| **Directory** | Working directory | 🔵 Blue | `src/components` |
| **Context** | Usage % + tokens | 🟢 Green / 🟡 Yellow / 🔴 Red | `43% (86k/200k)` |
| **think** | Deep reasoning mode | Dim italic | `think` |
| **Agent** | Agent subprocess name | 🟡 Yellow | `explore` |
| **effort** | Focus level | 🌊 Cyan | `high` |
| **fast** | Fast mode | 🌊 Cyan | `fast` |
| **Duration** | Session elapsed time | 🌊 Cyan | `12m30s` |

### Context Color Thresholds

| Usage | Color | Meaning | Action |
|-------|:----:|---------|--------|
| < 50% | 🟢 **Green** | Healthy | Continue |
| 50% – 80% | 🟡 **Yellow** | Caution | Consider trimming context |
| > 80% | 🔴 **Red** | Danger | Start a new session |

---

## 🎨 Themes

Switch between 5 built-in color themes:

| Theme | Style | Model Color | Dir Color |
|-------|-------|-------------|-----------|
| **default** | Original (magenta/blue/green) | 🔮 Magenta | 🔵 Blue |
| **ocean** | Cool cyan/blue tones | 🌊 Cyan | 🔵 Blue |
| **monokai** | Monokai-inspired warm palette | 🟡 Gold | 🌊 Cyan |
| **minimal** | Low contrast, clean | ⚪ Gray | ⚪ Gray |
| **neon** | Bright neon colors | 🔮 Magenta | 🌊 Cyan |

```bash
~/.claude/statusline-config.sh theme          # List available themes
~/.claude/statusline-config.sh theme ocean    # Switch to ocean theme
```

---

## 🚀 Quick Install

### Prerequisites

- [Claude Code](https://claude.ai/code) installed
- [jq](https://jqlang.github.io/jq/) for JSON parsing

```bash
brew install jq
```

### Option 1: One-liner (recommended)

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tsingke/claude-code-statusline/main/scripts/install.sh)"
```

### Option 2: Manual

```bash
git clone https://github.com/tsingke/claude-code-statusline.git
cd claude-code-statusline
chmod +x scripts/install.sh
./scripts/install.sh
```

### Option 3: As a Claude Code Skill

Inside Claude Code, say `install statusline` or `/claude-statusline`.

### What the installer does:

1. ✅ Copies `statusline.sh` → `~/.claude/statusline.sh`
2. ✅ Copies `statusline-config.sh` → `~/.claude/` (configuration CLI)
3. ✅ Registers SKILL.md as a Claude Code skill
4. ✅ Adds statusLine config to `settings.json`
5. ✅ Creates default config `statusline-config.json`
6. ✅ Makes scripts executable

> **Restart Claude Code** after installation to see the status bar.

---

## ⚙️ Configuration CLI

After installation, configure via `~/.claude/statusline-config.sh`. Add an alias for convenience:

```bash
echo 'alias statusline="~/.claude/statusline-config.sh"' >> ~/.zshrc
source ~/.zshrc
```

### Switch themes

```bash
statusline theme           # List all themes
statusline theme ocean     # Switch to ocean theme
statusline theme monokai   # Switch to monokai theme
```

### Change separator

```bash
statusline separator '•'
statusline separator '│'
statusline separator ' ▏'
```

### Toggle field visibility

```bash
statusline show            # List visible fields
statusline show +fast      # Show fast mode indicator
statusline show -duration  # Hide session duration
statusline show +agent     # Show agent name
```

### View current config

```bash
statusline status
```

---

## 🔧 How It Works

Claude Code's built-in `statusLine` configuration lets you specify a shell script that runs after every assistant response. The script receives a JSON payload on **stdin** with full session state, and the line it writes to **stdout** appears at the bottom of the terminal.

```
Claude Code completes a response
         │
         ▼
Builds session state JSON (model, cwd, context, cost, ...)
         │
  stdin  ▼
┌──────────────────────────┐
│     statusline.sh        │  ← jq parses JSON, script formats + colors
└──────────────────────────┘
         │
  stdout ▼
Terminal bottom bar
```

---

## 🎨 Customization

The JSON payload from Claude Code includes many fields. You can easily extend the script to show additional information:

```bash
# Additional fields you can add to statusline.sh
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // ""')         # Total cost (USD)
lines=$(echo "$input" | jq -r '.cost.total_lines_added // ""')     # Lines of code added
session=$(echo "$input" | jq -r '.session_name // ""')             # Session name
```

**Debugging tip**: To inspect the full JSON payload, add this line right after `read -r input`:

```bash
echo "$input" > /tmp/claude_statusline_debug.json
```

Then trigger a Claude Code response and check the file.

---

## 📦 Project Structure

```
claude-code-statusline/
├── index.html                    # Project landing page
├── README.md                     # Chinese documentation (default)
├── README.en.md                  # English documentation
├── LICENSE                       # MIT License
├── SKILL.md                      # Claude Code skill registry
├── scripts/
│   ├── statusline.sh             # Core script (with 5 themes)
│   ├── statusline-config.sh      # Configuration CLI (theme/separator/fields)
│   ├── install.sh                # Automated installer
│   └── uninstall.sh              # Automated uninstaller
└── screenshots/
    ├── statusbar-simulator.png   # Full interface preview
    ├── statusbar-closeup.png     # Status bar close-up
    ├── statusbar-normal.png      # Normal mode
    ├── statusbar-warning.png     # Warning mode
    └── statusbar-agent.png       # Agent mode
```

---

## 🗑️ Uninstall

```bash
cd claude-code-statusline
./scripts/uninstall.sh
```

Or manually:

```bash
rm -f ~/.claude/statusline.sh ~/.claude/statusline-config.sh ~/.claude/statusline-config.json
```

And remove the `"statusLine"` entry from `~/.claude/settings.json`.

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Built for the Claude Code community
</p>
