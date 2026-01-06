#!/bin/zsh
export ZSH_CONFIG_VERSION="20260106v1"

# Zsh core configuration
export CONFDIR=$HOME/.config
export ZDOTDIR=$CONFDIR/zsh
export ZCACHEDIR=$ZDOTDIR/cache
export SHELL_SESSION_DIR="$ZCACHEDIR/sessions"
export ZINCDIR=$ZDOTDIR/inc
export ZLIBDIR=$ZDOTDIR/lib
export ZAPPDIR=$ZDOTDIR/apps
export ZFNCDIR=$ZDOTDIR/functions
export ZSH_DEBUG=0
export ZSH_LOGIN_INFO=1
export ZSH_SYS_INFO=0

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

# Load helper library
source_zsh_dir "$ZLIBDIR"

# Load PATH
try_source "$ZINCDIR/path.zsh" $this_file

# Set locale
try_source $ZINCDIR/locales.zsh $this_file

# Shell files tracking - keep at the end
zfile_track_end ${0:A}