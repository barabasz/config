#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Editors and pager
export EDITOR='nvim'
export VISUAL='code'
export PAGER='less'

# Log
export LOG_SHOW_ICONS=1  # log.sh: 1 for icons, 0 for nothing
export LOG_COLOR_TEXTS=1 # log.sh: 1 for colors, 0 for white
export LOG_EMOJI_ICONS=0 # log.sh: 1 for emoji, 0 for text

# Execs
export EXECS_SPINNER_FRAMES=('⣷' '⣯' '⣟' '⡿' '⢿' '⣻' '⣽' '⣾')
export EXECS_SPINNER_DELAY=0.10

# shell files tracking - keep at the end
zfile_track_end ${0:A}