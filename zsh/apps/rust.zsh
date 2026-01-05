#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# rust (programming language)
if is_file "$HOME/.cargo/env"; then

    # Rust environment
    source "$HOME/.cargo/env"

    # Cargo and Rustup directories
    export CARGO_HOME=${CARGO_HOME:-$HOME/.cargo}
    export RUSTUP_HOME=${RUSTUP_HOME:-$HOME/.rustup}

fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}