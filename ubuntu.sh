#!/bin/bash

# Git, gh & repos
sudo NEEDRESTART_MODE=a apt -y install git gh
gh auth login
mkdir -p ~/GitHub && cd $_
gh repo clone barabasz/bin
ln -sf ~/GitHub/bin/linux ~/bin
gh repo clone barabasz/bintest
ln -sf ~/GitHub/bintest/linux ~/bintest
gh repo clone barabasz/config

# zsh & omz
install-zsh
install-omz

# Core tools & apps
install-essentials

# Remove snap
remove-snap

# Minimize login info
fix-login-info

# Set locale
set-locale

# mc (Midnight Commander)
install-mc

# nvim (neovim)
install-nvim
