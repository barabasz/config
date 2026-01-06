#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Extract version number from a string
# Usage: get_version "zsh 5.9"
# Returns: 5.9
get_version() {
    local input=$1

    if [[ $input =~ '[0-9]+\.[0-9]+(\.[0-9]+)*' ]]; then
        print $MATCH
        return 0
    fi
    return 1
}

# Trim whitespace from both ends of string
# Usage: trim "  hello world  "
# Returns: "hello world"
trim() {
    [[ $# -eq 1 ]] || return 1
    local str="$1"
    str="${str#"${str%%[![:space:]]*}"}"
    str="${str%"${str##*[![:space:]]}"}"
    print "$str"
}

# Trim whitespace from left side of string
# Usage: ltrim "  hello world"
# Returns: "hello world"
ltrim() {
    [[ $# -eq 1 ]] || return 1
    local str="$1"
    str="${str#"${str%%[![:space:]]*}"}"
    print "$str"
}

# Trim whitespace from right side of string
# Usage: rtrim "hello world  "
# Returns: "hello world"
rtrim() {
    [[ $# -eq 1 ]] || return 1
    local str="$1"
    str="${str%"${str##*[![:space:]]}"}"
    print "$str"
}

# Convert string to lowercase
# Usage: lowercase "HELLO World"
# Returns: "hello world"
lowercase() {
    [[ $# -eq 1 ]] || return 1
    print "${1:l}"
}

# Convert string to uppercase
# Usage: uppercase "hello World"
# Returns: "HELLO WORLD"
uppercase() {
    [[ $# -eq 1 ]] || return 1
    print "${1:u}"
}

# Capitalize first letter of string
# Usage: capitalize "hello world"
# Returns: "Hello world"
capitalize() {
    [[ $# -eq 1 ]] || return 1
    print "${(C)1}"
}

# Check if string contains substring
# Usage: str_contains "hello world" "world"
# Returns: 0 (true) or 1 (false)
str_contains() {
    [[ $# -eq 2 ]] || return 1
    [[ "$1" == *"$2"* ]]
}

# Check if string starts with prefix
# Usage: str_starts_with "hello world" "hello"
# Returns: 0 (true) or 1 (false)
str_starts_with() {
    [[ $# -eq 2 ]] || return 1
    [[ "$1" == "$2"* ]]
}

# Check if string ends with suffix
# Usage: str_ends_with "hello world" "world"
# Returns: 0 (true) or 1 (false)
str_ends_with() {
    [[ $# -eq 2 ]] || return 1
    [[ "$1" == *"$2" ]]
}

# Get string length
# Usage: str_length "hello"
# Returns: 5
str_length() {
    [[ $# -eq 1 ]] || return 1
    print ${#1}
}

# Repeat string N times
# Usage: str_repeat "-" 10
# Returns: "----------"
str_repeat() {
    [[ $# -eq 2 ]] || return 1
    local str="$1"
    local count=$2
    local result=""

    (( count > 0 )) || return 1

    for ((i=0; i<count; i++)); do
        result+="$str"
    done

    print "$result"
}

# Reverse string
# Usage: str_reverse "hello"
# Returns: "olleh"
str_reverse() {
    [[ $# -eq 1 ]] || return 1
    local str="$1"
    local reversed=""
    local i

    for ((i=${#str}-1; i>=0; i--)); do
        reversed+="${str:$i:1}"
    done

    print "$reversed"
}

# Split string by delimiter into array
# Usage: str_split "a:b:c" ":" arr
# Sets array variable arr=(a b c)
str_split() {
    [[ $# -eq 3 ]] || return 1
    local str="$1"
    local delim="$2"
    local -n arr_ref=$3

    arr_ref=("${(@s[$delim])str}")
}

# Join array elements with delimiter
# Usage: str_join ":" arr
# Returns: "a:b:c" (where arr=(a b c))
str_join() {
    [[ $# -eq 2 ]] || return 1
    local delim="$1"
    local -n arr_ref=$2

    print "${(j[$delim])arr_ref}"
}

# Replace first occurrence of pattern with replacement
# Usage: str_replace "hello world" "world" "zsh"
# Returns: "hello zsh"
str_replace() {
    [[ $# -eq 3 ]] || return 1
    local str="$1"
    local pattern="$2"
    local replacement="$3"

    print "${str/$pattern/$replacement}"
}

# Replace all occurrences of pattern with replacement
# Usage: str_replace_all "hello world world" "world" "zsh"
# Returns: "hello zsh zsh"
str_replace_all() {
    [[ $# -eq 3 ]] || return 1
    local str="$1"
    local pattern="$2"
    local replacement="$3"

    print "${str//$pattern/$replacement}"
}

# Check if string is empty
# Usage: is_empty "  "
# Returns: 0 (true) for empty/whitespace-only, 1 (false) otherwise
is_empty() {
    [[ $# -eq 1 ]] || return 1
    local str="$(trim "$1")"
    [[ -z "$str" ]]
}

# Check if string is numeric
# Usage: is_numeric "123"
# Returns: 0 (true) or 1 (false)
is_numeric() {
    [[ $# -eq 1 ]] || return 1
    [[ "$1" =~ '^-?[0-9]+$' ]]
}

# Check if string is alphanumeric
# Usage: is_alphanumeric "abc123"
# Returns: 0 (true) or 1 (false)
is_alphanumeric() {
    [[ $# -eq 1 ]] || return 1
    [[ "$1" =~ '^[[:alnum:]]+$' ]]
}

# Get substring
# Usage: substring "hello world" 6 5
# Returns: "world" (start at position 6, length 5)
substring() {
    [[ $# -ge 2 && $# -le 3 ]] || return 1
    local str="$1"
    local start=$2
    local length=${3:-${#str}}

    print "${str:$start:$length}"
}

# shell files tracking - keep at the end
zfile_track_end ${0:A}