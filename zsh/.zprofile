#!/bin/zsh
this_file=${0:A:t}

try_source $ZAPPDIR/brew.zsh $this_file

# shell files tracking - keep at the end
ZFILES_COUNT=$((ZFILES_COUNT + 1))
export ZFILE_PROFILE=1
