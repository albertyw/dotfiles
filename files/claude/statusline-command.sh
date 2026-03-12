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

printf "${blue}%s${reset} | ${yellow}%s${reset} | ${red}%s${reset} | ${blue}%s${reset} | %s\n" \
    "$model" "$context_str" "$cost" "$git_str" "$cwd"
