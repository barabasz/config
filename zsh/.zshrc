#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start "$ZDOTDIR/.zshrc"

# Autoloaded functions
## Zsh functions
autoload -Uz zmv
autoload -Uz colors && colors
## User functions
fpath=($ZFNCDIR $fpath)
autoload -Uz $ZFNCDIR/[^_.]*(.:t)

# Aliases
source $ZINCDIR/aliases.zsh

# App configurations
source_zsh_dir "$ZAPPDIR"

# Directory hashes
source "$ZINCDIR/hashdirs.zsh"

# shell files tracking - keep at the end
zfile_track_end "$ZDOTDIR/.zshrc"

# Ensure successful sourcing
true