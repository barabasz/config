#!/bin/zsh

# zsh configuration version
export ZSH_CONFIG_VERSION="20251226v1"

# zsh configuration directory
export ZDOTDIR=$HOME/.config/zsh

# shell files counter
export ZFILES_COUNT=0

# load environment variables
source $ZDOTDIR/.zvars

# brew early load to have it available for functions in _all.sh
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# load functions
# to recreate new _all.sh from $LIBDIR, run `relib`
source $LIBDIR/_all.sh

# locale
sourceif $ZDOTDIR/.zlocale $thisfile

# shell files tracking - keep at the end
ZFILES_COUNT=$((ZFILES_COUNT + 1))
export ZFILE_ENV=1
