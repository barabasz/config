#!/usr/bin/env zsh

## Zsh functions
autoload -Uz zmv
autoload -Uz colors && colors

## User functions
fpath=($ZDOTDIR/functions $fpath)
autoload -Uz $ZDOTDIR/functions/[^_.]*(.:t)
