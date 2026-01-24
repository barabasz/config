#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start "$ZDOTDIR/.zshrc"

# History configuration
source "$ZINCDIR/history.zsh"

# Colors variables
source "$ZINCDIR/colors.zsh"

# Icons and glyphs
source "$ZINCDIR/icons.zsh"

# PROMPT fallback
source "$ZINCDIR/prompt.zsh"

# Editors and pager
source "$ZINCDIR/editors.zsh"

# Autoloaded functions
## Zsh functions
autoload -Uz zmv
autoload -Uz colors && colors
## User functions
# Prepend user function dir to fpath so they override system defaults
fpath=($ZFNCDIR $fpath)
# Autoload functions using Zsh style (-z)
# Pattern explanation:
#   [^_.]* : Match files not starting with underscore (completions) or dot
#   (N.:t) : Glob qualifiers
#      N   : Nullglob - prevent "no matches found" error if empty
#      .   : Regular files only (ignore directories)
#      :t  : Tail - extract filename only
autoload -Uz $ZFNCDIR/[^_.]*(N.:t)

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