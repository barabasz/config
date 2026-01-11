#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Check if debug mode is enabled
is_debug() {
    [[ $ZSH_DEBUG == 1 || $DEBUG == 1 ]]
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
