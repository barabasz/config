#!/usr/bin/env zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Various helper functions

# Check if debug mode is enabled
is_debug() {
    [[ $ZSH_DEBUG == 1 || $DEBUG == 1 ]]
}

# Measure execution time of a command
etime() {
    local _etime_start=$EPOCHREALTIME
    "$@" > /dev/null
    printf "%.2fms\n" $(( (EPOCHREALTIME - _etime_start) * 1000 ))
}

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

# shell files tracking - keep at the end
zfile_track_end ${0:A}