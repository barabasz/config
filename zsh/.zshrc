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

# user scripts and binaries
export PATH=$HOME/bin:$HOME/binc:$HOME/binc/install:$HOME/binc/test:/usr/local/bin:$PATH

# homebrew
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
source $HOMEBREW_PREFIX/etc/homebrew/brew.env

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

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
 export EDITOR='nvim'
fi

# LOCALE
source ~/.zsh_locale

# ALIASES
source ~/.zsh_aliases

# FUNCTIONS
source ~/.zsh_functions

# MODULES
source ~/lib/ansi.sh
source ~/lib/log.sh

# PROMPT
# fallback
export PS1="[%{%F{cyan}%}%n%{%f%}@%{%F{green}%}%m:%{%F{yellow}%}%~%{%f%}%]]$ "
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Load Angular CLI autocompletion.
source <(ng completion script)
