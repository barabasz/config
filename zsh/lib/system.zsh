#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# OS related functions
# zsh-specific functions - requires zsh, will not work in bash

# --- OS Detection (Boolean Checks) ---

# Check if current OS is Debian-based (includes Ubuntu, Mint, etc.)
# Usage: is_debian_based
# Returns: 0 (true) or 1 (false)
is_debian_based() {
    [[ -f /etc/debian_version ]]
}

# Check if current OS is specifically Debian (not derivatives)
# Usage: is_debian
# Returns: 0 (true) or 1 (false)
is_debian() {
    [[ -f /etc/os-release ]] || return 1
    # Read file, filter line starting with ID=, check if it contains debian
    local content=$(</etc/os-release)
    [[ $content =~ 'ID=debian' ]]
}

# Check if current OS is specifically Ubuntu
# Usage: is_ubuntu
# Returns: 0 (true) or 1 (false)
is_ubuntu() {
    [[ -f /etc/os-release ]] || return 1
    local content=$(</etc/os-release)
    [[ $content =~ 'ID=ubuntu' ]]
}

# Check if current OS is macOS
# Usage: is_macos
# Returns: 0 (true) or 1 (false)
is_macos() {
    [[ $OSTYPE == darwin* ]]
}

# Check if current OS is Linux
# Usage: is_linux
# Returns: 0 (true) or 1 (false)
is_linux() {
    [[ $OSTYPE == linux* ]]
}

# Check if current OS is Windows (WSL)
# Usage: is_wsl
# Returns: 0 (true) or 1 (false)
is_wsl() {
    [[ -f /proc/version ]] && grep -q "microsoft" /proc/version
}

# Check if running as root
# Usage: is_root
# Returns: 0 (true) or 1 (false)
is_root() {
    (( EUID == 0 ))
}

# --- System Information Retrieval ---

# Get OS name (ID)
# Usage: os_name
# Returns: "macos", "ubuntu", "debian", "fedora", etc.
os_name() {
    case $OSTYPE in
        darwin*)
            print "macos" ;;
        linux*)
            if [[ -f /etc/os-release ]]; then
                # Extract ID value purely within Zsh
                local line=${(M)${(f)"$(</etc/os-release)"}:#ID=*}
                print -- ${${line#ID=}//\"/}
            else
                print "linux"
            fi ;;
        *)
            print "unknown" ;;
    esac
}

# Get OS code name
# Usage: os_codename
# Returns: "Sequoia", "Noble", "Bookworm", etc.
os_codename() {
    if is_macos; then
        _macos_codename
    else
        _linux_codename
    fi
}

# Helper for Linux codename
# Usage: _linux_codename
# Returns: Codename string
_linux_codename() {
    [[ -f /etc/os-release ]] || return 1
    local line=${(M)${(f)"$(</etc/os-release)"}:#VERSION_CODENAME=*}
    # Fallback to PRETTY_NAME if VERSION_CODENAME is missing
    if [[ -z "$line" ]]; then
        line=${(M)${(f)"$(</etc/os-release)"}:#PRETTY_NAME=*}
    fi
    local codename=${${line#*=}//\"/}
    print -- "${(C)codename}"
}

# Helper for macOS codename
# Usage: _macos_codename
# Returns: macOS marketing name
_macos_codename() {
    local product_ver
    # Fast retrieval using sw_vers
    product_ver=$(sw_vers -productVersion)
    
    # Split version by dots
    local -a ver_parts=(${(s:.:)product_ver})
    local major=${ver_parts[1]}
    local minor=${ver_parts[2]}

    case $major in
        26) print "Tahoe" ;;
        15) print "Sequoia" ;;
        14) print "Sonoma" ;;
        13) print "Ventura" ;;
        12) print "Monterey" ;;
        11) print "Big Sur" ;;
        10)
            case $minor in
                16|15) print "Catalina" ;;
                14) print "Mojave" ;;
                13) print "High Sierra" ;;
                12) print "Sierra" ;;
                11) print "El Capitan" ;;
                *)  print "macOS $product_ver" ;;
            esac
            ;;
        *)  print "Unknown ($product_ver)" ;;
    esac
}

# Display OS version number
# Usage: os_version
# Returns: "14.2.1" or "22.04"
os_version() {
    if is_macos; then
        sw_vers -productVersion
    elif [[ -f /etc/os-release ]]; then
        local line=${(M)${(f)"$(</etc/os-release)"}:#VERSION_ID=*}
        print -- ${${line#VERSION_ID=}//\"/}
    fi
}

# Get system architecture
# Usage: get_arch
# Returns: "arm64", "x86_64", etc.
get_arch() {
    # 'uname -m' is standard, but check if we can get it from env first
    print -- ${CPUTYPE:-$(uname -m)}
}

# Get kernel version
# Usage: get_kernel_version
# Returns: "6.5.0-14-generic" or "23.2.0"
get_kernel_version() {
    uname -r
}

# Get OS icon (Nerd Fonts required)
# Usage: os_icon
# Returns: Unicode character
os_icon() {
    case $(os_name) in
        macos)      print $'\Uf179' ;; # Apple logo
        ubuntu)     print $'\Uf31b' ;;
        debian)     print $'\Uf306' ;;
        redhat)     print $'\Uf316' ;;
        fedora)     print $'\Uf30a' ;;
        arch)       print $'\Uf303' ;;
        opensuse*)  print $'\Uf314' ;;
        windows)    print $'\Uf17a' ;;
        *)          print $'\Ue712' ;; # Generic Linux penguin
    esac
}

# Get system uptime (human readable)
# Usage: get_uptime
# Returns: "2 days 4h 15m" using format_duration
get_uptime() {
    local uptime_sec boot_time
    if is_macos; then
        boot_time=${$(sysctl -n kern.boottime)[(w)4]//,}
        uptime_sec=$(( EPOCHSECONDS - boot_time ))
    elif [[ -r /proc/uptime ]]; then
        read uptime_sec _ < /proc/uptime
        uptime_sec=${uptime_sec%.*}
    else
        # Fallback to standard uptime command
        uptime | sed 's/.*up \([^,]*\), .*/up \1/'
        return 0
    fi
    # Use helper from date.zsh if available
    if (( ${+functions[format_duration]} )); then
        format_duration "$uptime_sec"
    else
        print -- "${uptime_sec}s"
    fi
}

# Get number of CPU cores
# Usage: get_cpu_count
# Returns: Integer (e.g. 8)
get_cpu_count() {
    if is_macos; then
        sysctl -n hw.ncpu
    elif is_linux; then
        nproc 2>/dev/null || grep -c ^processor /proc/cpuinfo
    fi
}

# shell files tracking - keep at the end
zfile_track_end ${0:A}