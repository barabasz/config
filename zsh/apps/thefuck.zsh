#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# The Fuck integration

if is_installed thefuck; then
    fuck() {
        unfunction fuck
        eval $(thefuck --alias)
        fuck "$@"
    }
fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}