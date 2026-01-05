#!/bin/zsh

# Shell files tracking infrastructure
zmodload zsh/datetime
typeset -A ZFILES
typeset -A ZFILES_TIME
typeset -A ZFILES_START
typeset -a ZFILES_ORDER

zfile_track_start() {
    local filepath=$1
    this_file=${filepath:t}
    ZFILES[$filepath]=0
    ZFILES_ORDER+=($filepath)
    ZFILES_START[$filepath]=$EPOCHREALTIME
}

zfile_track_end() {
    local filepath=$1
    ZFILES[$filepath]=1
    ZFILES_TIME[$filepath]=$(( (EPOCHREALTIME - ZFILES_START[$filepath]) * 1000 ))
    (( ZSH_DEBUG == 1 )) && printf "✅ %s sourced in %.2fms\n" ${filepath:t} $ZFILES_TIME[$filepath]
}

# Track this file
zfile_track_start ${0:A}
this_file=${0:t}

# Zsh core configuration
export ZDOTDIR=$HOME/.config/zsh
export ZSH_CONFIG_VERSION="20260104v4"
export ZSH_DEBUG=0
export ZSH_LOGIN_INFO=0

# Load environment variables
source "$ZDOTDIR/inc/environment.zsh"

# Load bootstrap functions
source "$ZINCDIR/bootstrap.zsh"

# Load helper library
source_zsh_dir "$ZLIBDIR"

# Set locale
try_source $ZINCDIR/locales.zsh $this_file

# Shell files tracking - keep at the end
zfile_track_end ${0:A}