#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# ANSI basic color codes
r=$'\033[0;31m'      # Red
g=$'\033[0;32m'      # Green
y=$'\033[0;33m'      # Yellow
b=$'\033[0;34m'      # Blue
p=$'\033[0;35m'      # Purple
c=$'\033[0;36m'      # Cyan
w=$'\033[0;37m'      # White
x=$'\033[0m'         # Reset

# Check if debug mode is enabled
is_debug() {
    [[ $ZSH_DEBUG == 1 || $DEBUG == 1 ]]
}

# Source all .zsh files in a directory
source_zsh_dir() {
    local f
    for f in $1/*.zsh(N); do
        source "$f"
    done
}

# Print source time for a file
source_time() {
    file_path=$1
    file_time="$ZFILES_TIME[$1]"
    file_name=${file_path:t}
    printf "✅ %s sourced in %.2f ms\n" "$file_name" "$file_time"
}

# shell files tracking - keep at the end
zfile_track_end ${0:A}