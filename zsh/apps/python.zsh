#!/bin/zsh

[[ ! -d "$VENVDIR/python" ]] && mkdir -p "$VENVDIR/python"
export PATH=$VENVDIR/python/bin:$PATH
[[ -e $VENVDIR/python/bin/activate ]] && source $VENVDIR/python/bin/activate
