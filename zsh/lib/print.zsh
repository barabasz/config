#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Output and Logging helper functions
# Depends on colors defined in inc/bootstrap.zsh (e.g. $r, $g, $y, $b, $x)

# Print error message to stderr
# Usage: printe "File not found"
# Returns: Prints to stderr
printe() {
    print -u2 -- "${r}[ERROR]${x} $*"
}

# Print warning message to stderr
# Usage: printw "Disk space low"
# Returns: Prints to stderr
printw() {
    print -u2 -- "${y}[WARN]${x} $*"
}

# Print info message
# Usage: printi "Starting backup..."
# Returns: Prints to stdout
printi() {
    print -- "${b}[INFO]${x} $*"
}

# Print success message
# Usage: prints "Operation completed"
# Returns: Prints to stdout
prints() {
    print -- "${g}[OK]${x} $*"
}

# Print debug message (only if debug mode is on)
# Usage: printd "Variable x = 10"
# Returns: Prints to stderr if ZSH_DEBUG=1
printd() {
    # Uses is_debug from varia.zsh if available, otherwise manual check
    if (( ${+functions[is_debug]} )) && is_debug || [[ $ZSH_DEBUG == 1 ]]; then
        print -u2 -- "${m:-$b}[DEBUG]${x} $*"
    fi
}

# Print a header/section title
# Usage: printh "System Update"
# Returns: Prints formatted header
printh() {
    local msg="$*"
    local line
    # Create a line of dashes of the same length
    line="${(l:${#msg}::-:)}"
    
    print -- "\n${b}${msg}${x}"
    print -- "${b}${line}${x}"
}

# Ask user for input with default value
# Usage: printq "Enter name" "DefaultName"
# Returns: The user input or default
printq() {
    local prompt_text="$1"
    local default_val="$2"
    local input
    
    # Print prompt with default in brackets
    # -n prevents newline
    print -n -- "${y}${prompt_text}${x} [${default_val}]: "
    read -r input
    
    # Return input or default if empty
    print -- "${input:-$default_val}"
}

# Print text surrounded by a border
# Usage: printb "Text" [text_color] [border_color]
# Example: printb "Alert" $r $y
# Returns: Prints formatted box to stdout
printb() {
    [[ $# -ge 1 ]] || return 1
    local text="$1"
    local ct="${2:-$x}" # Color Text (defaults to $x)
    local cb="${3:-$x}" # Color Border (defaults to $x)

    # Calculate border width (text + 2 spaces padding)
    local width=$(( ${#text} + 2 ))
    
    # Generate horizontal bar using Zsh padding flag (l:length::char:)
    # Creates an empty string of length $width filled with ─
    local bar="${(l:width::─:)}"

    # Draw the box
    print -- "${cb}┌${bar}┐${x}"
    print -- "${cb}│${x} ${ct}${text}${x} ${cb}│${x}"
    print -- "${cb}└${bar}┘${x}"
}

# Print a full-width separator line
# Usage: printl [color] [char]
# Example: printl $r "*"
# Returns: Prints line to stdout
printl() {
    local color="${1:-$x}"  # Default color: reset ($x)
    local char="${2:-─}"    # Default char: horizontal line (─)

    # Get terminal width
    local cols=${COLUMNS:-$(tput cols 2>/dev/null || print 80)}

    # Step 1: Generate a line of spaces of length 'cols'
    # (l:cols:: :) creates padding with spaces
    local line="${(l:cols:: :):-}"

    # Step 2: Replace all spaces with the requested char
    # This avoids Zsh parsing issues when nesting variables inside flags
    line="${line// /${char}}"

    # Print with color
    print -- "${color}${line}${x}"
}

# shell files tracking - keep at the end
zfile_track_end ${0:A}