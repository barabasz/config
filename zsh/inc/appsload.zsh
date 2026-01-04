#!/usr/bin/env zsh
this_file=$(basename "${0:A}")

## ACME Shell script: acme.sh
if is_dir "$HOME/.acme.sh"; then
    . "$HOME/.acme.sh/acme.sh.env"
fi

## oh-my-zsh
if is_file "$ZSH/oh-my-zsh.sh"; then
    try_source $ZAPPDIR/omz.zsh $this_file
fi

## oh-my-posh
if is_installed oh-my-posh; then
    try_source $ZAPPDIR/omp.zsh $this_file
fi

## bat (cat clone)
if is_installed bat; then
    try_source $ZAPPDIR/bat.zsh $this_file
fi

## brew (package manager)
# loaded in .zprofile for login shells

## fzf (fuzzy finder)
if is_installed fzf; then
    try_source $ZAPPDIR/fzf.zsh $this_file
fi

## thefuck (corrects previous command)
if is_installed thefuck; then
    try_source $ZAPPDIR/thefuck.zsh $this_file
fi

## python virtual environment
if is_installed python3; then
    try_source $ZAPPDIR/python.zsh $this_file
fi

## rust (programming language)
if is_file "$HOME/.cargo/env"; then
    source "$HOME/.cargo/env"
fi

## yazi file manager
if is_installed yazi; then
    try_source $ZAPPDIR/yazi.zsh $this_file
fi

## zoxide (cd replacement)
if is_installed zoxide; then
    try_source $ZAPPDIR/zoxide.zsh $this_file
fi

# Shell files tracking - keep at the end
ZFILES[$this_file]=1