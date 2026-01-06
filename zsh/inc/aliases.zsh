#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Global

alias -g G='| grep'

# Common

alias info='sysinfo && logininfo'
alias reload="source $ZDOTDIR/.zshrc && omz reload" # Reload zsh configuration
alias cls='clear' # Clear terminal
alias myip='curl icanhazip.com' # Show public IP
alias ds='du -sh ./*/' # Show directory sizes

# Applications

## 7zz
if is_installed 7zz; then
    alias 7z='7zz'
fi

## bat
if is_installed bat; then
    alias bat='bat -n'
    alias cat='bat'
fi

## brew
if is_installed brew; then
    alias brewu='brew update && brew upgrade && brew missing && brew autoremove && brew cleanup && brew doctor'
fi

## cal
if is_installed cal; then
    alias cal='cal -m3'
fi

## code
if is_installed code; then
    alias vsc='code'
fi

## exa
if is_installed eza; then
    alias eza='eza --icons'
    alias exa='eza --icons'
    alias ls='eza --group-directories-first'
    alias ll='ls --long'
    alias la='ll --all'
    alias tree='eza --tree  --icons'
    alias tree2='eza --tree --level=2 --icons'
    alias tree3='eza --tree --level=3 --icons'
fi

## gdate
if is_installed gdate; then
    alias date='gdate'
fi

## git
if is_installed git; then
    alias gaa='git add --all'
    alias gcm='git commit -m "update"'
    alias glog='git log --oneline -n 10'
    alias gpu='git add --all && git commit -m "update" && git push'
    alias grb='git pull --rebase'
    alias gup='git pull --rebase'
    alias gsb='git status -sb'
    alias gst='git status -s'
fi

## gsed
if is_macos; then
    if is_installed gsed; then
        alias sed='gsed'
    fi
fi

## http-server
if is_installed http-server; then
    alias serve='http-server -c-1 -o'
fi

## mc
if is_installed mc; then
    alias mc='mc --nosubshell'
fi

## nivm
if is_installed nvim; then
    alias vi='nvim'
    alias view='nvim -R'
    alias vim='nvim'
    alias neovim='nvim'
    alias vimdiff='nvim -d'
fi

## node
if is_installed node; then
    alias js='node'
fi

## npx
if is_installed npx; then
    alias ts='npx tsx'
fi

## oh-my-posh
if is_installed oh-my-posh; then
    alias omp='oh-my-posh'
fi

## pip3
if is_installed pip3; then
    alias pip='pip3'
    alias pipi='pip install'
    alias pipu='pip uninstall'
    alias pipf='pip freeze'
fi

## python
if is_installed python3; then
    alias python='python3'
    alias py='python3'
fi

## trippy
if is_installed trip; then
    alias trip='sudo trip'
fi

## yt-dlp
if is_installed yt-dlp; then
    alias youtube-dl='yt-dlp'
    alias ytdl='yt-dlp'
fi

## z (zoxide)
if is_installed zoxide; then
    alias cd='z'
    alias cd..='z ..'
    alias zz='z -'
fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}
