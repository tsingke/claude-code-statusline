<h1 align="center">Claude Code 状态栏</h1>

<p align="center">
  <em>为 Claude Code 打造的情境感知状态栏——模型、目录、上下文、推理模式，一眼尽览。</em>
  <br>支持 5 套配色主题与字段自定义
</p>

<p align="center">
  <a href="#-功能特性">功能特性</a> •
  <a href="#-效果预览">效果预览</a> •
  <a href="#-字段说明">字段说明</a> •
  <a href="#-配色主题">配色主题</a> •
  <a href="#-快速安装">快速安装</a> •
  <a href="#-配置-cli">配置 CLI</a> •
  <a href="README.en.md">English</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/license-MIT-blue" alt="MIT License">
  <img src="screenshots/statusbar-normal.png" alt="正常模式" width="600">
</p>

---

## 📸 效果预览

| 正常模式 | 上下文偏高 | 上下文预警 |
|:---:|:---:|:---:|
| ![正常](screenshots/statusbar-normal.png) | ![偏高](screenshots/statusbar-warning.png) | ![预警](screenshots/statusbar-agent.png) |
| 上下文健康 (< 50%) | 较高占用 (50-80%) | 危险占用 (> 80%) |

![完整界面](screenshots/statusbar-simulator.png)

---

## ✨ 功能特性

- **⚡ 实时更新** — 每次 AI 回复后自动刷新，无需手动触发
- **📏 单行显示** — 紧凑设计，不干扰主工作区
- **🧠 模型与推理** — 显示当前 AI 模型名，深度思考时自动出现 `think` 标识
- **📂 智能目录** — 路径智能缩短（保留最后 2 级），`~` 代替 Home
- **📊 上下文监控** — 实时占用百分比 + 精确 token 用量，颜色预警
- **🎨 5 套主题** — default / ocean / monokai / minimal / neon 一键切换
- **🔧 字段开关** — 每个字段独立开关，只显示关心的信息
- **⏱️ 会话时长** — 记录会话已用时间，帮你判断是否需清理上下文
- **🤖 Agent 标识** — 黄色显示 Agent 子进程名称

---

## 📊 字段说明

| 字段 | 含义 | 颜色 | 示例 |
|------|------|------|------|
| **Model** | 当前 AI 模型 | 🔮 品红加粗 | `DeepSeek-V4-flash` |
| **Directory** | 当前工作目录 | 🔵 蓝色 | `src/components` |
| **Context** | 占用百分比 + token | 🟢 绿 / 🟡 黄 / 🔴 红 | `43% (86k/200k)` |
| **think** | 深度思考模式 | 灰色斜体 | `think` |
| **Agent** | Agent 子进程名称 | 🟡 黄色 | `explore` |
| **effort** | 专注模式级别 | 🌊 青色 | `high` |
| **fast** | 快速模式 | 🌊 青色 | `fast` |
| **Duration** | 会话已用时间 | 🌊 青色 | `12m30s` |

### 上下文颜色阈值

| 占用率 | 颜色 | 含义 | 建议 |
|--------|:----:|------|------|
| < 50% | 🟢 **绿色** | 健康 | 继续工作 |
| 50% – 80% | 🟡 **黄色** | 注意 | 考虑精简上下文 |
| > 80% | 🔴 **红色** | 危险 | 建议开启新会话 |

---

## 🎨 配色主题

内置 5 套配色主题，一键切换，满足不同终端审美：

| 主题 | 风格 | 模型色 | 目录色 |
|------|------|--------|--------|
| **default** | 原版配色（品红/蓝/绿） | 🔮 品红 | 🔵 蓝 |
| **ocean** | 冷色系：青蓝调 | 🌊 青 | 🔵 蓝 |
| **monokai** | Monokai 暖色调 | 🟡 金黄 | 🌊 青 |
| **minimal** | 低对比度简洁版 | ⚪ 灰白 | ⚪ 灰白 |
| **neon** | 霓虹亮色 | 🔮 品红 | 🌊 青 |

```bash
~/.claude/statusline-config.sh theme          # 列出可用主题
~/.claude/statusline-config.sh theme ocean    # 切换到 ocean 主题
```

---

## 🚀 快速安装

### 前置依赖

