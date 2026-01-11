#!/bin/zsh
export ZSH_CONFIG_VERSION="20260111v2"

# Zsh core configuration
export CONFDIR=$HOME/.config
export ZDOTDIR=$CONFDIR/zsh
export ZCACHEDIR=$ZDOTDIR/cache
export SHELL_SESSION_DIR="$ZCACHEDIR/sessions"
export ZINCDIR=$ZDOTDIR/inc
export ZLIBDIR=$ZDOTDIR/lib
export ZAPPDIR=$ZDOTDIR/apps
export ZFNCDIR=$ZDOTDIR/functions
export ZSH_DEBUG=1       # set to 1 to enable zsh debug messages
export ZSH_ZFILE_DEBUG=0 # set to 1 to enable zfile sourcing debug messages
export ZSH_LOGIN_INFO=0  # set to 1 to print login info messages
export ZSH_SYS_INFO=0    # set to 1 to print system info messages

# Shell files tracking
source "$ZINCDIR/zfiles.zsh"
zfile_track_start ${0:A}

# Load zshenv bootstrap functions
source "$ZINCDIR/bootstrap.zsh"

# Load XDG directories
source "$ZINCDIR/xdg.zsh"

# Load user folders
source "$ZINCDIR/folders.zsh"

# Load environment variables
source "$ZINCDIR/variables.zsh"

# Interactive session only
if [[ -o interactive ]]; then
    # Load colors
    source "$ZINCDIR/colors.zsh"

    # Load icons
    source "$ZINCDIR/icons.zsh"

    # Load PROMPT fallback
    source "$ZINCDIR/prompt.zsh"
fi

# Load helper library
source_zsh_dir "$ZLIBDIR"

# Load PATH
source "$ZINCDIR/path.zsh"

# Set locale
source "$ZINCDIR/locales.zsh"

# Shell files tracking - keep at the end
zfile_track_end ${0:A}