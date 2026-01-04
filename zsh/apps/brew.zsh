#!/bin/zsh

# homebrew environment variables

export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_EMOJI=1

# homebrew shellenv integration

if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if is_installed brew; then
    export HOMEBREW_LOADED=1
fi

