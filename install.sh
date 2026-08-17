#!/bin/bash
# install.sh - Installs cmux rules and skills by symlinking them to the target environment directories.

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULE_SRC="${REPO_DIR}/rules/cmux.md"
SKILL_SRC="${REPO_DIR}/skills/cmux-guide/SKILL.md"

show_help() {
    echo "Usage: ./install.sh [options]"
    echo ""
    echo "Options:"
    echo "  -w, --workspace      Install rules & skills to the current directory's .agents/ directory"
    echo "  -c, --claude         Install rules & skills to the global ~/.claude/ directory"
    echo "  -g, --gemini         Install rules & skills to the global ~/.gemini/config/ directory"
    echo "  -a, --all            Install to all targets"
    echo "  -h, --help           Show this help message"
}

symlink_file() {
    local src="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    if [ -L "$dest" ] || [ -f "$dest" ]; then
        rm -f "$dest"
    fi
    ln -s "$src" "$dest"
    echo "Linked: $dest -> $src"
}

append_to_claude_md() {
    local claude_md="$1"
    if [ ! -f "$claude_md" ]; then
        echo "Creating $claude_md..."
        echo "<!-- jbcontext-instructions-start -->" > "$claude_md"
        echo "<!-- jbcontext-instructions-end -->" >> "$claude_md"
    fi

    if grep -q "cmux Integration Rules" "$claude_md"; then
        echo "cmux rules already exist in $claude_md"
    else
        echo "Appending cmux rules to $claude_md..."
        cat << 'EOF' >> "$claude_md"

# cmux Integration Rules

This rule defines how you should automatically leverage `cmux` command-line tools to enhance the user experience and workspace presentation.

## Guidelines

1. **Environment Detection**:
   Before running any `cmux` command, verify that you are inside a `cmux` session (check if `CMUX_SOCKET_PATH` or `CMUX_WORKSPACE_ID` is set, or if `which cmux` succeeds). If not in a `cmux` session, fall back gracefully to standard operations.

2. **Auto-Opening Markdown Files**:
   - Whenever you create or modify a markdown file (such as plans, walkthroughs, or guides), you MUST automatically open it in a `cmux` split.
   - Run: `cmux markdown "<path>" --focus false` (use `--focus true` if user action is needed).

3. **Reviewing Git Diffs & Patches**:
   - When presenting unstaged/staged changes, branch comparisons, or patch files, open them in the `cmux` diff viewer:
     `cmux diff --source unstaged` or `cmux diff "<patch-file>"`.

4. **Progress and Status Updates**:
   - For long-running commands (e.g. builds, tests, scraping), update `cmux` status and progress:
     - `cmux set-status progress "Running tests..." --icon "play" --color "#00FF00"`
     - `cmux set-progress 0.5`
     - Clean up: `cmux clear-status progress` and `cmux clear-progress`.

5. **Notifications**:
   - Call `cmux notify` when long-running background tasks finish or when waiting for user input.
EOF
        echo "Rules successfully appended!"
    fi
}

install_workspace() {
    local target_dir="./.agents"
    echo "Installing to workspace: $target_dir"
    symlink_file "$RULE_SRC" "${target_dir}/rules/cmux.md"
    symlink_file "$SKILL_SRC" "${target_dir}/skills/cmux-guide/SKILL.md"
    echo "Workspace installation complete! 🎉"
}

install_claude() {
    local target_dir="${HOME}/.claude"
    echo "Installing to Claude global config: $target_dir"
    symlink_file "$RULE_SRC" "${target_dir}/rules/cmux.md"
    symlink_file "$SKILL_SRC" "${target_dir}/skills/cmux-guide/SKILL.md"
    append_to_claude_md "${target_dir}/CLAUDE.md"
    echo "Claude global installation complete! 🎉"
}

install_gemini() {
    local target_dir="${HOME}/.gemini/config"
    echo "Installing to Gemini global config: $target_dir"
    symlink_file "$RULE_SRC" "${target_dir}/rules/cmux.md"
    symlink_file "$SKILL_SRC" "${target_dir}/skills/cmux-guide/SKILL.md"
    echo "Gemini global installation complete! 🎉"
}

if [ "$#" -eq 0 ]; then
    show_help
    exit 1
fi

while [ "$#" -gt 0 ]; do
    case "$1" in
        -w|--workspace)
            install_workspace
            shift
            ;;
        -c|--claude)
            install_claude
            shift
            ;;
        -g|--gemini)
            install_gemini
            shift
            ;;
        -a|--all)
            install_workspace
            install_claude
            install_gemini
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done
