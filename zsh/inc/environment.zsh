#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# ZSH
## directories
export ZCACHEDIR=$ZDOTDIR/cache
export SHELL_SESSION_DIR="$ZCACHEDIR/sessions"
export ZINCDIR=$ZDOTDIR/inc
export ZLIBDIR=$ZDOTDIR/lib
export ZAPPDIR=$ZDOTDIR/apps
export ZFNCDIR=$ZDOTDIR/functions
## history
export HISTFILE=$ZDOTDIR/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000

# FOLDERS
## XDG base directories
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.local/cache}
export XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-$HOME/.xdg}
## XDG user directories
export XDG_DESKTOP_DIR=${XDG_DESKTOP_DIR:-$HOME/Desktop}
export XDG_DOCUMENTS_DIR=${XDG_DOCUMENTS_DIR:-$HOME/Documents}
export XDG_DOWNLOAD_DIR=${XDG_DOWNLOAD_DIR:-$HOME/Downloads}
export XDG_MUSIC_DIR=${XDG_MUSIC_DIR:-$HOME/Music}
export XDG_PICTURES_DIR=${XDG_PICTURES_DIR:-$HOME/Pictures}
export XDG_PROJECTS_DIR=${XDG_PROJECTS_DIR:-$HOME/Projects}
export XDG_VIDEOS_DIR=${XDG_VIDEOS_DIR:-$HOME/Videos}
## Temp
export TMP=$HOME/.tmp && mkdir -p $TMP
export TEMP=$TMP
export TEMPDIR=$TMP
export TMPDIR=$TMP
## GitHub
export GHDIR=$HOME/GitHub
export GHBINDIR=$GHDIR/bin
export GHLIBDIR=$GHDIR/lib
export GHCONFDIR=$GHDIR/config
export GHPRIVDIR=$GHDIR/priv
## Other
export BINDIR=$HOME/bin
export LIBDIR=$HOME/lib
export CONFDIR=$HOME/.config
export DLDIR=$HOME/Downloads
export DOCDIR=$HOME/Documents
export CACHEDIR=$HOME/.cache
export VENVDIR=$HOME/.venv

# Directories shortcuts (named directories)
hash -d bin=$BINDIR
hash -d conf=$CONFDIR
hash -d dl=$DLDIR
hash -d doc=$DOCDIR
hash -d gh=$GHDIR
hash -d lib=$LIBDIR
hash -d tmp=$TMP
hash -d venv=$VENVDIR
hash -d zsh=$ZDOTDIR

# PATH
# user scripts and binaries
export PATH=$BINDIR:$BINDIR/common:$BINDIR/install:$BINDIR/test:$BINDIR/thisos:/usr/local/bin:$HOME/.local/bin:$PATH

# PROMPT fallback (will be override by oh-my-posh)
export PS1="[%F{cyan}%n%f@%F{green}%m%f:%F{yellow}%~%f]$ "

# EDITORS
export EDITOR='nvim'
export VISUAL='code'

# VARIA
export MYGH='https://raw.githubusercontent.com/barabasz'

# LOG
export LOG_SHOW_ICONS=1 # log.sh: 1 for icons, 0 for nothing
export LOG_COLOR_TEXTS=1 # log.sh: 1 for colors, 0 for white
export LOG_EMOJI_ICONS=0 # log.sh: 1 for emoji, 0 for text

# Get the colors in the opened man page itself
export MANPAGER="sh -c 'col -bx | bat -l man -p --paging always'"

# shell files tracking - keep at the end
zfile_track_end ${0:A}