#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# yazi shell wrapper
# https://yazi-rs.github.io/docs/quick-start/#shell-wrapper

if is_installed yazi; then
    y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        # Check if the file exists and has content
        if [[ -f "$tmp" ]]; then
            local cwd="$(<"$tmp")"
            if [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
                builtin cd -- "$cwd"
            fi
            rm -f -- "$tmp"
        fi
    }
fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}