#!/bin/zsh

# INTEGRATIONS

## oh-my-zsh
if [[ -f $ZSH/oh-my-zsh.sh ]]; then
    sourceif $ZDOTDIR/assets/.zsh_omz $thisfile
fi

## oh-my-posh
if [[ $(isinstalled oh-my-posh) == 1 ]]; then
    sourceif $ZDOTDIR/assets/.zsh_omp $thisfile
fi

## bat (cat clone)
if [[ $(isinstalled bat) == 1 ]]; then
    sourceif $ZDOTDIR/assets/.zsh_bat $thisfile
fi

## brew (package manager)
if [[ $(isinstalled brew) == 1 ]]; then
    sourceif $ZDOTDIR/assets/.zsh_brew $thisfile
fi

## fzf (fuzzy finder)
if [[ $(isinstalled fzf) == 1 ]]; then
    sourceif $ZDOTDIR/assets/.zsh_fzf $thisfile
fi

## thefuck (corrects previous command)
if [[ $(isinstalled thefuck) == 1 ]]; then
    sourceif $ZDOTDIR/assets/.zsh_thefuck $thisfile
fi

## python virtual environment
if [[ $(isinstalled python3) == 1 ]]; then
    sourceif $ZDOTDIR/assets/.zsh_python $thisfile
fi

## yazi file manager
if [[ $(isinstalled yazi) == 1 ]]; then
    sourceif $ZDOTDIR/assets/.zsh_yazi $thisfile
fi

## zoxide (cd replacement)
if [[ $(isinstalled zoxide) == 1 ]]; then
    sourceif $ZDOTDIR/assets/.zsh_zoxide $thisfile
fi

# ALIASES

sourceif $ZDOTDIR/.zaliases $thisfile

# DIR HASHES

sourceif $ZDOTDIR/.zdirs $thisfile

# CLEANUP

# https://bit.ly/zsh_sessions
if [[ -d $ZDOTDIR/.zsh_sessions ]]; then
    rm -rf $ZDOTDIR/.zsh_sessions > /dev/null 2>&1
fi

# shell files tracking - keep at the end
ZFILES_COUNT=$((ZFILES_COUNT + 1))
export ZFILE_RC=1
