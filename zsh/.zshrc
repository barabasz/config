#!/bin/zsh

# Aliases
source $ZDOTDIR/.zaliases

# Autoloaded functions
source $ZDOTDIR/.zautoload

# Dir 
source $ZDOTDIR/.zdirs

# Assets (integrations)
source $ZDOTDIR/.zassets

# CLEANUP

# Unset variables
unset d # set by zsh
unset thisfile

# Clear zsh_sessions
if [[ -d $ZDOTDIR/.zsh_sessions ]]; then
    rm -rf $ZDOTDIR/.zsh_sessions > /dev/null 2>&1
fi

# shell files tracking - keep at the end
ZFILES_COUNT=$((ZFILES_COUNT + 1))
export ZFILE_RC=1
