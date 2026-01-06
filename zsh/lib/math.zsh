#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Get minimum of two or more numbers
# Usage: min 5 3 8 1
# Returns: 1
min() {
    [[ $# -ge 1 ]] || return 1
    local min_val=$1
    shift

    for num in "$@"; do
        (( num < min_val )) && min_val=$num
    done

    print $min_val
}

# Get maximum of two or more numbers
# Usage: max 5 3 8 1
# Returns: 8
max() {
    [[ $# -ge 1 ]] || return 1
    local max_val=$1
    shift

    for num in "$@"; do
        (( num > max_val )) && max_val=$num
    done

    print $max_val
}

# Calculate sum of numbers
# Usage: sum 1 2 3 4 5
# Returns: 15
sum() {
    [[ $# -ge 1 ]] || return 1
    local total=0

    for num in "$@"; do
        (( total += num ))
    done

    print $total
}

# Calculate average (mean) of numbers
# Usage: avg 1 2 3 4 5
# Returns: 3
avg() {
    [[ $# -ge 1 ]] || return 1
    local total=0
    local count=$#

    for num in "$@"; do
        (( total += num ))
    done

    print $(( total / count ))
}

# Calculate average with floating point
# Usage: avgf 1 2 3 4 5
# Returns: 3.0
avgf() {
    [[ $# -ge 1 ]] || return 1
    local total=0
    local count=$#

    for num in "$@"; do
        (( total += num ))
    done

    # Use bc for floating point if available
    if is_installed bc; then
        print "scale=2; $total / $count" | bc
    else
        print $(( total / count ))
    fi
}

# Get absolute value
# Usage: abs -5
# Returns: 5
abs() {
    [[ $# -eq 1 ]] || return 1
    local num=$1
    (( num < 0 )) && num=$(( -num ))
    print $num
}

# Calculate power
# Usage: pow 2 8
# Returns: 256 (2^8)
pow() {
    [[ $# -eq 2 ]] || return 1
    local base=$1
    local exp=$2
    local result=1

    if (( exp == 0 )); then
        print 1
        return 0
    fi

    for ((i=0; i<exp; i++)); do
        (( result *= base ))
    done

    print $result
}

# Calculate square root (integer)
# Usage: sqrt 16
# Returns: 4
sqrt() {
    [[ $# -eq 1 ]] || return 1
    local num=$1

    if is_installed bc; then
        print "scale=0; sqrt($num)" | bc
    else
        # Simple integer sqrt using binary search
        local low=0
        local high=$num
        local mid result

        while (( low <= high )); do
            mid=$(( (low + high) / 2 ))
            result=$(( mid * mid ))

            if (( result == num )); then
                print $mid
                return 0
            elif (( result < num )); then
                low=$(( mid + 1 ))
            else
                high=$(( mid - 1 ))
            fi
        done

        print $high
    fi
}

# Generate random number between min and max (inclusive)
# Usage: random 1 100
# Returns: random number between 1 and 100
random() {
    [[ $# -eq 2 ]] || return 1
    local min=$1
    local max=$2

    (( max < min )) && { local tmp=$min; min=$max; max=$tmp; }

    print $(( RANDOM % (max - min + 1) + min ))
}

# Check if number is even
# Usage: is_even 4
# Returns: 0 (true) or 1 (false)
is_even() {
    [[ $# -eq 1 ]] || return 1
    (( $1 % 2 == 0 ))
}

# Check if number is odd
# Usage: is_odd 3
# Returns: 0 (true) or 1 (false)
is_odd() {
    [[ $# -eq 1 ]] || return 1
    (( $1 % 2 != 0 ))
}

# Check if number is positive
# Usage: is_positive 5
# Returns: 0 (true) or 1 (false)
is_positive() {
    [[ $# -eq 1 ]] || return 1
    (( $1 > 0 ))
}

# Check if number is negative
# Usage: is_negative -5
# Returns: 0 (true) or 1 (false)
is_negative() {
    [[ $# -eq 1 ]] || return 1
    (( $1 < 0 ))
}

# Check if number is zero
# Usage: is_zero 0
# Returns: 0 (true) or 1 (false)
is_zero() {
    [[ $# -eq 1 ]] || return 1
    (( $1 == 0 ))
}

# Round number to nearest integer
# Usage: round 3.7
# Returns: 4
round() {
    [[ $# -eq 1 ]] || return 1
    local num=$1

    if is_installed bc; then
        print "scale=0; ($num + 0.5) / 1" | bc
    else
        # Integer only
        print $(( ${num%%.*} ))
    fi
}

# Calculate factorial
# Usage: factorial 5
# Returns: 120 (5! = 5*4*3*2*1)
factorial() {
    [[ $# -eq 1 ]] || return 1
    local num=$1
    local result=1

    if (( num < 0 )); then
        print "Error: Factorial not defined for negative numbers" >&2
        return 1
    fi

    for ((i=2; i<=num; i++)); do
        (( result *= i ))
    done

    print $result
}

# Calculate percentage
# Usage: percent 25 200
# Returns: 50 (25% of 200)
percent() {
    [[ $# -eq 2 ]] || return 1
    local percentage=$1
    local total=$2

    if is_installed bc; then
        print "scale=2; ($percentage * $total) / 100" | bc
    else
        print $(( (percentage * total) / 100 ))
    fi
}

# Check if number is in range
# Usage: in_range 5 1 10
# Returns: 0 (true) if 5 is between 1 and 10
in_range() {
    [[ $# -eq 3 ]] || return 1
    local num=$1
    local min=$2
    local max=$3

    (( num >= min && num <= max ))
}

# Clamp number to range
# Usage: clamp 15 0 10
# Returns: 10 (clamps 15 to max of 10)
clamp() {
    [[ $# -eq 3 ]] || return 1
    local num=$1
    local min=$2
    local max=$3

    (( num < min )) && num=$min
    (( num > max )) && num=$max

    print $num
}

# Calculate GCD (Greatest Common Divisor)
# Usage: gcd 48 18
# Returns: 6
gcd() {
    [[ $# -eq 2 ]] || return 1
    local a=$1
    local b=$2
    local temp

    while (( b != 0 )); do
        temp=$b
        b=$(( a % b ))
        a=$temp
    done

    print $a
}

# Calculate LCM (Least Common Multiple)
# Usage: lcm 12 18
# Returns: 36
lcm() {
    [[ $# -eq 2 ]] || return 1
    local a=$1
    local b=$2
    local gcd_val=$(gcd $a $b)

    print $(( (a * b) / gcd_val ))
}

# Convert degrees to radians
# Usage: deg2rad 180
# Returns: 3.14159... (π)
deg2rad() {
    [[ $# -eq 1 ]] || return 1
    local deg=$1

    if is_installed bc; then
        print "scale=6; $deg * 3.141592653589793 / 180" | bc
    else
        print "Error: bc required for floating point operations" >&2
        return 1
    fi
}

# Convert radians to degrees
# Usage: rad2deg 3.14159
# Returns: 180
rad2deg() {
    [[ $# -eq 1 ]] || return 1
    local rad=$1

    if is_installed bc; then
        print "scale=6; $rad * 180 / 3.141592653589793" | bc
    else
        print "Error: bc required for floating point operations" >&2
        return 1
    fi
}

# Calculate fibonacci number at position n
# Usage: fibonacci 10
# Returns: 55
fibonacci() {
    [[ $# -eq 1 ]] || return 1
    local n=$1

    if (( n <= 0 )); then
        print 0
        return 0
    elif (( n == 1 )); then
        print 1
        return 0
    fi

    local a=0
    local b=1
    local temp

    for ((i=2; i<=n; i++)); do
        temp=$b
        (( b = a + b ))
        a=$temp
    done

    print $b
}

# shell files tracking - keep at the end
zfile_track_end ${0:A}
