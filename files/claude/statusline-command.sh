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

# Rate limits: 5-hour (daily) and 7-day (weekly)
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
rate_parts=""
if [ -n "$five_hour" ]; then
    rate_parts="1d:$(printf '%.0f' "$five_hour")%"
fi
if [ -n "$seven_day" ]; then
    weekly_str="7d:$(printf '%.0f' "$seven_day")%"
    if [ -n "$rate_parts" ]; then
        rate_parts="$rate_parts $weekly_str"
    else
        rate_parts="$weekly_str"
    fi
fi

if [ -n "$rate_parts" ]; then
    printf "${blue}%s${reset} | ${yellow}%s${reset} | ${red}%s${reset} | ${blue}%s${reset} | ${yellow}%s${reset} | %s\n" \
        "$model" "$context_str" "$cost" "$git_str" "$rate_parts" "$cwd"
else
    printf "${blue}%s${reset} | ${yellow}%s${reset} | ${red}%s${reset} | ${blue}%s${reset} | %s\n" \
        "$model" "$context_str" "$cost" "$git_str" "$cwd"
fi
