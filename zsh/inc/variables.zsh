#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# History
export HISTFILE=$ZDOTDIR/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000

# Folders
export TMP=$HOME/.tmp
export TEMP=$TMP
export TEMPDIR=$TMP
export TMPDIR=$TMP
export BINDIR=$HOME/bin
export LIBDIR=$HOME/lib
export DLDIR=$HOME/Downloads
export DOCDIR=$HOME/Documents
export CACHEDIR=$HOME/.cache
export VENVDIR=$HOME/.venv

# Prompt fallback (will be override by oh-my-posh)
export PS1="[%F{cyan}%n%f@%F{green}%m%f:%F{yellow}%~%f]$ "

# Editors and pager
export EDITOR='nvim'
export VISUAL='code'
export PAGER='less'

# Log
export LOG_SHOW_ICONS=1 # log.sh: 1 for icons, 0 for nothing
export LOG_COLOR_TEXTS=1 # log.sh: 1 for colors, 0 for white
export LOG_EMOJI_ICONS=0 # log.sh: 1 for emoji, 0 for text

# Glyphs
export GLYPH_BELL="🔔"
export GLYPH_ERROR="❌"
export GLYPH_WARNING="⚠️"
export GLYPH_INFO="ℹ️"
export GLYPH_SUCCESS="✅"
export GLYPH_DEBUG="💬"
export GLYPH_NOTIFY="🔔"
export GLYPH_UL="•"

# ANSI color codes (interactive sessions only)
if [[ -o interactive ]]; then
    # basic colors
    export r=$'\033[0;31m'      # red
    export g=$'\033[0;32m'      # green
    export y=$'\033[0;33m'      # yellow
    export b=$'\033[0;34m'      # blue
    export p=$'\033[0;35m'      # purple
    export c=$'\033[0;36m'      # cyan
    export w=$'\033[0;37m'      # white
    # bright colors
    export br=$'\033[0;91m'     # bright red
    export bg=$'\033[0;92m'     # bright green
    export by=$'\033[0;93m'     # bright yellow
    export bb=$'\033[0;94m'     # bright blue
    export bp=$'\033[0;95m'     # bright purple
    export bc=$'\033[0;96m'     # bright cyan
    export bw=$'\033[0;97m'     # bright white
    # reset
    export x=$'\033[0m'
fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}