#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# zoxide shell integration

if is_installed zoxide; then
    eval "$(zoxide init zsh)"
fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}