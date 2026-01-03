#!/usr/bin/env zsh
this_file=$(basename "${0:A}")

## ACME Shell script: acme.sh
if is_dir "$HOME/.acme.sh"; then
    . "$HOME/.acme.sh/acme.sh.env"
fi

## oh-my-zsh
if is_file "$ZSH/oh-my-zsh.sh"; then
    sourceif $ZDOTDIR/assets/.zsh_omz $this_file
fi

## oh-my-posh
if is_installed oh-my-posh; then
    sourceif $ZDOTDIR/assets/.zsh_omp $this_file
fi

## bat (cat clone)
if is_installed bat; then
    sourceif $ZDOTDIR/assets/.zsh_bat $this_file
fi

## brew (package manager)
if is_installed brew; then
    sourceif $ZDOTDIR/assets/.zsh_brew $this_file
fi

## fzf (fuzzy finder)
if is_installed fzf; then
    sourceif $ZDOTDIR/assets/.zsh_fzf $this_file
fi

## thefuck (corrects previous command)
if is_installed thefuck; then
    sourceif $ZDOTDIR/assets/.zsh_thefuck $this_file
fi

## python virtual environment
if is_installed python3; then
    sourceif $ZDOTDIR/assets/.zsh_python $this_file
fi

## rust (programming language)
if is_file "$HOME/.cargo/env"; then
    source "$HOME/.cargo/env"
fi

## yazi file manager
if is_installed yazi; then
    sourceif $ZDOTDIR/assets/.zsh_yazi $this_file
fi

## zoxide (cd replacement)
if is_installed zoxide; then
    sourceif $ZDOTDIR/assets/.zsh_zoxide $this_file
fi

# Shell files tracking - keep at the end
ZFILES[$this_file]=1