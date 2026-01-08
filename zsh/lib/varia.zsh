#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Miscellaneous helper functions & metaprogramming utilities
# Depends on: print.zsh (for output), bootstrap.zsh (for colors)

# Check if debug mode is enabled
# Usage: is_debug
# Returns: 0 (true) or 1 (false)
is_debug() {
    [[ $ZSH_DEBUG == 1 || $DEBUG == 1 ]]
}

# Measure execution time of a command
# Usage: etime ls -la
# Returns: prints time in ms to stdout
etime() {
    local start=$EPOCHREALTIME
    "$@" > /dev/null
    
    # Calculate duration
    local duration=$(( (EPOCHREALTIME - start) * 1000 ))
    local formatted
    # Format to 2 decimal places using printf -v (save to variable)
    printf -v formatted "%.2f" $duration
    
    printi "Execution time: ${formatted}ms"
}

# Check if command(s) are installed/available
# Usage: is_installed git [curl ...]
# Returns: 0 if all commands exist, 1 otherwise
is_installed() {
    # Fast path for single argument
    if [[ $# -eq 1 ]]; then
        (( ${+commands[$1]} ))
        return
    fi

    # Loop for multiple arguments
    local cmd
    for cmd in "$@"; do
        (( ${+commands[$cmd]} )) || return 1
    done
    return 0
}

# Source file if it exists, with optional debug logging
# Usage: try_source "/path/to/file.zsh" ["ContextName"]
# Returns: exit code from source, or 1 if file doesn't exist
try_source() {
    [[ $# -ge 1 ]] || return 1
    local file="$1"
    local context="${2:-System}"

    if [[ -r "$file" ]]; then
        source "$file"
        local ret=$?
        if (( ret != 0 )) && is_debug; then
            printe "[$context] Failed to source '$file' (exit code: $ret)"
        fi
        return $ret
    else
        # Only warn if debug is enabled, using printw
        is_debug && printw "[$context] Missing file '$file'"
        return 1
    fi
}

# Create a backup of a file with timestamp
# Usage: backup_file "config.txt"
# Returns: 0 on success (creates config.txt.20240101_120000)
backup_file() {
    [[ -f "$1" ]] || return 1
    local ts
    zmodload zsh/datetime
    strftime -s ts "%Y%m%d_%H%M%S" $EPOCHSECONDS
    
    if cp -a "$1" "${1}.${ts}"; then
        prints "Backup created: ${1}.${ts}"
        return 0
    else
        printe "Failed to create backup of '$1'"
        return 1
    fi
}

# Ask for confirmation (Y/n)
# Usage: confirm "Delete file?" && rm file
# Returns: 0 (yes) or 1 (no)
confirm() {
    # Use yellow color ($y) for question to match printq style
    local prompt_text="${1:-Are you sure?}"
    local prompt="${y}${prompt_text} [y/N]${x} "
    local response
    
    read -q "response?${prompt}" # -q reads single char without enter
    print "" # Print newline after single char input
    
    # Check if response is y or Y
    [[ "$response" == [yY] ]]
}

# shell files tracking - keep at the end
zfile_track_end ${0:A}