- [Claude Code](https://claude.ai/code) 已安装
- [jq](https://jqlang.github.io/jq/)（JSON 解析器）

```bash
brew install jq
```

### 方式一：一键安装（推荐）

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tsingke/claude-code-statusline/main/scripts/install.sh)"
```

### 方式二：手动安装

```bash
git clone https://github.com/tsingke/claude-code-statusline.git
cd claude-code-statusline
chmod +x scripts/install.sh
./scripts/install.sh
```

### 方式三：作为 Claude Code Skill

在 Claude Code 中说：`安装状态栏` 或 `/claude-statusline`

### 安装脚本自动完成：

1. ✅ 复制 `statusline.sh` → `~/.claude/statusline.sh`
2. ✅ 复制 `statusline-config.sh` → `~/.claude/`（配置 CLI）
3. ✅ 注册 SKILL.md 为 Claude Code 技能
4. ✅ 添加 statusLine 配置到 `settings.json`
5. ✅ 创建默认配置文件 `statusline-config.json`
6. ✅ 赋予脚本执行权限

> **重启 Claude Code** 后状态栏即可生效。

---

## ⚙️ 配置 CLI

安装后通过 `~/.claude/statusline-config.sh` 进行配置。推荐添加别名：

```bash
echo 'alias statusline="~/.claude/statusline-config.sh"' >> ~/.zshrc
source ~/.zshrc
```

### 切换主题

```bash
statusline theme           # 列出所有主题
statusline theme ocean     # 切换到 ocean 主题
statusline theme monokai   # 切换到 monokai 主题
```

### 修改分隔符

```bash
statusline separator '•'
statusline separator '│'
statusline separator ' ▏'
```

### 开关字段显示

```bash
statusline show            # 列出当前可见字段
statusline show +fast      # 显示快速模式
statusline show -duration  # 隐藏会话时长
statusline show +agent     # 显示 Agent 名称
```

### 查看当前配置

```bash
statusline status
```

---

## 🔧 实现原理

Claude Code 内置的 `statusLine` 配置项允许指定一个 shell 脚本，该脚本在每次 AI 回复后自动执行，并通过 **stdin** 接收完整的会话状态 JSON。脚本输出到 **stdout** 的内容将显示在终端底部。

```
Claude Code 完成响应
         │
         ▼
构建会话状态 JSON (模型, 目录, 上下文, 耗时...)
         │
  stdin  ▼
┌──────────────────────────┐
│     statusline.sh        │  ← jq 解析 JSON, 脚本格式化 + 着色
└──────────────────────────┘
         │
  stdout ▼
   终端底部状态栏
```

---

## 🎨 自定义

Claude Code 发送的 JSON 包含丰富的会话状态字段，你可以自由扩展脚本，添加更多信息：

```bash
# 可添加的字段示例（在 statusline.sh 中）
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // ""')         # 累计费用（USD）
lines=$(echo "$input" | jq -r '.cost.total_lines_added // ""')     # 新增代码行数
session=$(echo "$input" | jq -r '.session_name // ""')             # 会话名称
```

**调试技巧**：在 `read -r input` 后添加一行，可将完整 JSON 保存到文件：

```bash
echo "$input" > /tmp/claude_statusline_debug.json
```

触发一次 Claude Code 回复，检查该文件即可看到所有可用字段。

---

## 📦 项目结构

```
claude-code-statusline/
├── index.html                    # 项目介绍页
├── README.md                     # 中文文档（默认）
├── README.en.md                  # English documentation
├── LICENSE                       # MIT 许可证
├── SKILL.md                      # Claude Code 技能注册
├── scripts/
│   ├── statusline.sh             # 状态栏核心脚本（含 5 套主题）
│   ├── statusline-config.sh      # 配置 CLI（主题/分隔符/字段开关）
│   ├── install.sh                # 自动安装脚本
│   └── uninstall.sh              # 自动卸载脚本
└── screenshots/
    ├── statusbar-simulator.png   # 完整界面截图
    ├── statusbar-closeup.png     # 状态栏特写
    ├── statusbar-normal.png      # 正常模式
    ├── statusbar-warning.png     # 偏高模式
    └── statusbar-agent.png       # Agent 模式
```

---

## 🗑️ 卸载

```bash
cd claude-code-statusline
./scripts/uninstall.sh
```

或手动清理：

```bash
rm -f ~/.claude/statusline.sh ~/.claude/statusline-config.sh ~/.claude/statusline-config.json
```

并从 `~/.claude/settings.json` 中删除 `"statusLine"` 配置项。

---

## 📄 许可证

本项目基于 MIT 许可证开源，详情见 [LICENSE](LICENSE) 文件。

---

<p align="center">
  为 Claude Code 社区打造
</p>
