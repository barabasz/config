#!/bin/zsh
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
    case $OSTYPE in
        darwin*)
            print "macos" ;;
        linux*)
            if [[ -f /etc/os-release ]]; then
                local id=${${(M)${(f)"$(</etc/os-release)"}:#ID=*}#ID=}
                print ${id//\"/}
            fi ;;
        *)
            print "unknown" ;;
    esac
}

# Get OS code name
os_codename() {
    if is_macos; then
        macos_codename
    else
        linux_codename
    fi
}

# Get Linux codename
linux_codename() {
    [[ -f /etc/os-release ]] || return 1
    local line=${(M)${(f)"$(</etc/os-release)"}:#VERSION_CODENAME=*}
    local codename=${${line#VERSION_CODENAME=}//\"/}
    print "${(C)codename}"
}

# Get macOS codename
macos_codename() {
    local ver=${$(sw_vers -productVersion)%%.*}
    case $ver in
        26) print "Tahoe" ;;
        15) print "Sequoia" ;;
        14) print "Sonoma" ;;
        13) print "Ventura" ;;
        12) print "Monterey" ;;
        11) print "Big Sur" ;;
        *)  print "Unknown (version $ver)" ;;
    esac
}

# Display OS version
os_version() {
    if is_macos; then
        sw_vers -productVersion
    elif [[ -f /etc/os-release ]]; then
        local line=${(M)${(f)"$(</etc/os-release)"}:#VERSION_ID=*}
        print ${${line#VERSION_ID=}//\"/}
    fi
}

# Get OS icon
os_icon() {
    case $(os_name) in
        macos)  print "\Uf8ff" ;;
        ubuntu) print "\Uf31b" ;;
        debian) print "\Uf306" ;;
        redhat) print "\Uef5d" ;;
        *)      print "" ;;
    esac
}

# Shell files tracking - keep at the end
zfile_track_end ${0:A}