export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# INCLUDES
[ -f ~/.bash_profile ] && source ~/.bash_profile
[ -f ~/.iterm2_shell_integration.zsh ] && source ~/.iterm2_shell_integration.zsh

export PATH=$HOME/bin:$HOME/bin/test:$HOME/bin/install:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 1

# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(copyfile copypath history sudo web-search zsh-autosuggestions zsh-syntax-highlighting macos)
source $ZSH/oh-my-zsh.sh

# User configuration

export PS1="[%{%F{cyan}%}%n%{%f%}@%{%F{green}%}%m:%{%F{yellow}%}%~%{%f%}%]]$ "

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
 export EDITOR='nvim'
fi

# Aliases
alias vim="nvim"
alias vi="nvim"
alias view="nvim -R"
alias vimdiff="nvim -d"
alias mc="mc --nosubshell"
alias myip="curl icanhazip.com" # Show public IP
alias python=python3

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
