#!/bin/zsh
this_file=${0:A:t}

# Shell files tracking - keep at the top
typeset -A ZFILES
ZFILES[.zshenv]=0

# Zsh configuration directory
export ZDOTDIR=$HOME/.config/zsh

# Load environment variables
source "$ZDOTDIR/environment.zsh"

# Load helper library
if [[ -f "$ZLIBFILE" ]]; then
    # Use compiled version if available
    source "$ZLIBFILE"
else
    # Fallback: source individual files
    for lib_file in $ZLIBDIR/*.zsh(N); do
        source "$lib_file"
    done
    unset lib_file
fi

# Homebrew early load
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Set locale
source $ZLOCALEFILE

# Shell files tracking - keep at the end
ZFILES[.zshenv]=1