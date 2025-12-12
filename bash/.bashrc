#!/bin/bash

export ZDOTDIR=$HOME/.config/zsh
export HISTFILE=$ZDOTDIR/.zsh_history
export HISTSIZE=1000
export HISTFILESIZE=1000
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-$HOME/.xdg}
export XDG_PROJECTS_DIR=${XDG_PROJECTS_DIR:-$HOME/Projects}
export BINDIR=$HOME/bin
export GHDIR=$HOME/GitHub
export GHBINDIR=$GHDIR/bin
export GHCONFDIR=$GHDIR/config
export CONFDIR=$XDG_CONFIG_HOME
export PATH=$HOME/bin:$HOME/bin/install:$HOME/bin/test:$HOME/binos:/usr/local/bin:$PATH
export PS1="[\[\033[36m\]\u\[\033[37m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]]$ "
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_EMOJI=1
. "$HOME/.cargo/env"
