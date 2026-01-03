#!/bin/zsh

# Oh My Posh configuration

theme=$CONFDIR/omp/my.omp.json

if [[ -f $theme ]]; then
    eval "$(oh-my-posh --config $theme init zsh)"
else
    eval "$(oh-my-posh init zsh)"
fi