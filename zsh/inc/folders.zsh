#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Folders
export TMP=$HOME/.tmp
export TEMP=$TMP
export TEMPDIR=$TMP
export TMPDIR=$TMP
export BINDIR=$HOME/bin
export LIBDIR=$HOME/lib
export DLDIR=$HOME/Downloads
export DOCDIR=$HOME/Documents
export CACHEDIR=$HOME/.cache
export VENVDIR=$HOME/.venv

# shell files tracking - keep at the end
zfile_track_end ${0:A}