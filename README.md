# cmux_automation

A central repository containing `cmux` integration rules and skills for AI agents (Gemini/Antigravity and Claude). 

By storing these configurations here and symlinking them to your various workspace and global agent config paths, you can easily version control, customize, and share your `cmux` integrations!

---

## Repository Structure

```text
cmux_automation/
├── rules/
│   └── cmux.md           # Instructions on how and when the agent should use cmux (live rendering, diffs, etc.)
├── skills/
│   └── cmux-guide/
│       └── SKILL.md      # A unified reference sheet of cmux CLI & browser commands for the agent
├── install.sh            # Setup helper to symlink rules and skills
└── README.md
```

---

## Installation

Run the `install.sh` script to symlink the rules and skills to your target directory. Symlinking ensures that whenever you pull updates or make changes to this repository, your agents immediately see them!

### Options

```bash
# View usage help
./install.sh --help

# Install rules & skills to the current project's `.agents/` folder:
./install.sh --workspace

# Install to global Claude configuration (creates ~/.claude/skills/ and appends rules to CLAUDE.md):
./install.sh --claude

# Install to global Gemini configuration (~/.gemini/config):
./install.sh --gemini

# Link to all available destinations:
./install.sh --all
```

---

## Features Handled By The Rules

1. **Auto-Opening Markdown Files**: Automatically opens newly created or edited `.md` files in a live-reloading split viewer pane (`cmux markdown`).
2. **Interactive Git Diffs**: Shows staged/unstaged changes or custom patch files in the `cmux` unified browser split (`cmux diff`).
3. **Status Bar Updates**: Feeds current actions and progress values to the status display in the sidebar (`cmux set-status` and `cmux set-progress`).
4. **Agent-Aware Notifications**: Triggers system alerts (`cmux notify`) on task completion or when input is required.
