#!/bin/zsh
# Shell files tracking - keep at the top
zfile_track_start ${0:A}

# Get current timestamp (Unix epoch)
# Usage: timestamp
# Returns: 1704556800
now_timestamp() {
    print $EPOCHSECONDS
}

# Get current date in ISO 8601 format
# Usage: now_iso
# Returns: 2024-01-06
now_iso() {
    print "$(strftime "%Y-%m-%d" $EPOCHSECONDS)"
}

# Get current date and time in ISO 8601 format
# Usage: now_iso_full
# Returns: 2024-01-06T15:30:45
now_iso_full() {
    print "$(strftime "%Y-%m-%dT%H:%M:%S" $EPOCHSECONDS)"
}

# Get current date in custom format
# Usage: now_format "%Y/%m/%d"
# Returns: 2024/01/06
now_format() {
    [[ $# -eq 1 ]] || return 1
    print "$(strftime "$1" $EPOCHSECONDS)"
}

# Get current year
# Usage: current_year
# Returns: 2024
current_year() {
    print "$(strftime "%Y" $EPOCHSECONDS)"
}

# Get current month (numeric)
# Usage: current_month
# Returns: 01
current_month() {
    print "$(strftime "%m" $EPOCHSECONDS)"
}

# Get current month (name)
# Usage: current_month_name
# Returns: January
current_month_name() {
    print "$(strftime "%B" $EPOCHSECONDS)"
}

# Get current day
# Usage: current_day
# Returns: 06
current_day() {
    print "$(strftime "%d" $EPOCHSECONDS)"
}

# Get current day of week (name)
# Usage: current_weekday
# Returns: Saturday
current_weekday() {
    print "$(strftime "%A" $EPOCHSECONDS)"
}

# Get current hour (24h format)
# Usage: current_hour
# Returns: 15
current_hour() {
    print "$(strftime "%H" $EPOCHSECONDS)"
}

# Get current minute
# Usage: current_minute
# Returns: 30
current_minute() {
    print "$(strftime "%M" $EPOCHSECONDS)"
}

# Get current second
# Usage: current_second
# Returns: 45
current_second() {
    print "$(strftime "%S" $EPOCHSECONDS)"
}

# Format timestamp to date string
# Usage: format_timestamp 1704556800 "%Y-%m-%d"
# Returns: 2024-01-06
format_timestamp() {
    [[ $# -eq 2 ]] || return 1
    local timestamp=$1
    local format=$2

    print "$(strftime "$format" $timestamp)"
}

# Get timestamp for specific date
# Usage: date_to_timestamp "2024-01-06"
# Returns: 1704556800
date_to_timestamp() {
    [[ $# -eq 1 ]] || return 1
    local date_str="$1"

    if is_macos; then
        date -j -f "%Y-%m-%d" "$date_str" "+%s" 2>/dev/null
    elif is_linux; then
        date -d "$date_str" "+%s" 2>/dev/null
    fi
}

# Add days to current date
# Usage: add_days 7
# Returns: timestamp for 7 days from now
add_days() {
    [[ $# -eq 1 ]] || return 1
    local days=$1
    local seconds=$(( days * 86400 ))

    print $(( EPOCHSECONDS + seconds ))
}

# Subtract days from current date
# Usage: sub_days 7
# Returns: timestamp for 7 days ago
sub_days() {
    [[ $# -eq 1 ]] || return 1
    local days=$1
    local seconds=$(( days * 86400 ))

    print $(( EPOCHSECONDS - seconds ))
}

# Get difference between two timestamps in days
# Usage: days_between 1704556800 1704643200
# Returns: 1
days_between() {
    [[ $# -eq 2 ]] || return 1
    local ts1=$1
    local ts2=$2
    local diff=$(( ts2 - ts1 ))
    local days=$(( diff / 86400 ))

    print ${days#-}  # absolute value
}

# Get difference between two timestamps in hours
# Usage: hours_between 1704556800 1704560400
# Returns: 1
hours_between() {
    [[ $# -eq 2 ]] || return 1
    local ts1=$1
    local ts2=$2
    local diff=$(( ts2 - ts1 ))
    local hours=$(( diff / 3600 ))

    print ${hours#-}  # absolute value
}

# Get difference between two timestamps in minutes
# Usage: minutes_between 1704556800 1704556860
# Returns: 1
minutes_between() {
    [[ $# -eq 2 ]] || return 1
    local ts1=$1
    local ts2=$2
    local diff=$(( ts2 - ts1 ))
    local minutes=$(( diff / 60 ))

    print ${minutes#-}  # absolute value
}

# Get difference between two timestamps in seconds
# Usage: seconds_between 1704556800 1704556801
# Returns: 1
seconds_between() {
    [[ $# -eq 2 ]] || return 1
    local ts1=$1
    local ts2=$2
    local diff=$(( ts2 - ts1 ))

    print ${diff#-}  # absolute value
}

# Check if year is leap year
# Usage: is_leap_year 2024
# Returns: 0 (true) or 1 (false)
is_leap_year() {
    [[ $# -eq 1 ]] || return 1
    local year=$1

    if (( year % 400 == 0 )); then
        return 0
    elif (( year % 100 == 0 )); then
        return 1
    elif (( year % 4 == 0 )); then
        return 0
    else
        return 1
    fi
}

# Get number of days in month
# Usage: days_in_month 2 2024
# Returns: 29 (February 2024 is a leap year)
days_in_month() {
    [[ $# -eq 2 ]] || return 1
    local month=$1
    local year=$2

    case $month in
        1|3|5|7|8|10|12) print 31 ;;
        4|6|9|11) print 30 ;;
        2)
            if is_leap_year $year; then
                print 29
            else
                print 28
            fi
            ;;
        *) return 1 ;;
    esac
}

# Get age from birthdate
# Usage: age_from_date "1990-01-06"
# Returns: 34
age_from_date() {
    [[ $# -eq 1 ]] || return 1
    local birthdate="$1"
    local birth_ts=$(date_to_timestamp "$birthdate")
    local current_ts=$EPOCHSECONDS

    [[ -z "$birth_ts" ]] && return 1

    local diff_days=$(days_between $birth_ts $current_ts)
    local age=$(( diff_days / 365 ))

    print $age
}

# Get start of day timestamp (00:00:00)
# Usage: start_of_day [timestamp]
# Returns: timestamp for start of day
start_of_day() {
    local ts=${1:-$EPOCHSECONDS}
    local date_str=$(strftime "%Y-%m-%d" $ts)

    date_to_timestamp "$date_str"
}

# Get end of day timestamp (23:59:59)
# Usage: end_of_day [timestamp]
# Returns: timestamp for end of day
end_of_day() {
    local ts=${1:-$EPOCHSECONDS}
    local start_ts=$(start_of_day $ts)

    print $(( start_ts + 86399 ))
}

# Get start of week timestamp (Monday 00:00:00)
# Usage: start_of_week [timestamp]
# Returns: timestamp for start of week
start_of_week() {
    local ts=${1:-$EPOCHSECONDS}
    local dow=$(strftime "%u" $ts)  # 1=Monday, 7=Sunday
    local days_back=$(( dow - 1 ))
    local week_start=$(( ts - (days_back * 86400) ))

    start_of_day $week_start
}

# Get start of month timestamp
# Usage: start_of_month [timestamp]
# Returns: timestamp for start of month
start_of_month() {
    local ts=${1:-$EPOCHSECONDS}
    local year=$(strftime "%Y" $ts)
    local month=$(strftime "%m" $ts)

    date_to_timestamp "$year-$month-01"
}

# Get start of year timestamp
# Usage: start_of_year [timestamp]
# Returns: timestamp for start of year
start_of_year() {
    local ts=${1:-$EPOCHSECONDS}
    local year=$(strftime "%Y" $ts)

    date_to_timestamp "$year-01-01"
}

# Check if date is today
# Usage: is_today 1704556800
# Returns: 0 (true) or 1 (false)
is_today() {
    [[ $# -eq 1 ]] || return 1
    local ts=$1
    local today_start=$(start_of_day $EPOCHSECONDS)
    local today_end=$(end_of_day $EPOCHSECONDS)

    (( ts >= today_start && ts <= today_end ))
}

# Check if date is in the past
# Usage: is_past 1704556800
# Returns: 0 (true) or 1 (false)
is_past() {
    [[ $# -eq 1 ]] || return 1
    local ts=$1

    (( ts < EPOCHSECONDS ))
}

# Check if date is in the future
# Usage: is_future 1704556800
# Returns: 0 (true) or 1 (false)
is_future() {
    [[ $# -eq 1 ]] || return 1
    local ts=$1

    (( ts > EPOCHSECONDS ))
}

# Get relative time description
# Usage: relative_time 1704556800
# Returns: "2 hours ago" or "in 3 days"
relative_time() {
    [[ $# -eq 1 ]] || return 1
    local ts=$1
    local now=$EPOCHSECONDS
    local diff=$(( now - ts ))
    local abs_diff=${diff#-}

    local result=""

    if (( abs_diff < 60 )); then
        result="just now"
    elif (( abs_diff < 3600 )); then
        local mins=$(( abs_diff / 60 ))
        result="$mins minute"
        (( mins > 1 )) && result="${result}s"
    elif (( abs_diff < 86400 )); then
        local hours=$(( abs_diff / 3600 ))
        result="$hours hour"
        (( hours > 1 )) && result="${result}s"
    elif (( abs_diff < 604800 )); then
        local days=$(( abs_diff / 86400 ))
        result="$days day"
        (( days > 1 )) && result="${result}s"
    elif (( abs_diff < 2592000 )); then
        local weeks=$(( abs_diff / 604800 ))
        result="$weeks week"
        (( weeks > 1 )) && result="${result}s"
    elif (( abs_diff < 31536000 )); then
        local months=$(( abs_diff / 2592000 ))
        result="$month month"
        (( months > 1 )) && result="${result}s"
    else
        local years=$(( abs_diff / 31536000 ))
        result="$years year"
        (( years > 1 )) && result="${result}s"
    fi

    if (( diff < 0 )); then
        print "in $result"
    else
        print "$result ago"
    fi
}

# Get quarter of year (1-4)
# Usage: get_quarter [timestamp]
# Returns: 1, 2, 3, or 4
get_quarter() {
    local ts=${1:-$EPOCHSECONDS}
    local month=$(strftime "%m" $ts)

    if (( month <= 3 )); then
        print 1
    elif (( month <= 6 )); then
        print 2
    elif (( month <= 9 )); then
        print 3
    else
        print 4
    fi
}

# Get week number of year
# Usage: get_week_number [timestamp]
# Returns: 1-53
get_week_number() {
    local ts=${1:-$EPOCHSECONDS}
    print "$(strftime "%V" $ts)"
}

# Get day of year
# Usage: get_day_of_year [timestamp]
# Returns: 1-366
get_day_of_year() {
    local ts=${1:-$EPOCHSECONDS}
    print "$(strftime "%j" $ts)"
}

# shell files tracking - keep at the end
zfile_track_end ${0:A}
