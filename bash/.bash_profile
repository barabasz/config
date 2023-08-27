# VARIABLES

#first PS1 is for bash, 2nd for zsh
#export PS1="[\[\033[36m\]\u\[\033[37m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]]$ "
export PS1="[%{%F{cyan}%}%n%{%f%}@%{%F{green}%}%m:%{%F{yellow}%}%~%{%f%}%]]$ "
export BASH_SILENCE_DEPRECATION_WARNING=1
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export HISTCONTROL=ignoredups
export HISTSIZE=1000
export HISTFILESIZE=1000
export PROMPT_COMMAND='echo -ne "\033]0;$PWD\007"' # iTerm custom title
export PATH=/usr/local/sbin:/usr/local/bin:/usr/local/share/npm/bin:~/bin:$PATH
export LC_COLLATE=pl_PL.UTF-8
export LC_MONETARY=pl_PL
export LC_NUMERIC=pl_PL
export LC_TIME=pl_PL
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export HOMEBREW_GITHUB_API_TOKEN=d924f8e42b76099853427541eaff7ecb0b2f79e9
export PATH="$(brew --prefix php):$PATH"

# Default Editor
export EDITOR='/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl'

# LESS man page colors
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# GENERAL

alias reload="source ~/.bash_profile" # Reload profile
# complete nie instalowalem, bo moze umie to zsh
# complete -cf sudo # Tab complete for sudo
#. /usr/local/etc/profile.d/z.sh #Tracks most-used directories to make cd smarter
eval $(thefuck --alias) #The fuck
archey -o
# cowsay -W 60 $(fortune -a -s)
printf '\n\n'

# FILESYSTEM

alias cd..="cd ../"
alias cd...="cd ../../"
alias cd....="cd ../../../"
alias ls="ls -aFhlG"
alias ll="ls -l"
#dwa ponizsze nie zdialaly z zsh
#alias tolowercase="pbpaste | tr "[:upper:]" "[:lower:]" | pbcopy"
#alias touppercase="pbpaste | tr "[:lower:]" "[:upper:]" | pbcopy"
alias lsh="ls -ld .??*" # List .files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete && find . -name 'Thumbs.db' -type f -ls -delete"

# NETWORK

alias myip="dig +short myip.opendns.com @resolver1.opendns.com" # Show public IP
#alias myip = "curl eth0.me"
alias localip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'" # Show local IP
alias flushdns="dscacheutil -flushcache"
alias hosts="subl /private/etc/hosts" # Edit hosts

# APACHE / PHP / MYSQL
alias apacher="sudo /usr/sbin/apachectl restart"
alias apachestop="sudo /usr/sbin/apachectl stop"
alias apachestart="sudo /usr/sbin/apachectl start"
alias vhosts="subl ~/Links/httpd-vhosts.conf" # Edit virtual hosts
alias phpini="subl ~/Links/php.ini" # Edit php.ini
alias phplog="tail -f /var/log/apache2/error_log"

# FUNCTIONS

# Calculate execution time
exetime() {
  s=$(date +%s)
  $@
  rc=$?
  echo "took $[$(date +%s)-$s] seconds" >&2
  return $rc
}


# Find files, ignore directories & SVN and hide some errors
function ff() {
	find . -iname $1 2>&1 | grep -v .svn | grep -v .sass-cache | grep -v 'Permission denied' | grep -v 'Not a directory'
}

# Show http status code for any URL
function httpcode() {
	curl "$*" -IsS | grep "HTTP/"
}

# Create dir and cd into
function mkcd () {
	mkdir -p "$*"
	cd "$*"
}

# CD into the last focused finder window
function cdf() {
	cd "$(osascript -e 'tell application "Finder"' \
	   -e 'set myname to POSIX path of (target of window 1 as alias)' \
	   -e 'end tell' 2>/dev/null)"
}

# Calculate SHA3-512 checksum
function hash() {
    rhash $1 --sha3-512
}

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
##
# Your previous /Users/barabasz/.bash_profile file was backed up as /Users/barabasz/.bash_profile.macports-saved_2017-10-11_at_14:49:22
##

# MacPorts Installer addition on 2017-10-11_at_14:49:22: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

