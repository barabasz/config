#!/bin/zsh

# Zsh configuration version
export ZSH_CONFIG_VERSION="20260103v1"

# Zsh configuration directory
export ZDOTDIR=$HOME/.config/zsh

# Shell files counter
export ZFILES_COUNT=0

# Load environment variables
source $ZDOTDIR/.zvars

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
sourceif $ZDOTDIR/.zlocale $thisfile

# Shell files tracking - keep at the end
ZFILES_COUNT=$((ZFILES_COUNT + 1))
export ZFILE_ENV=1
