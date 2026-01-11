#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Check if debug mode is enabled
is_debug() {
    [[ $ZSH_DEBUG == 1 || $DEBUG == 1 ]]
}

# Source file that must exist, with error on failure
# Usage: require_source "/path/to/file.zsh" ["ContextName"]
# Returns: exit code from source, or 1 if file doesn't exist
# Note: Unlike try_source, this always reports missing files (not debug-only)
require_source() {
    [[ $# -ge 1 ]] || return 1
    local file="$1"
    
    # Auto-detect caller file if context not provided
    local context="${2:-}"
    if [[ -z "$context" ]]; then
        # Extract filename from funcfiletrace (format: "filepath:line")
        local caller_file="${funcfiletrace[1]%%:*}"
        context="${caller_file:t}"
    fi

    if [[ -r "$file" ]]; then
        source "$file"
        local ret=$?
        if (( ret != 0 )); then
            print -u2 "ERROR [$context]: Failed to source required file '$file' (exit code: $ret)"
        fi
        return $ret
    else
        print -u2 "ERROR [$context]: Required file missing: '$file'"
        return 1
    fi
}

# Source file if it exists, with optional debug logging
# Usage: try_source "/path/to/file.zsh" ["ContextName"]
# Returns: exit code from source, or 1 if file doesn't exist
try_source() {
    [[ $# -ge 1 ]] || return 1
    local file="$1"
    
    # Auto-detect caller file if context not provided
    local context="${2:-}"
    if [[ -z "$context" ]]; then
        # Extract filename from funcfiletrace (format: "filepath:line")
        local caller_file="${funcfiletrace[1]%%:*}"
        context="${caller_file:t}"
    fi

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

# Source all .zsh files in a directory
# Usage: source_zsh_dir "/path/to/dir"
# Returns: none
source_zsh_dir() {
    local f
    for f in $1/*.zsh(N); do
        source "$f"
    done
}

# shell files tracking - keep at the end
zfile_track_end ${0:A}
