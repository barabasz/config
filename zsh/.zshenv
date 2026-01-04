#!/bin/zsh
this_file=${0:A:t}

# Shell files tracking - keep at the top
typeset -A ZFILES
ZFILES[.zshenv]=0

# Zsh configuration directory
export ZDOTDIR=$HOME/.config/zsh

# Load environment variables
source "$ZDOTDIR/inc/environment.zsh"

# Load helper library
if [[ -f "$ZHELPERS" ]]; then
    # Use compiled version if available
    source "$ZHELPERS"
else
    # Fallback: source individual files
    for lib_file in $ZLIBDIR/*.zsh(N); do
        source "$lib_file"
    done
    unset lib_file
fi

# Set locale
try_source $ZINCDIR/locales.zsh $this_file

# Shell files tracking - keep at the end
ZFILES[.zshenv]=1