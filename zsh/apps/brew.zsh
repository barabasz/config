#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Homebrew configuration

brew_mac_path="/opt/homebrew/bin/brew"
brew_linux_path="/home/linuxbrew/.linuxbrew/bin/brew"

if [[ -f $brew_mac_path ]] || [[ -f $brew_linux_path ]]; then

    # homebrew shellenv integration
    if [[ -f $brew_mac_path ]]; then
        eval "$($brew_mac_path shellenv)"
    elif [[ -f $brew_linux_path ]]; then
        eval "$($brew_linux_path shellenv)"
    fi

    # homebrew environment variables
    export HOMEBREW_NO_ENV_HINTS=1
    export HOMEBREW_NO_EMOJI=1
    export HOMEBREW_LOADED=1

fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}