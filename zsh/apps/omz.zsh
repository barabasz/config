#!/bin/zsh
# NOTE: Prefixed with _ to load BEFORE omp.zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Define OMZ paths
export ZSH="$CONFDIR/omz"
export ZSH_CUSTOM="$ZSH/custom"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"

# Guard
[[ -d "$ZSH" ]] || return

# Create cache dir if missing
[[ -d "$ZSH_CACHE_DIR" ]] || mkdir -p "$ZSH_CACHE_DIR"

# --- 1. COMPLETION INITIALIZATION ---

# Smart caching strategy to avoid running compinit every time.

autoload -Uz compinit
local zcompdump="$ZSH_CACHE_DIR/zcompdump-$HOST"

# Check if dump file exists and is fresh (modified less than 20 hours ago)
if [[ -n "$zcompdump"(#qN.mh-20) ]]; then
    # Load from dump (Fast)
    compinit -C -d "$zcompdump"
else
    # Rebuild completion (Slow, runs once per day)
    compinit -i -d "$zcompdump"
    # Compile the dump file for extra speed in background
    { zcompile "$zcompdump" } &! 
fi

# --- 2. HISTORY SETTINGS ---

# Variables are in variables.zsh, but we need options here
setopt append_history           # Append to history file
setopt extended_history         # Save timestamps
setopt hist_expire_dups_first   # Delete duplicates first when HISTSIZE exceeded
setopt hist_ignore_dups         # Ignore consecutive duplicates
setopt hist_ignore_all_dups     # Delete old recorded entry if new entry is a duplicate
setopt hist_find_no_dups        # Do not display a line previously found
setopt hist_ignore_space        # Don't record lines starting with space
setopt hist_save_no_dups        # Don't write duplicate entries in the history file
setopt hist_verify              # Show command with history expansion to user before running it
setopt share_history            # Share history between all sessions

# --- 3. MANUAL PLUGIN LOADING ---

# Helper to load a plugin from OMZ or Custom folder
_load_plugin() {
    local name="$1"
    local file="$2" # Optional: specific path inside OMZ
    
    # 1. Try Custom Path (e.g. git cloned plugins)
    if [[ -f "$ZSH_CUSTOM/plugins/$name/$name.plugin.zsh" ]]; then
        source "$ZSH_CUSTOM/plugins/$name/$name.plugin.zsh"
    # 2. Try Custom File (flat structure)
    elif [[ -f "$ZSH_CUSTOM/plugins/$name/$name.zsh" ]]; then
        source "$ZSH_CUSTOM/plugins/$name/$name.zsh"
    # 3. Try Standard OMZ Path
    elif [[ -n "$file" && -f "$file" ]]; then
        source "$file"
    fi
}

# A) sudo plugin (Double ESC to add sudo)
_load_plugin "sudo" "$ZSH/plugins/sudo/sudo.plugin.zsh"

# B) macOS plugin (Only on macOS)
if is_macos; then
    _load_plugin "macos" "$ZSH/plugins/macos/macos.plugin.zsh"
fi

# C) zsh-autosuggestions
if [[ -f "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
else
    _load_plugin "zsh-autosuggestions" "$ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# D) zsh-syntax-highlighting (MUST BE LAST)
if [[ -f "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
    _load_plugin "zsh-syntax-highlighting" "$ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}