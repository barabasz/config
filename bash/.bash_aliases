# ALIASES

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias cd..="cd ../"
alias cd...="cd ../../"
alias cd....="cd ../../../"
alias cpwd='pwd | xclip -selection clipboard' # copy the current working directory to the clipboard
alias cls="clear"
alias ls="ls -aFhlG"
alias l='ls -CF'
alias la='ls -A'
alias ll="ls -alF"
alias lsh="ls -ld .??*" # List .files
alias myip='curl -s ipinfo.io | grep "ip"'
alias reload="source ~/.bash_profile" # Reload profile
