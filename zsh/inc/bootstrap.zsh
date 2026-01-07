#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# ANSI color codes (interactive sessions only)
if [[ -o interactive ]]; then
    # basic colors
    r=$'\033[0;31m'      # red
    g=$'\033[0;32m'      # green
    y=$'\033[0;33m'      # yellow
    b=$'\033[0;34m'      # blue
    p=$'\033[0;35m'      # purple
    c=$'\033[0;36m'      # cyan
    w=$'\033[0;37m'      # white
    # bright colors
    br=$'\033[0;91m'     # bright red
    bg=$'\033[0;92m'     # bright green
    by=$'\033[0;93m'     # bright yellow
    bb=$'\033[0;94m'     # bright blue
    bp=$'\033[0;95m'     # bright purple
    bc=$'\033[0;96m'     # bright cyan
    bw=$'\033[0;97m'     # bright white
    # reset
    x=$'\033[0m'
fi

# Glyphs for various message types
# Using GLYPH_ prefix for better autocomplete and namespacing
GLYPH_ERROR="❌"
GLYPH_WARNING="⚠️"
GLYPH_INFO="ℹ️"
GLYPH_SUCCESS="✅"
GLYPH_DEBUG="💬"
GLYPH_NOTIFY="🔔"

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
    local file_path=$1
    local file_time=$ZFILES_TIME[$1]
    local file_name=${file_path:t}
    printf "✅ %s sourced in %.2f ms\n" "$file_name" "$file_time"
}

# shell files tracking - keep at the end
zfile_track_end ${0:A}
