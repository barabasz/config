#!/bin/zsh
this_file=${0:A:t}

# Autoloaded functions
try_source $ZINCDIR/autoload.zsh $this_file

# Aliases
try_source $ZINCDIR/aliases.zsh $this_file

# Directory hashing
try_source $ZINCDIR/dirs.zsh $this_file

# App configurations
try_source $ZINCDIR/appsload.zsh $this_file

# shell files tracking - keep at the end
ZFILES[$this_file]=1


