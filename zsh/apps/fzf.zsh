#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# fzf (fuzzy finder) integration

if is_installed fzf; then
    source <(fzf --zsh)
fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}