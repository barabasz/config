#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Prompt fallback (will be override by oh-my-posh)
export PS1="[%F{cyan}%n%f@%F{green}%m%f:%F{yellow}%~%f]$ "

# shell files tracking - keep at the end
zfile_track_end ${0:A}