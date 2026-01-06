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