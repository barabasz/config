#!/usr/bin/env zsh
#
# Various helper functions

# Check if command(s) are installed
# Usage: is_installed cmd1 [cmd2 ...]
# Returns: 0 if all commands exist, 1 otherwise
is_installed() {
    [[ $# -ge 1 ]] || return 1
    
    local cmd
    for cmd in "$@"; do
        (( ${+commands[$cmd]} )) || return 1
    done
    
    return 0
}

# Source file if it exists, log errors when ZSH_DEBUG=1
# Usage: try_source file [caller]
# Returns: exit code from source, or 1 if file doesn't exist
try_source() {
    [[ $# -ge 1 ]] || return 1
    
    if [[ -f "$1" ]]; then
        if source "$1"; then
            return 0
        else
            local exit_code=$?
            if [[ "$ZSH_DEBUG" == "1" ]]; then
                if [[ -n "$2" ]]; then
                    print "Error: $2 failed to source $1 (exit code: $exit_code)" >&2
                else
                    print "Error: failed to source $1 (exit code: $exit_code)" >&2
                fi
            fi
            return $exit_code
        fi
    else
        if [[ "$ZSH_DEBUG" == "1" ]]; then
            if [[ -n "$2" ]]; then
                print "Warning: $2 tried to source missing file: $1" >&2
            else
                print "Warning: tried to source missing file: $1" >&2
            fi
        fi
        return 1
    fi
}