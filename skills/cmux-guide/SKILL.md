---
name: cmux-guide
description: Quick reference and integration guidelines for working with cmux (terminal multiplexer for AI agents).
---

# cmux Guide & Cheatsheet

`cmux` is a native macOS terminal application designed specifically for developers working with agentic AI workflows. It leverages the Ghostty terminal engine and exposes a Unix socket API and command-line interface for programmatic control of windows, panes, tabs (workspaces), markdown rendering, diff viewers, status notifications, and browser automation.

---

## 1. Quick Reference Commands

### Workspace & Window Management
- **List workspaces**: `cmux list-workspaces`
- **Create new workspace**: `cmux new-workspace [--cwd <path>] [--command <cmd>]`
- **Select workspace**: `cmux select-workspace --workspace <id>`
- **Close workspace**: `cmux close-workspace --workspace <id>`
- **Rename workspace**: `cmux rename-workspace <title>`
- **Current workspace ID**: `cmux current-workspace`

### Pane & Tab splits
- **Split current pane**: `cmux new-split <left|right|up|down>`
- **Create a new pane**: `cmux new-pane [--type terminal|browser]`
- **List panes**: `cmux list-panes`
- **Swap panes**: `cmux swap-pane --pane <id> --target-pane <id>`
- **Drag a tab to split**: `cmux drag-surface-to-split --surface <id> <left|right|up|down>`

---

## 2. Presentation Tools

### Markdown Live Viewer
Opens a markdown file in a beautifully formatted viewer pane that auto-refreshes on disk changes:
```bash
cmux markdown "<path>" [--focus <true|false>] [--direction <left|right|up|down>]
```
- **Example**: `cmux markdown "plan.md" --focus false`

### Git & Patch Diff Viewer
Opens a visual diff inside a browser split within the active workspace:
```bash
# View unstaged changes
cmux diff --source unstaged

# View staged changes
cmux diff --source staged

# Open a specific patch file
cmux diff "fix.patch"
```

---

## 3. UI Status, Progress & Notifications

You can programmatically set status labels, icons, progress bars, and send system notifications.

### Status & Progress
- **Set Status**: `cmux set-status <key> <value> [--icon <name>] [--color <#hex>]`
  - *Example*: `cmux set-status test_run "Running unit tests..." --icon "beaker" --color "#FFA500"`
- **Clear Status**: `cmux clear-status <key>`
- **Set Progress**: `cmux set-progress <0.0-1.0> [--label <text>]`
  - *Example*: `cmux set-progress 0.75 --label "75% Done"`
- **Clear Progress**: `cmux clear-progress`

### Notifications
Sends in-app notifications that are visible in the cmux interface and sidebar:
```bash
cmux notify --title "<title>" [--subtitle "<subtitle>"] [--body "<body>"]
```
- **Example**: `cmux notify --title "Build Successful" --body "Production build compiled in 12s."`

---

## 4. Browser Automation

`cmux` features an integrated scriptable WebKit browser. You can automate web testing, local server previewing, and DOM interactions.

### Browser Basics
- **Open browser split**: `cmux browser open [url]`
- **Navigate to URL**: `cmux browser navigate <url>`
- **Inspect Console/DevTools**: `cmux browser devtools toggle`
- **Capture screenshot**: `cmux browser screenshot --out screenshot.png`

### DOM Actions
- **Wait for selector**: `cmux browser wait --selector "#submit-btn"`
- **Click element**: `cmux browser click "#submit-btn"`
- **Type text**: `cmux browser type "#username" "my_username"`
- **Get page text**: `cmux browser get text`
- **Evaluate JS**: `cmux browser eval "document.title"`

---

## 5. Spawning Dev Servers & Background Workflows

When launching long-running processes (like backend servers, database proxies, or frontend watchers) that require continuous log tracking, do NOT run them as silent background agent tasks. Instead, spawn them in a new `cmux` workspace (tab) so they are visible, interactive, and easy to monitor.

### Command Example:
```bash
cmux new-workspace --cwd "<path-to-project-root>" --command "node --env-file=.env backend/server.js"
```

This command creates a new workspace tab, sets its current working directory, starts the server process inside it, and keeps the terminal window open for log inspection.

