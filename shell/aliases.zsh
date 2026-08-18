# cmux_aliases.zsh - Shell shortcuts for cmux terminal integration.

# Shorthands for CLI operations
alias cmdown="cmux markdown"
alias cmdiff="cmux diff --source unstaged"
alias cmopen="cmux browser open"
alias cmclose="cmux close-workspace"
alias cmlist="cmux list-workspaces"

# Functions for status and progress updates
cmnotify() {
    local title="${1:-Notification}"
    local body="${2:-Task complete!}"
    cmux notify --title "$title" --body "$body"
}

cmstatus() {
    local message="$1"
    local icon="${2:-info}"
    local color="${3:-#58a6ff}"
    if [ -z "$message" ]; then
        cmux clear-status progress
    else
        cmux set-status progress "$message" --icon "$icon" --color "$color"
    fi
}

cmprogress() {
    local value="$1"
    local label="$2"
    if [ -z "$value" ]; then
        cmux clear-progress
    else
        if [ -n "$label" ]; then
            cmux set-progress "$value" --label "$label"
        else
            cmux set-progress "$value"
        fi
    fi
}
