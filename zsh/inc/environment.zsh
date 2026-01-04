#!/bin/zsh
this_file=${0:A:t}

# XDG
## Base directories
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.local/cache}
export XDG_BIN_HOME=${XDG_BIN_HOME:-$HOME/.local/bin}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-$HOME/.xdg}
## User directories
export XDG_DESKTOP_DIR=${XDG_DESKTOP_DIR:-$HOME/Desktop}
export XDG_DOCUMENTS_DIR=${XDG_DOCUMENTS_DIR:-$HOME/Documents}
export XDG_DOWNLOAD_DIR=${XDG_DOWNLOAD_DIR:-$HOME/Downloads}
export XDG_MUSIC_DIR=${XDG_MUSIC_DIR:-$HOME/Music}
export XDG_PICTURES_DIR=${XDG_PICTURES_DIR:-$HOME/Pictures}
export XDG_PROJECTS_DIR=${XDG_PROJECTS_DIR:-$HOME/Projects}
export XDG_VIDEOS_DIR=${XDG_VIDEOS_DIR:-$HOME/Videos}

# ZSH
# Zsh configuration version
export ZSH_CONFIG_VERSION="20260104v1"
export ZSH_DEBUG=1
export ZSH_LOGIN_INFO=0
## directories
export ZCACHEDIR=$ZDOTDIR/cache
export SHELL_SESSION_DIR="$ZCACHEDIR/sessions"
export ZINCDIR=$ZDOTDIR/inc
export ZLIBDIR=$ZDOTDIR/lib
export ZAPPDIR=$ZDOTDIR/apps
export ZFNCDIR=$ZDOTDIR/functions
## inc config files
export ZHELPERS=$ZLIBDIR/.compiled.zsh

# history
export HISTFILE=$ZDOTDIR/.zsh_history
export HISTSIZE=1000



## Temp
export TMP=$HOME/.tmp
[[ ! -d $TMP ]] && mkdir -p $TMP
export TEMP=$TMP
export TEMPDIR=$TMP
export TMPDIR=$TMP
## GitHub
export GHDIR=$HOME/GitHub
export GHBINDIR=$GHDIR/bin
export GHLIBDIR=$GHDIR/lib
export GHCONFDIR=$GHDIR/config
export GHPRIVDIR=$GHDIR/priv
### SSH
export SSH_HOME=~/.config/ssh
export SSH_AUTH_SOCK="$SSH_HOME/ssh_auth.sock"
## Other
export BINDIR=$HOME/bin
export LIBDIR=$HOME/lib
export CONFDIR=$HOME/.config
export DLDIR=$HOME/Downloads
export DOCDIR=$HOME/Documents
export CACHEDIR=$HOME/.cache
export VENVDIR=$HOME/.venv





# PATH
# user scripts and binaries
export PATH=$BINDIR:$BINDIR/common:$BINDIR/install:$BINDIR/test:$BINDIR/thisos:/usr/local/bin:$HOME/.local/bin:$PATH

# PROMPT fallback (will be override by oh-my-posh)
if [ -n "$ZSH_VERSION" ]; then
  # ZSH
  export PS1="[%F{cyan}%n%f@%F{green}%m%f:%F{yellow}%~%f]$ "
else
  # Bash
  export PS1="[\[\033[36m\]\u\[\033[37m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]]$ "
fi

# Preferred editor
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

# ZSH/Oh My Zsh settings
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"


# shell files tracking - keep at the end
ZFILES_COUNT=$((ZFILES_COUNT + 1))
export ZFILE_VARS=1
