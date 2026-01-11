#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# History
export HISTFILE=$ZDOTDIR/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000

# Editors and pager
export EDITOR='nvim'
export VISUAL='code'
export PAGER='less'

# Log
export LOG_SHOW_ICONS=1  # log.sh: 1 for icons, 0 for nothing
export LOG_COLOR_TEXTS=1 # log.sh: 1 for colors, 0 for white
export LOG_EMOJI_ICONS=0 # log.sh: 1 for emoji, 0 for text

# shell files tracking - keep at the end
zfile_track_end ${0:A}