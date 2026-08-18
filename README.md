# cmux-agent-tools

A centralized collection of developer configurations, agent instructions, and reference skills designed to help AI coding agents (like Claude and Gemini) seamlessly interact with and present workspace details in the `cmux` terminal.

By storing these configurations here and symlinking them to your various workspace and global agent config paths, you can easily version control, customize, and share your `cmux` integrations!

---

## Repository Structure

```text
cmux-agent-tools/
├── rules/
│   └── cmux.md           # Instructions on how and when the agent should use cmux (live rendering, diffs, etc.)
├── skills/
│   └── cmux-guide/
│       └── SKILL.md      # A unified reference sheet of cmux CLI & browser commands for the agent
├── hooks.json            # Deterministic lifecycle hook configuration (for Gemini)
├── hooks/
│   └── post-tool.py      # Python script that intercepts tool writes to open .md files automatically
├── shell/
│   └── aliases.zsh       # Shell aliases/shorthands for manually using cmux (cmdown, cmdiff, cmnotify, etc.)
├── layouts/
│   └── agent-center.json # Template workspace layout (main terminal, plan pane, browser preview)
├── examples/
│   └── browser-automation.sh # Sample shell script demonstrating cmux browser commands
├── install.sh            # Setup helper to symlink rules, skills, hooks, and add shell aliases
├── .gitignore
├── LICENSE
└── README.md
```

---

## Installation

Run the `install.sh` script to symlink the rules, skills, hooks, and optionally add shell aliases to your `~/.zshrc`.

### Options

```bash
# View usage help
./install.sh --help

# Install rules & skills to the current project's `.agents/` folder:
./install.sh --workspace

# Install to global Claude configuration (creates ~/.claude/skills/ and configures settings.json hooks):
./install.sh --claude

# Install to global Gemini configuration (~/.gemini/config):
./install.sh --gemini

# Append shell aliases to ~/.zshrc:
./install.sh --shell

# Install to all available destinations:
./install.sh --all
```

---

## Manual Shell Integration

The `shell/aliases.zsh` script provides simple shorthand commands fow working inside `cmux` manually:

- **`cmdown <file>`**: Render markdown file inside `cmux` split.
- **`cmdiff`**: Open unstaged git changes side-by-side.
- **`cmopen <url>`**: Open a browser tab inside `cmux`.
- **`cmnotify <title> <body>`**: Show system notification popup in `cmux`.
- **`cmstatus <message> [icon] [color]`**: Update workspace status indicator.
- **`cmprogress <value> [label]`**: Update progress percentage (0.0 to 1.0).

*To apply aliases to your active terminal, run: `source ~/.zshrc`*

---

## Custom Workspace Layouts

You can use [layouts/agent-center.json](file:///Users/sebastianlasisz/workspace/repositories/ai_tools/cmux_automation/layouts/agent-center.json) as a template for project-specific window layouts. Copy it to your project root under `.cmux/cmux.json` to spin up splits automatically.

---

## Browser Automation Example

Run the demo script [examples/browser-automation.sh](file:///Users/sebastianlasisz/workspace/repositories/ai_tools/cmux_automation/examples/browser-automation.sh) to see `cmux` WebKit browser commands in action. It will navigate to GitHub, perform a search, capture page details, and save a screenshot locally!
