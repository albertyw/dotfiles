#!/usr/bin/env bash

input=$(cat)

colors=('\e[1;34m' '\e[1;32m' '\e[1;35m' '\e[1;36m' '\e[1;33m' '\e[1;31m')
reset='\e[0m'
color_index=0
line=""

# Append a section in the next color of the cycle
add_section() {
    local color=${colors[color_index % ${#colors[@]}]}
    color_index=$((color_index + 1))
    line="${line:+$line | }$(printf '%b%s%b' "$color" "$1" "$reset")"
}

cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')

# Hostname (useful when working across multiple machines)
host_str=$(hostname -s 2>/dev/null)

# Current git branch (not present in the JSON payload; omit if not a repo or detached HEAD)
branch_str=$(cd "$cwd" 2>/dev/null && git --no-optional-locks branch --show-current 2>/dev/null)

# Thinking mode indicator
thinking=$(echo "$input" | jq -r '.thinking.enabled // false')
if [ "$thinking" = "true" ]; then
    model_str="$model [T]"
else
    model_str="$model"
fi

# Effort level (only when non-default, i.e. not "medium")
effort_level=$(echo "$input" | jq -r '.effort.level // empty')
if [ -n "$effort_level" ] && [ "$effort_level" != "medium" ]; then
    effort_str="effort:$effort_level"
else
    effort_str=""
fi

# Context window usage percentage
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used_pct" ]; then
    context_str=$(printf "%.0f%% ctx" "$used_pct")
else
    context_str="0% ctx"
fi

# Session cost from Claude Code's pre-calculated field
raw_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
if [ -n "$raw_cost" ]; then
    cost=$(printf "$%.4f" "$raw_cost")
else
    cost="$0.0000"
fi

# Format seconds into a human-readable countdown rounded to nearest hour (e.g. "2h" or "<1h")
format_countdown() {
    local secs=$1
    if [ "$secs" -le 0 ]; then
        echo "now"
        return
    fi
    local rounded_h=$(( (secs + 1800) / 3600 ))
    if [ "$rounded_h" -lt 1 ]; then
        printf "<1h"
    else
        printf "%dh" "$rounded_h"
    fi
}

# Rate limits: 5-hour (daily) and 7-day (weekly)
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
now=$(date +%s)
rate_parts=""
if [ -n "$five_hour" ]; then
    five_str="1d:$(printf '%.0f' "$five_hour")%"
    if [ -n "$five_hour_resets" ]; then
        remaining=$(( five_hour_resets - now ))
        five_str="$five_str($(format_countdown "$remaining"))"
    fi
    rate_parts="$five_str"
fi
if [ -n "$seven_day" ]; then
    week_str="7d:$(printf '%.0f' "$seven_day")%"
    if [ -n "$seven_day_resets" ]; then
        remaining=$(( seven_day_resets - now ))
        week_str="$week_str($(format_countdown "$remaining"))"
    fi
    if [ -n "$rate_parts" ]; then
        rate_parts="$rate_parts $week_str"
    else
        rate_parts="$week_str"
    fi
fi

add_section "$model_str"
[ -n "$host_str" ]   && add_section "$host_str"
[ -n "$effort_str" ] && add_section "$effort_str"
add_section "$context_str"
add_section "$cost"
[ -n "$rate_parts" ] && add_section "$rate_parts"
line="$line | $cwd"
[ -n "$branch_str" ] && add_section "$branch_str"
printf "%s\n" "$line"
