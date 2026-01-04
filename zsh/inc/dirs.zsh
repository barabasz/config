#!/bin/zsh
this_file=${0:A:t}

# Directories shortcuts (named directories)

hash -d bin=$BINDIR
hash -d conf=$CONFDIR
hash -d dl=$DLDIR
hash -d doc=$DOCDIR
hash -d gh=$GHDIR
hash -d lib=$LIBDIR
hash -d tmp=$TMP
hash -d venv=$VENVDIR
hash -d zsh=$ZDOTDIR

# shell files tracking - keep at the end
ZFILES[$this_file]=1