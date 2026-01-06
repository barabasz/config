#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Check if network is connected
# Usage: is_connected
# Returns: 0 (true) if connected, 1 (false) otherwise
is_connected() {
    if is_macos; then
        # macOS: check if any network service is active
        networksetup -getairportnetwork en0 &>/dev/null || \
        networksetup -listallnetworkservices | grep -v "An asterisk" | \
        while read service; do
            [[ -n "$service" ]] && networksetup -getinfo "$service" 2>/dev/null | grep -q "IP address:" && return 0
        done
        return 1
    elif is_linux; then
        # Linux: check if default route exists
        ip route show default &>/dev/null || return 1
        return 0
    fi
    return 1
}

# Check if internet is reachable
# Usage: is_online
# Returns: 0 (true) if online, 1 (false) otherwise
is_online() {
    # Try to ping common DNS servers
    if is_installed ping; then
        # Try Cloudflare DNS (1.1.1.1)
        ping -c 1 -W 2 1.1.1.1 &>/dev/null && return 0
        # Try Google DNS (8.8.8.8)
        ping -c 1 -W 2 8.8.8.8 &>/dev/null && return 0
    fi
    return 1
}

# Get default gateway IP address
# Usage: get_gateway
# Returns: gateway IP address
get_gateway() {
    local gateway

    if is_macos; then
        gateway=$(route -n get default 2>/dev/null | awk '/gateway:/ {print $2}')
    elif is_linux; then
        gateway=$(ip route show default 2>/dev/null | awk '/default/ {print $3}')
    fi

    if [[ -n "$gateway" ]]; then
        print "$gateway"
        return 0
    fi
    return 1
}

# Get local IP address
# Usage: get_local_ip
# Returns: local IP address
get_local_ip() {
    local ip

    if is_macos; then
        # Try en0 (Ethernet/WiFi on Mac)
        ip=$(ipconfig getifaddr en0 2>/dev/null)
        # If en0 fails, try en1
        [[ -z "$ip" ]] && ip=$(ipconfig getifaddr en1 2>/dev/null)
    elif is_linux; then
        # Get IP from default route interface
        local iface=$(ip route show default 2>/dev/null | awk '/default/ {print $5}')
        [[ -n "$iface" ]] && ip=$(ip addr show "$iface" 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1)
    fi

    if [[ -n "$ip" ]]; then
        print "$ip"
        return 0
    fi
    return 1
}

