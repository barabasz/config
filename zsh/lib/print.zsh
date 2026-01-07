#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Output and Logging helper functions
# Depends on colors defined in inc/bootstrap.zsh (e.g. $r, $g, $y, $b, $x)

# Print error message to stderr
# Usage: printe "Error text" [text_color] [glyph] [glyph_color]
# Default: ❌ Error text
printe() {
    local text="$1"
    local tc="${2:-$x}"    # Text Color
    local glyph="${3:-❌}" # Glyph
    local gc="${4:-$x}"    # Glyph Color
    
    print -u2 -- "${gc}${glyph}${x} ${tc}${text}${x}"
}

# Print warning message to stderr
# Usage: printw "Warning text" [text_color] [glyph] [glyph_color]
# Default: ⚠️ Warning text
printw() {
    local text="$1"
    local tc="${2:-$x}"
    local glyph="${3:-⚠️}"
    local gc="${4:-$x}"

    print -u2 -- "${gc}${glyph}${x} ${tc}${text}${x}"
}

# Print info message to stdout
# Usage: printi "Info text" [text_color] [glyph] [glyph_color]
# Default: ℹ️ Info text
printi() {
    local text="$1"
    local tc="${2:-$x}"
    local glyph="${3:-ℹ️}"
    local gc="${4:-$x}"

    print -- "${gc}${glyph}${x} ${tc}${text}${x}"
}

# Print success message to stdout
# Usage: prints "Success text" [text_color] [glyph] [glyph_color]
# Default: ✅ Success text
prints() {
    local text="$1"
    local tc="${2:-$x}"
    local glyph="${3:-✅}"
    local gc="${4:-$x}"

    print -- "${gc}${glyph}${x} ${tc}${text}${x}"
}
# Alias: printok
functions[printok]=$functions[prints]

# Print debug message (only if debug mode is on)
# Usage: printd "Debug text" [text_color] [glyph] [glyph_color]
# Default: 💬 Debug text
# Returns: Prints to stderr if ZSH_DEBUG=1
printd() {
    # Uses is_debug from varia.zsh if available, otherwise manual check
    if (( ${+functions[is_debug]} )) && is_debug || [[ $ZSH_DEBUG == 1 ]]; then
        local text="$1"
        local tc="${2:-$x}"
        local glyph="${3:-💬}"
        local gc="${4:-$x}"
        
        print -u2 -- "${gc}${glyph}${x} ${tc}${text}${x}"
    fi
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

# Print text surrounded by a border (Title Box)
# Usage: printt "Text" [text_color] [border_color]
# Example: printt "Alert" $r $y
# Returns: Prints formatted box to stdout
printt() {
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

# Print a separator line with custom width
# Usage: printl [color] [char] [width]
# width: can be integer (e.g. 50) or percentage (e.g. 50%)
# Example: printl $r "*" 50%
# Returns: Prints line to stdout
printl() {
    local color="${1:-$x}"       # Default color: reset ($x)
    local char="${2:-─}"         # Default char: horizontal line (─)
    local width_arg="${3:-100%}" # Default width: full screen

    # Get max terminal width
    local max_cols=${COLUMNS:-$(tput cols 2>/dev/null || print 80)}
    local cols

    # Calculate target width based on argument type
    if [[ "$width_arg" == *% ]]; then
        # Percentage calculation: remove '%' suffix and multiply
        # Using Zsh arithmetic expansion for integer math
        cols=$(( max_cols * ${width_arg%\%} / 100 ))
    else
        # Fixed integer width
        cols=$width_arg
    fi

    # Safety check: ensure width is essentially non-negative integer
    (( cols < 0 )) && cols=0

    # Step 1: Generate a line of spaces of length 'cols'
    local line="${(l:cols:: :):-}"

    # Step 2: Replace spaces with the requested char
    line="${line// /${char}}"

    # Print with color
    print -- "${color}${line}${x}"
}

# Print a header with an underline of the same length
# Usage: printh "Text" [text_color] [line_color] [line_char]
# Example: printh "Title" $r $g "="
# Returns: Prints text and underline to stdout
printh() {
    [[ $# -ge 1 ]] || return 1
    local text="$1"
    local tc="${2:-$x}"   # Text Color (defaults to reset)
    local lc="${3:-$x}"   # Line Color (defaults to reset)
    local char="${4:-‾}"  # Line Char (defaults to overline)

    # Print the text
    print -- "${tc}${text}${x}"

    # Print the underline using printl with specific width
    # This leverages the integer width logic in printl
    # ${#text} gets the length of the string
    printl "$lc" "$char" "${#text}"
}

# shell files tracking - keep at the end
zfile_track_end ${0:A}