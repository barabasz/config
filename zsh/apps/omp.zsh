#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Oh My Posh configuration

if is_installed oh-my-posh; then

    theme=$CONFDIR/omp/my.omp.json

    if is_file $theme; then
        eval "$(oh-my-posh --config $theme init zsh)"
    else
        eval "$(oh-my-posh init zsh)"
    fi

fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}