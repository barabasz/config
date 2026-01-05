#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# yazi shell wrapper
# https://yazi-rs.github.io/docs/quick-start/#shell-wrapper

if is_installed yazi; then
    function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    }
fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}