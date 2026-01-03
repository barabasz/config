#!/usr/bin/env zsh
#
# Filesystem related functions
# zsh-specific functions - requires zsh, will not work in bash

# Check if path exists and is a regular file
is_file() {
    [[ $# -eq 1 && -f "$1" ]]
}

# Check if path exists and is a directory
is_dir() {
    [[ $# -eq 1 && -d "$1" ]]
}

# Check if path exists and is a symbolic link
is_link() {
    [[ $# -eq 1 && -L "$1" ]]
}

# Alias for is_link (more explicit name)
is_symlink() {
    is_link "$@"
}

# Check if file is a hard link (has link count > 1)
is_hardlink() {
    [[ $# -eq 1 && -f "$1" ]] && (( $(stat -c '%h' "$1" 2>/dev/null || stat -f '%l' "$1" 2>/dev/null) > 1 ))
}

# Check if path exists (any type)
is_exists() {
    [[ $# -eq 1 && -e "$1" ]]
}

# Check if path is a block device
is_block_device() {
    [[ $# -eq 1 && -b "$1" ]]
}

# Check if path is a character device
is_char_device() {
    [[ $# -eq 1 && -c "$1" ]]
}

# Check if path is a named pipe (FIFO)
is_pipe() {
    [[ $# -eq 1 && -p "$1" ]]
}

# Check if path is a socket
is_socket() {
    [[ $# -eq 1 && -S "$1" ]]
}