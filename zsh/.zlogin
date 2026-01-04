#!/bin/zsh
this_file=${0:A:t}

# end of shell files tracking - keep at the top
ZFILES[$this_file]=1

# Interactive cleanup
unset d # set by zsh
unset thisfile

# show login info
if [[ $LOGIN_INFO == 1 ]]; then
    sysinfo
    shellfiles
    logininfo
    printf "\n"
fi
