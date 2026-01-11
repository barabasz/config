#!/bin/zsh
export ZSH_CONFIG_VERSION="20260111v1"

# Zsh core configuration
export CONFDIR=$HOME/.config
export ZDOTDIR=$CONFDIR/zsh
export ZCACHEDIR=$ZDOTDIR/cache
export SHELL_SESSION_DIR="$ZCACHEDIR/sessions"
export ZINCDIR=$ZDOTDIR/inc
export ZLIBDIR=$ZDOTDIR/lib
export ZAPPDIR=$ZDOTDIR/apps
export ZFNCDIR=$ZDOTDIR/functions
export ZSH_DEBUG=1
export ZSH_ZFILE_DEBUG=0 # set to 1 to enable zfile sourcing debug messages
export ZSH_LOGIN_INFO=0  # set to 1 to print login info messages
export ZSH_SYS_INFO=0    # set to 1 to print system info messages

# Shell files tracking
source "$ZINCDIR/zfiles.zsh"
zfile_track_start ${0:A}
this_file=${0:t}

# Load XDG directories
source "$ZINCDIR/xdg.zsh"

# Load environment variables
source "$ZINCDIR/variables.zsh"

# Load bootstrap functions
source "$ZINCDIR/bootstrap.zsh"
# From this point on we have source_zsh_dir etc.

# Load helper library
source_zsh_dir "$ZLIBDIR"
# From this point on we have try_source etc.

# Load PATH
try_source "$ZINCDIR/path.zsh" $this_file

# Set locale
try_source "$ZINCDIR/locales.zsh" $this_file

# Shell files tracking - keep at the end
zfile_track_end ${0:A}