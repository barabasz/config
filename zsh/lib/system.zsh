#!/usr/bin/env zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# OS related functions
# zsh-specific functions - requires zsh, will not work in bash

# Check if current OS is Debian-based (includes Ubuntu, Mint, etc.)
is_debian_based() {
    [[ -f /etc/debian_version ]]
}

# Check if current OS is specifically Debian (not Ubuntu or other derivatives)
is_debian() {
    [[ -f /etc/os-release ]] && grep -q '^ID=debian$' /etc/os-release
}

# Check if current OS is specifically Ubuntu
is_ubuntu() {
    [[ -f /etc/os-release ]] && grep -q '^ID=ubuntu$' /etc/os-release
}

# Check if current OS is macOS
is_macos() {
    [[ $OSTYPE == darwin* ]]
}

# Check if current OS is Linux
is_linux() {
    [[ $OSTYPE == linux* ]]
}

# Get OS name
os_name() {
    local ostype=${(L)$(uname -s)}
    
    case $ostype in
        darwin)
            print "macos"
            ;;
        linux)
            if [[ -f /etc/os-release ]]; then
                local id=${${(M)${(f)"$(</etc/os-release)"}:#ID=*}#ID=}
                print ${id//\"/}
            fi
            ;;
        *)
            print "unknown"
            ;;
    esac
}

# shell files tracking - keep at the end
zfile_track_end ${0:A}