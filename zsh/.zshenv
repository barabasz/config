#!/bin/zsh
# Shell files tracking - keep at the top
source "$HOME/.config/zsh/inc/zfiles.zsh"
zfile_track_start ${0:A}

# Zsh core configuration
source "$HOME/.config/zsh/inc/zsh.zsh"

# Zsh bootstrap functions
source "$ZINCDIR/bootstrap.zsh"

# XDG directories
source "$ZINCDIR/xdg.zsh"

# User folders
source "$ZINCDIR/folders.zsh"

# Environment variables
source "$ZINCDIR/variables.zsh"

# Helper library
source_zsh_dir "$ZLIBDIR"

# PATH
source "$ZINCDIR/path.zsh"

# Locale 
source "$ZINCDIR/locales.zsh"

# Shell files tracking - keep at the end
zfile_track_end ${0:A}