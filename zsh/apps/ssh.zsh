#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

## SSH configuration

if is_installed ssh; then
    export SSH_HOME="$CONFDIR/ssh"
    export SSH_AUTH_SOCK="$SSH_HOME/ssh_auth.sock"
fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}