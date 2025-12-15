#!/bin/zsh

# zsh configuration directory
export ZDOTDIR=$HOME/.config/zsh
# shell files counter
export ZFILES_COUNT=0

# load environment variables
source $ZDOTDIR/.zvars

# load functions
for f in "$LIBDIR"/*.sh; do
    [[ -f "$f" && ! "$(basename "$f")" =~ ^_ ]] && source "$f"
done

# locale
sourceif $ZDOTDIR/.zlocale $thisfile

# brew
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# shell files tracking - keep at the end
ZFILES_COUNT=$((ZFILES_COUNT + 1))
export ZFILE_ENV=1
