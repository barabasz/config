#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# python virtual environment

# Guard
is_installed python3 || return

[[ ! -d "$VENVDIR/python" ]] && mkdir -p "$VENVDIR/python"
export PATH=$VENVDIR/python/bin:$PATH
[[ -e $VENVDIR/python/bin/activate ]] && source $VENVDIR/python/bin/activate

# shell files tracking - keep at the end
zfile_track_end ${0:A}