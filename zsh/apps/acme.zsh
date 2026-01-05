#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

## ACME Shell script: acme.sh

if is_dir "$HOME/.acme.sh"; then
    . "$HOME/.acme.sh/acme.sh.env"
    #is_debug && print "✅ $this_file loaded."
else
    #is_debug && print "⚠️ $this_file not loaded."
fi

# shell files tracking - keep at the end
zfile_track_end ${0:A}