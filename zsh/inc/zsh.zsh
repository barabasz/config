#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

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
export ZSH_CONFIG_VERSION="20260111v3"

# shell files tracking - keep at the end
zfile_track_end ${0:A}