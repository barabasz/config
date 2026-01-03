#!/bin/zsh
this_file=${0:A:t}

# Autoloaded functions
## Zsh functions
autoload -Uz zmv
autoload -Uz colors && colors
## User functions
fpath=($ZDOTDIR/functions $fpath)
autoload -Uz $ZDOTDIR/functions/[^_.]*(.:t)

# Aliases
source $ZALIASES

# Dir 
source $ZDIRSFILE
try_source $ZINCDIR/zsh_dirs.zsh $this_file

# App configurations
source $ZAPPCONF

# Interactive cleanup
source $ZFNCDIR/zcleanup

# shell files tracking - keep at the end
ZFILES[$this_file]=1
