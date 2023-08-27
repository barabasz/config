#!/bin/bash

# Update, upgrade & cleanup
sudo apt update && sudo apt -y upgrade
sudo apt autoremove

# Certs & security
sudo apt install -y openssh-server gnupg2 ca-certificates acl

# Basic tools
sudo apt install -y net-tools lsb-release apt-transport-https software-properties-common

# Git & GitHub
sudo apt -y install git gh
gh auth login

# Clone bin
if [ ! -d "~/GitHub/bin" ]; then
    gh repo clone barabasz/bin
fi
ln -sf ~/GitHub/bin/linux ~/bin

# Clone bintest
if [ ! -d "~/GitHub/bintest" ]; then
    gh repo clone barabasz/bintest
fi
ln -sf ~/GitHub/bintest/linux ~/bintest

# Clone config
mkdir -p ~/GitHub && cd $_
if [ ! -d "~/GitHub/config" ]; then
    gh repo clone barabasz/config
fi

# Locale
sudo apt install language-pack-pl-base language-pack-pl
sudo locale-gen pl_PL && sudo locale-gen pl_PL.UTF-8
sudo cp -f ~/GitHub/config/default/locale /etc/default/locale

# zsh & omz
ln -sf ~/GitHub/config/zsh/.zshrc ~/
ln -sf ~/GitHub/config/zsh/.zprofile ~/
ln -sf ~/GitHub/config/zsh/.p10k.zsh ~/
sudo apt install zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# mc (Midnight Commander)
sudo apt install -y mc
mkdir -p ~/.config/mc
ln -sf ~/GitHub/config/mc/ini ~/.config/mc/ini
ln -sf ~/GitHub/config/mc/panels.ini ~/.config/mc/panels.ini

# nvim

# Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"