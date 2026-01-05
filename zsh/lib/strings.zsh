#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Extract version number from a string
get_version() {
    local input=$1
    
    if [[ $input =~ '[0-9]+\.[0-9]+(\.[0-9]+)*' ]]; then
        print $MATCH
        return 0
    fi
    return 1
}

# shell files tracking - keep at the end
zfile_track_end ${0:A}