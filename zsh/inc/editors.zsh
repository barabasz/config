#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Editors and pager
# Optimization: Unconditional export is faster than checking existence.
# If the tool is missing, using $EDITOR will simply error out, which is expected behavior.

export EDITOR='nvim'
export VISUAL='code'
export PAGER='less'

# shell files tracking - keep at the end
zfile_track_end ${0:A}