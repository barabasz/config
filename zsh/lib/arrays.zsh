#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Check if array contains element
# Usage: array_contains arr "element"
# Returns: 0 (true) or 1 (false)
array_contains() {
    [[ $# -eq 2 ]] || return 1
    local -n arr_ref=$1
    local element=$2

    for item in "${arr_ref[@]}"; do
        [[ "$item" == "$element" ]] && return 0
    done
    return 1
}

# Get unique elements from array
# Usage: array_unique arr result_arr
# Sets result_arr to unique elements
array_unique() {
    [[ $# -eq 2 ]] || return 1
    local -n arr_ref=$1
    local -n result_ref=$2
    local -A seen

    result_ref=()
    for item in "${arr_ref[@]}"; do
        if [[ -z ${seen[$item]} ]]; then
            result_ref+=("$item")
            seen[$item]=1
        fi
    done
}

# Get array length
# Usage: array_length arr
# Returns: number of elements
array_length() {
    [[ $# -eq 1 ]] || return 1
    local -n arr_ref=$1
    print ${#arr_ref[@]}
}

# Check if array is empty
# Usage: array_is_empty arr
# Returns: 0 (true) or 1 (false)
array_is_empty() {
    [[ $# -eq 1 ]] || return 1
    local -n arr_ref=$1
    (( ${#arr_ref[@]} == 0 ))
}

# Check if array/variable is initialized
# Usage: is_array_initialized arr
# Returns: 0 (true) if initialized, 1 (false) otherwise
is_array_initialized() {
    [[ $# -eq 1 ]] || return 1
    [[ -v $1 ]]
}

# Get first element of array
# Usage: array_first arr
# Returns: first element
array_first() {
    [[ $# -eq 1 ]] || return 1
    local -n arr_ref=$1

    if (( ${#arr_ref[@]} > 0 )); then
        print "${arr_ref[1]}"
        return 0
    fi
    return 1
}

# Get last element of array
# Usage: array_last arr
# Returns: last element
array_last() {
    [[ $# -eq 1 ]] || return 1
    local -n arr_ref=$1

    if (( ${#arr_ref[@]} > 0 )); then
        print "${arr_ref[-1]}"
        return 0
    fi
    return 1
}

# Append element to array
# Usage: array_push arr "element"
array_push() {
    [[ $# -eq 2 ]] || return 1
    local -n arr_ref=$1
    local element=$2

    arr_ref+=("$element")
}

# Remove and return last element from array
# Usage: array_pop arr
# Returns: last element and modifies array
array_pop() {
    [[ $# -eq 1 ]] || return 1
    local -n arr_ref=$1

    if (( ${#arr_ref[@]} > 0 )); then
        print "${arr_ref[-1]}"
        arr_ref=("${arr_ref[@]:0:${#arr_ref[@]}-1}")
        return 0
    fi
    return 1
}

# Remove and return first element from array
# Usage: array_shift arr
# Returns: first element and modifies array
array_shift() {
    [[ $# -eq 1 ]] || return 1
    local -n arr_ref=$1

    if (( ${#arr_ref[@]} > 0 )); then
        print "${arr_ref[1]}"
        arr_ref=("${arr_ref[@]:1}")
        return 0
    fi
    return 1
}

# Add element to beginning of array
# Usage: array_unshift arr "element"
array_unshift() {
    [[ $# -eq 2 ]] || return 1
    local -n arr_ref=$1
    local element=$2

    arr_ref=("$element" "${arr_ref[@]}")
}

# Reverse array
# Usage: array_reverse arr result_arr
# Sets result_arr to reversed array
array_reverse() {
    [[ $# -eq 2 ]] || return 1
    local -n arr_ref=$1
    local -n result_ref=$2

    result_ref=()
    local i
    for ((i=${#arr_ref[@]}; i>0; i--)); do
        result_ref+=("${arr_ref[$i]}")
    done
}

# Sort array
# Usage: array_sort arr result_arr
# Sets result_arr to sorted array
array_sort() {
    [[ $# -eq 2 ]] || return 1
    local -n arr_ref=$1
    local -n result_ref=$2

    result_ref=("${(@o)arr_ref}")
}

# Sort array in reverse order
# Usage: array_sort_reverse arr result_arr
# Sets result_arr to reverse sorted array
array_sort_reverse() {
    [[ $# -eq 2 ]] || return 1
    local -n arr_ref=$1
    local -n result_ref=$2

    result_ref=("${(@O)arr_ref}")
}

# Get index of element in array
# Usage: array_index_of arr "element"
# Returns: index (1-based) or -1 if not found
array_index_of() {
    [[ $# -eq 2 ]] || return 1
    local -n arr_ref=$1
    local element=$2
    local i

    for i in {1..${#arr_ref[@]}}; do
        [[ "${arr_ref[$i]}" == "$element" ]] && { print $i; return 0; }
    done
    print "-1"
    return 1
}

# Slice array
# Usage: array_slice arr start [length] result_arr
# Sets result_arr to sliced array
array_slice() {
    [[ $# -ge 3 && $# -le 4 ]] || return 1
    local -n arr_ref=$1
    local start=$2
    local length=${3:-$((${#arr_ref[@]} - start + 1))}
    local -n result_ref=${4:-$3}

    result_ref=("${arr_ref[@]:$start:$length}")
}

# Filter array by pattern
# Usage: array_filter arr "pattern" result_arr
# Sets result_arr to elements matching pattern
array_filter() {
    [[ $# -eq 3 ]] || return 1
    local -n arr_ref=$1
    local pattern=$2
    local -n result_ref=$3

    result_ref=()
    for item in "${arr_ref[@]}"; do
        [[ "$item" == $pattern ]] && result_ref+=("$item")
    done
}

# Map array through function
# Usage: array_map arr function_name result_arr
# Sets result_arr to transformed elements
array_map() {
    [[ $# -eq 3 ]] || return 1
    local -n arr_ref=$1
    local func=$2
    local -n result_ref=$3

    result_ref=()
    for item in "${arr_ref[@]}"; do
        result_ref+=("$($func "$item")")
    done
}

# Join array with separator
# Usage: array_join arr ","
# Returns: joined string
array_join() {
    [[ $# -eq 2 ]] || return 1
    local -n arr_ref=$1
    local separator=$2

    print "${(j[$separator])arr_ref}"
}

# Remove element from array by value
# Usage: array_remove arr "element"
# Modifies array by removing all occurrences
array_remove() {
    [[ $# -eq 2 ]] || return 1
    local -n arr_ref=$1
    local element=$2
    local -a temp_arr

    for item in "${arr_ref[@]}"; do
        [[ "$item" != "$element" ]] && temp_arr+=("$item")
    done
    arr_ref=("${temp_arr[@]}")
}

# Remove element from array by index
# Usage: array_remove_at arr index
# Modifies array by removing element at index
array_remove_at() {
    [[ $# -eq 2 ]] || return 1
    local -n arr_ref=$1
    local index=$2

    if (( index >= 1 && index <= ${#arr_ref[@]} )); then
        arr_ref=("${arr_ref[@]:0:$((index-1))}" "${arr_ref[@]:$index}")
        return 0
    fi
    return 1
}

# Flatten nested arrays
# Usage: array_flatten arr result_arr
# Sets result_arr to flattened array
array_flatten() {
    [[ $# -eq 2 ]] || return 1
    local -n arr_ref=$1
    local -n result_ref=$2

    result_ref=()
    for item in "${arr_ref[@]}"; do
        if [[ "$item" == *" "* ]]; then
            # If item contains spaces, split it
            result_ref+=("${(z)item}")
        else
            result_ref+=("$item")
        fi
    done
}

# Concatenate multiple arrays
# Usage: array_concat arr1 arr2 [arr3...] result_arr
# Sets result_arr to concatenated arrays
array_concat() {
    [[ $# -ge 3 ]] || return 1

    local -a all_arrays=("$@")
    local result_name=${all_arrays[-1]}
    unset "all_arrays[-1]"

    local -n result_ref=$result_name
    result_ref=()

    for arr_name in "${all_arrays[@]}"; do
        local -n temp_arr=$arr_name
        result_ref+=("${temp_arr[@]}")
    done
}

# Check if all elements match predicate
# Usage: array_every arr function_name
# Returns: 0 (true) if all match, 1 (false) otherwise
array_every() {
    [[ $# -eq 2 ]] || return 1
    local -n arr_ref=$1
    local func=$2

    for item in "${arr_ref[@]}"; do
        $func "$item" || return 1
    done
    return 0
}

# Check if any element matches predicate
# Usage: array_some arr function_name
# Returns: 0 (true) if any match, 1 (false) otherwise
array_some() {
    [[ $# -eq 2 ]] || return 1
    local -n arr_ref=$1
    local func=$2

    for item in "${arr_ref[@]}"; do
        $func "$item" && return 0
    done
    return 1
}

# Get array intersection (common elements)
# Usage: array_intersect arr1 arr2 result_arr
# Sets result_arr to common elements
array_intersect() {
    [[ $# -eq 3 ]] || return 1
    local -n arr1_ref=$1
    local -n arr2_ref=$2
    local -n result_ref=$3

    result_ref=()
    for item in "${arr1_ref[@]}"; do
        if array_contains $2 "$item"; then
            result_ref+=("$item")
        fi
    done
}

# Get array difference (elements in arr1 but not in arr2)
# Usage: array_diff arr1 arr2 result_arr
# Sets result_arr to difference
array_diff() {
    [[ $# -eq 3 ]] || return 1
    local -n arr1_ref=$1
    local -n arr2_ref=$2
    local -n result_ref=$3

    result_ref=()
    for item in "${arr1_ref[@]}"; do
        if ! array_contains $2 "$item"; then
            result_ref+=("$item")
        fi
    done
}

# Print array elements (for debugging)
# Usage: array_print arr
array_print() {
    [[ $# -eq 1 ]] || return 1
    local -n arr_ref=$1
    local i

    for i in {1..${#arr_ref[@]}}; do
        print "[$i] ${arr_ref[$i]}"
    done
}

# shell files tracking - keep at the end
zfile_track_end ${0:A}
