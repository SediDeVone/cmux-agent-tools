# cmux Integration Rules

This rule defines how the agent should automatically leverage `cmux` command-line tools to enhance the user experience and workspace presentation.

## Guidelines

### 1. Environment Detection
Before running any `cmux` command, verify that the environment is inside a `cmux` session. This can be checked via the presence of the `CMUX_SOCKET_PATH` or `CMUX_WORKSPACE_ID` environment variables, or by checking if `which cmux` succeeds. If not in a `cmux` session, fall back gracefully to standard commands (e.g. standard file writing or standard terminal outputs).

### 2. Auto-Opening Markdown Files
- Whenever you create or modify a markdown file (such as implementation plans, walkthroughs, or guides), you MUST automatically open it via the `cmux-md` wrapper.
- Run:
  ```bash
  cmux-md "<path>"
  ```
- Use `--focus true` only if the user explicitly needs to inspect or edit the file immediately.
- `cmux-md` wraps `cmux markdown` and adds three things:
  - **One docs pane per workspace** — markdown tabs are grouped together and never mixed in with terminal tabs.
  - **No duplicates** — re-opening a file that is already visible reuses that tab instead of adding another.
  - **Correct workspace** — it targets `$CMUX_WORKSPACE_ID`, so parallel agents in different workspaces/groups each render into their own pane.
- Tabs are labelled `<parent-folder>/<filename>` so two files with the same basename never collide.
- Do **not** call `cmux markdown` directly; that is what produces dozens of unparented tabs.
- Housekeeping: `cmux-md tidy` pulls stray markdown tabs into the docs pane, `cmux-md list` shows what is open, `cmux-md prune` clears stale registry entries.
- If `cmux` is unavailable the wrapper exits quietly with status 2, so it is safe to call unconditionally.

### 3. Reviewing Git Diffs & Patches
- When presenting unstaged/staged changes, branch comparisons, or patch files to the user, open them in the `cmux` diff viewer:
  ```bash
  cmux diff --source unstaged
  ```
  or for a specific patch file:
  ```bash
  cmux diff "<patch-file>"
  ```
- This launches a side-by-side or unified diff browser split.

### 4. Progress and Status Updates
- For long-running commands (e.g. building projects, running tests, web scraping, or downloading dependencies), update the `cmux` status and progress bar:
  - Setting status: `cmux set-status progress "Running tests..." --icon "play" --color "#00FF00"`
  - Setting progress: `cmux set-progress 0.5`
  - Clearing status: `cmux clear-status progress`
  - Clearing progress: `cmux clear-progress`

### 5. Notifications
- When a background command finishes or if you are waiting for user interaction on a long-running task, notify the user:
  ```bash
  cmux notify --title "Task Complete" --body "Your build succeeded successfully!"
  ```
