#!/usr/bin/env zsh
this_file=$(basename "${0:A}")

## Zsh functions
autoload -Uz zmv
autoload -Uz colors && colors

## User functions
fpath=($ZDOTDIR/functions $fpath)
autoload -Uz $ZDOTDIR/functions/[^_.]*(.:t)

## Zsh modules
zmodload zsh/datetime

# shell files tracking - keep at the end
ZFILES[$this_file]=1