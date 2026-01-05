#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start "$ZDOTDIR/.zlogin"

# Interactive cleanup
unset d # set by zsh

# Show login info
if [[ $ZSH_LOGIN_INFO == 1 ]]; then
    sysinfo
    logininfo
    printf "\n"
fi

# Shell files tracking - keep at the end
zfile_track_end "$ZDOTDIR/.zlogin"
ZFILES_TIME[total]=$(( ${(j:+:)ZFILES_TIME} ))
unset this_file ZFILES_START