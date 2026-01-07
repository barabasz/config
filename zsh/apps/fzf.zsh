#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# fzf (fuzzy finder) integration

# Guard
is_installed fzf || return

source <(fzf --zsh)

# shell files tracking - keep at the end
zfile_track_end ${0:A}