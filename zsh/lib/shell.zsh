#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Get shell version
function shell_ver() {
    print $(get_version "$(zsh --version 2>&1)")
}

# shell files tracking - keep at the end
zfile_track_end ${0:A}