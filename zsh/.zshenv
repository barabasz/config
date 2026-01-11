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

source abcdefghijk
require_source abcdefghijk

# Load XDG directories
try_source "$ZINCDIR/xdg.zsh" $this_file

# Load user folders
try_source "$ZINCDIR/folders.zsh" $this_file

# Load environment variables
try_source "$ZINCDIR/variables.zsh" $this_file

# Interactive session only
if [[ -o interactive ]]; then
    # Load colors
    try_source "$ZINCDIR/colors.zsh" $this_file

    # Load icons
    try_source "$ZINCDIR/icons.zsh" $this_file

    # Load PROMPT fallback
    try_source "$ZINCDIR/prompt.zsh" $this_file
fi

# Load helper library
source_zsh_dir "$ZLIBDIR"

# Load PATH
try_source "$ZINCDIR/path.zsh" $this_file

# Set locale
try_source "$ZINCDIR/locales.zsh" $this_file

# Shell files tracking - keep at the end
zfile_track_end ${0:A}