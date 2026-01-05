#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# bat (cat clone) integration

if is_installed bat; then
    export BAT_CONFIG_DIR="$CONFDIR/bat"
fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}