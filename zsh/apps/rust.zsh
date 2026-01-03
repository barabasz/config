#!/bin/zsh

# Rust environment
source "$HOME/.cargo/env"

# Cargo and Rustup directories
export CARGO_HOME=${CARGO_HOME:-$HOME/.cargo}
export RUSTUP_HOME=${RUSTUP_HOME:-$HOME/.rustup}