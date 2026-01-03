#!/bin/zsh
this_file=${0:A:t}

# end of shell files tracking - keep at the top
ZFILES_COUNT=$((ZFILES_COUNT + 1))
export ZFILE_LOGIN=1

# show login info
if [[ $LOGIN_INFO == 1 ]]; then
    sysinfo
    shellfiles
    logininfo
    printf "\n"
fi