# Get public/WAN IP address
# Usage: get_public_ip
# Returns: public IP address
get_public_ip() {
    local ip

    # Try multiple services in order
    if is_installed curl; then
        ip=$(curl -s --max-time 5 https://api.ipify.org 2>/dev/null) || \
        ip=$(curl -s --max-time 5 https://ifconfig.me 2>/dev/null) || \
        ip=$(curl -s --max-time 5 https://icanhazip.com 2>/dev/null)
    elif is_installed wget; then
        ip=$(wget -qO- --timeout=5 https://api.ipify.org 2>/dev/null) || \
        ip=$(wget -qO- --timeout=5 https://ifconfig.me 2>/dev/null)
    fi

    if [[ -n "$ip" ]]; then
        print "$ip"
        return 0
    fi
    return 1
}

# Get network interface names
# Usage: get_interfaces
# Returns: list of network interfaces
get_interfaces() {
    local interfaces

    if is_macos; then
        interfaces=$(networksetup -listallhardwareports 2>/dev/null | awk '/Device:/ {print $2}')
    elif is_linux; then
        interfaces=$(ip -o link show 2>/dev/null | awk -F': ' '{print $2}')
    fi

    if [[ -n "$interfaces" ]]; then
        print "$interfaces"
        return 0
    fi
    return 1
}

# Get active network interface
# Usage: get_active_interface
# Returns: name of active network interface
get_active_interface() {
    local iface

    if is_macos; then
        # Check en0 first (common for WiFi/Ethernet)
        if ipconfig getifaddr en0 &>/dev/null; then
            print "en0"
            return 0
        elif ipconfig getifaddr en1 &>/dev/null; then
            print "en1"
            return 0
        fi
    elif is_linux; then
        iface=$(ip route show default 2>/dev/null | awk '/default/ {print $5}')
        if [[ -n "$iface" ]]; then
            print "$iface"
            return 0
        fi
    fi
    return 1
}

# Get MAC address of interface
# Usage: get_mac_address [interface]
# Returns: MAC address
get_mac_address() {
    local iface="${1:-$(get_active_interface)}"
    local mac

    [[ -z "$iface" ]] && return 1

    if is_macos; then
        mac=$(ifconfig "$iface" 2>/dev/null | awk '/ether/ {print $2}')
    elif is_linux; then
        mac=$(ip link show "$iface" 2>/dev/null | awk '/link\/ether/ {print $2}')
    fi

    if [[ -n "$mac" ]]; then
        print "$mac"
        return 0
    fi
    return 1
}

# Get DNS servers
# Usage: get_dns_servers
# Returns: list of DNS servers
get_dns_servers() {
    local dns

    if is_macos; then
        dns=$(scutil --dns 2>/dev/null | awk '/nameserver\[0\]/ {print $3}')
    elif is_linux; then
        if [[ -f /etc/resolv.conf ]]; then
            dns=$(grep "^nameserver" /etc/resolv.conf | awk '{print $2}')
        fi
    fi

    if [[ -n "$dns" ]]; then
        print "$dns"
        return 0
    fi
    return 1
}

# Get WiFi SSID (macOS only)
# Usage: get_wifi_ssid
# Returns: WiFi network name
get_wifi_ssid() {
    [[ ! $(is_macos) ]] && return 1

    local ssid

    if is_installed networksetup; then
        ssid=$(networksetup -getairportnetwork en0 2>/dev/null | awk -F': ' '{print $2}')
    fi

    if [[ -n "$ssid" && "$ssid" != "You are not associated with an AirPort network." ]]; then
        print "$ssid"
        return 0
    fi
    return 1
}

# Get network speed/bandwidth for interface
# Usage: get_interface_speed [interface]
# Returns: interface speed
get_interface_speed() {
    local iface="${1:-$(get_active_interface)}"
    local speed

    [[ -z "$iface" ]] && return 1

    if is_macos; then
        speed=$(networksetup -getMedia "$iface" 2>/dev/null | grep "Active:" | awk '{print $2}')
    elif is_linux; then
        if [[ -f "/sys/class/net/$iface/speed" ]]; then
            speed=$(cat "/sys/class/net/$iface/speed" 2>/dev/null)
            [[ -n "$speed" && "$speed" != "-1" ]] && speed="${speed}Mbps"
        fi
    fi

    if [[ -n "$speed" ]]; then
        print "$speed"
        return 0
    fi
    return 1
}

# Check if IP address is valid
# Usage: is_valid_ip "192.168.1.1"
# Returns: 0 (true) or 1 (false)
is_valid_ip() {
    [[ $# -eq 1 ]] || return 1
    local ip=$1

    # IPv4 validation
    if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        local IFS='.'
        local -a octets=($ip)
        for octet in $octets; do
            (( octet >= 0 && octet <= 255 )) || return 1
        done
        return 0
    fi
    return 1
}

# Check if port is open
# Usage: is_port_open "localhost" 80
# Returns: 0 (true) if open, 1 (false) otherwise
is_port_open() {
    [[ $# -eq 2 ]] || return 1
    local host=$1
    local port=$2

    if is_installed nc; then
        nc -z -w 2 "$host" "$port" &>/dev/null
        return $?
    elif is_installed timeout; then
        timeout 2 bash -c "echo >/dev/tcp/$host/$port" &>/dev/null
        return $?
    fi
    return 1
}

# Get hostname
# Usage: get_hostname
# Returns: system hostname
get_hostname() {
    local hostname

    if is_installed hostname; then
        hostname=$(hostname -s 2>/dev/null || hostname 2>/dev/null)
    elif [[ -f /etc/hostname ]]; then
        hostname=$(cat /etc/hostname 2>/dev/null)
    fi

    if [[ -n "$hostname" ]]; then
        print "$hostname"
        return 0
    fi
    return 1
}

# Get fully qualified domain name
# Usage: get_fqdn
# Returns: fully qualified domain name
get_fqdn() {
    local fqdn

    if is_installed hostname; then
        fqdn=$(hostname -f 2>/dev/null || hostname 2>/dev/null)
    fi

    if [[ -n "$fqdn" ]]; then
        print "$fqdn"
        return 0
    fi
    return 1
}

# shell files tracking - keep at the end
zfile_track_end ${0:A}
