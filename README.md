<h1 align="center">
  Claude Code Status Line
</h1>

<p align="center">
  <em>A real-time status bar for Claude Code — stay situationally aware during long coding sessions.</em>
</p>

<p align="center">
  <a href="#-features">Features</a> •
  <a href="#-demo">Demo</a> •
  <a href="#-quick-install">Install</a> •
  <a href="#-customization">Customize</a> •
  <a href="#-project-structure">Structure</a> •
  <a href="README.zh-CN.md">中文</a>
</p>

<br>

## 📸 Screenshots

| Normal Mode | Context Warning | Agent Mode |
|:---:|:---:|:---:|
| ![Normal](screenshots/statusbar-normal.png) | ![Warning](screenshots/statusbar-warning.png) | ![Agent](screenshots/statusbar-agent.png) |
| Healthy context (< 50%) | Elevated usage (50-80%) | Context danger (> 80%) |

![Full Interface](screenshots/statusbar-simulator.png)

---

## ✨ Features

- **Real-time updates** — refreshes automatically after every AI response
- **One line** — compact, non-intrusive display at the bottom of your terminal
- **Model display** — shows the current AI model name (e.g., `DeepSeek-V4-flash`)
- **Working directory** — smart-shortened path (last 2 levels, `~` for home)
- **Context monitoring** — usage percentage + precise token count
- **Color-coded warnings** — green (healthy) → yellow (caution) → red (danger)
- **Thinking indicator** — shows "think" when deep reasoning is active
- **Effort level** — displays focus mode (`high`, `agent`, etc.)
- **Agent mode** — shows agent name in yellow when using sub-agents

## 📊 Field Reference

| Field | Meaning | Color | Example |
|-------|---------|-------|---------|
| Model | Current AI model | **Magenta** bold | `DeepSeek-V4-flash` |
| Directory | Working directory | **Blue** | `web test/project` |
| Context | Context usage % + tokens | **Green** / **Yellow** / **Red** | `43% (86k/200k)` |
| think | Deep thinking enabled | *Dim italic* | `think` |
| Agent | Agent subprocess name | **Yellow** | `explore` |
| Effort | Focus level | **Cyan** | `high` |

### Context Color Thresholds

| Usage | Color | Meaning | Action |
|-------|-------|---------|--------|
| < 50% | 🟢 Green | Healthy | Continue |
| 50-80% | 🟡 Yellow | Caution | Consider trimming context |
| > 80% | 🔴 Red | Danger | Start a new session |

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
# Clone the repo
git clone https://github.com/tsingke/claude-code-statusline.git
cd claude-code-statusline

# Run the installer
chmod +x scripts/install.sh
./scripts/install.sh
```

### Option 3: As a Claude Code Skill

1. From Claude Code, say: `install claude statusline skill`
2. Or download the `.skill` file from Releases

### What the installer does:

1. Copies `scripts/statusline.sh` → `~/.claude/statusline.sh`
2. Adds `statusLine` config entry to `~/.claude/settings.json`
3. Makes the script executable

> **Restart Claude Code** after installation to see the status bar.

---

## 🔧 How It Works

Claude Code's built-in `statusLine` configuration lets you specify a shell script
that runs after every assistant response. The script receives a JSON payload on
**stdin** with full session state, and the line it writes to **stdout** appears
at the bottom of the terminal.

```
Claude Code completes a response
         │
         ▼
Builds session state JSON (model, cwd, context, cost, …)
         │
  stdin  ▼
┌──────────────────┐
│  statusline.sh   │  ← jq parses JSON, script formats + colors
└──────────────────┘
         │
  stdout ▼
Terminal bottom bar
```

---

## 🎨 Customization

The JSON payload from Claude Code includes many fields. You can easily extend
the script to show additional information:

```bash
# Available fields you can add
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // ""')
duration=$(echo "$input" | jq -r '.cost.total_duration_ms // ""')
lines=$(echo "$input" | jq -r '.cost.total_lines_added // ""')
fast=$(echo "$input" | jq -r '.fast_mode // false')
session=$(echo "$input" | jq -r '.session_name // ""')
```

**Debugging tip**: To inspect the full JSON payload, add this line right after
`read -r input`:

```bash
echo "$input" > /tmp/claude_statusline_debug.json
```

Then trigger a Claude Code response and check the file.

---

## 📦 Project Structure

```
claude-code-statusline/
├── README.md                    # English documentation
├── README.zh-CN.md              # Chinese documentation
├── LICENSE                      # MIT License
├── SKILL.md                     # Claude Code skill registry
├── scripts/
│   ├── statusline.sh            # Core status bar script
│   ├── install.sh               # Automated installer
│   └── uninstall.sh             # Automated uninstaller
└── screenshots/
    ├── statusbar-simulator.png  # Full interface preview
    └── statusbar-closeup.png    # Status bar close-up
```

---

## 🗑️ Uninstall

```bash
# Clone if you haven't already
git clone https://github.com/tsingke/claude-code-statusline.git
cd claude-code-statusline
./scripts/uninstall.sh

# Or just clean up manually:
rm -f ~/.claude/statusline.sh
# And remove the "statusLine" entry from ~/.claude/settings.json
```

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Built with ❤️ for the Claude Code community
</p>
