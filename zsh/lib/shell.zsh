#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Get shell version
# Usage: shell_ver
# Returns: version number (e.g., "5.9")
shell_ver() {
    print $(get_version "$(zsh --version 2>&1)")
}

# Get shell name
# Usage: shell_name
# Returns: shell name (e.g., "zsh")
shell_name() {
    print "${SHELL:t}"
}

# Get full shell path
# Usage: shell_path
# Returns: full path to current shell
shell_path() {
    print "$SHELL"
}

# Get default shell for current user
# Usage: get_default_shell
# Returns: path to default shell
get_default_shell() {
    if is_macos; then
        dscl . -read ~/ UserShell | awk '{print $2}'
    elif is_linux; then
        getent passwd "$USER" | cut -d: -f7
    fi
}

# Set default shell for current user
# Usage: set_default_shell /path/to/shell
# Returns: 0 on success, 1 on failure
set_default_shell() {
    [[ $# -eq 1 ]] || return 1
    local new_shell="$1"

    # Check if shell exists and is in /etc/shells
    if [[ ! -x "$new_shell" ]]; then
        print "Error: Shell '$new_shell' does not exist or is not executable" >&2
        return 1
    fi

    if ! grep -qx "$new_shell" /etc/shells 2>/dev/null; then
        print "Error: Shell '$new_shell' is not in /etc/shells" >&2
        return 1
    fi

    # Change shell
    if is_macos; then
        chsh -s "$new_shell" && print "Default shell changed to: $new_shell"
    elif is_linux; then
        chsh -s "$new_shell" && print "Default shell changed to: $new_shell"
    fi
}

# Check if running in interactive shell
# Usage: is_interactive
# Returns: 0 (true) or 1 (false)
is_interactive() {
    [[ -o interactive ]]
}

# Check if running in login shell
# Usage: is_login_shell
# Returns: 0 (true) or 1 (false)
is_login_shell() {
    [[ -o login ]]
}

# Get shell level (nesting depth)
# Usage: shell_level
# Returns: nesting level number
shell_level() {
    print ${SHLVL:-1}
}

# Get terminal type
# Usage: terminal_type
# Returns: terminal type (e.g., "xterm-256color")
terminal_type() {
    print "${TERM:-unknown}"
}

# Check if terminal supports colors
# Usage: is_color_terminal
# Returns: 0 (true) or 1 (false)
is_color_terminal() {
    [[ -t 1 && -n "$TERM" && "$TERM" != "dumb" ]]
}

# Get number of terminal columns
# Usage: terminal_columns
# Returns: number of columns
terminal_columns() {
    print ${COLUMNS:-$(tput cols 2>/dev/null || print 80)}
}

# Get number of terminal lines
# Usage: terminal_lines
# Returns: number of lines
terminal_lines() {
    print ${LINES:-$(tput lines 2>/dev/null || print 24)}
}

# Get available shells from /etc/shells
# Usage: get_available_shells
# Returns: list of available shells
get_available_shells() {
    if [[ -f /etc/shells ]]; then
        grep -v '^#' /etc/shells | grep -v '^$'
    fi
}

# Check if running under tmux
# Usage: is_tmux
# Returns: 0 (true) or 1 (false)
is_tmux() {
    [[ -n "$TMUX" ]]
}

# Check if running under screen
# Usage: is_screen
# Returns: 0 (true) or 1 (false)
is_screen() {
    [[ -n "$STY" ]]
}

# Get parent process name
# Usage: parent_process
# Returns: name of parent process
parent_process() {
    ps -p $PPID -o comm= 2>/dev/null || print "unknown"
}

# shell files tracking - keep at the end
zfile_track_end ${0:A}