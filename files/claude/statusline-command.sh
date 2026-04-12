#!/usr/bin/env bash

input=$(cat)

blue='\e[1;34m'
red='\e[1;31m'
yellow='\e[1;33m'
reset='\e[0m'

cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')

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

# Git lines added/removed from Claude Code's cost tracking
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
git_str="+${lines_added}/-${lines_removed}"

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

if [ -n "$rate_parts" ]; then
    printf "${blue}%s${reset} | ${yellow}%s${reset} | ${red}%s${reset} | ${blue}%s${reset} | ${yellow}%s${reset} | %s\n" \
        "$model" "$context_str" "$cost" "$git_str" "$rate_parts" "$cwd"
else
    printf "${blue}%s${reset} | ${yellow}%s${reset} | ${red}%s${reset} | ${blue}%s${reset} | %s\n" \
        "$model" "$context_str" "$cost" "$git_str" "$cwd"
fi
