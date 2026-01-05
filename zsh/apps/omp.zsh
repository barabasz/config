#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Oh My Posh configuration

if is_installed oh-my-posh; then

    export OMP_THEME=$CONFDIR/omp/my.omp.json

    if is_file $OMP_THEME; then
        eval "$(oh-my-posh --config $OMP_THEME init zsh)"
    else
        eval "$(oh-my-posh init zsh)"
    fi

fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}