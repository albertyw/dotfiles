#!/usr/bin/env bash

input=$(cat)

blue='\e[1;34m'
red='\e[1;31m'
yellow='\e[1;33m'
magentabackground='\e[1;45m'
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

# Git lines added/removed in the current working directory
git_diff=$(git -C "$cwd" diff --no-lock-index --shortstat HEAD 2>/dev/null)
if [ -n "$git_diff" ]; then
    added=$(echo "$git_diff" | grep -oP '\d+(?= insertion)' || echo "0")
    removed=$(echo "$git_diff" | grep -oP '\d+(?= deletion)' || echo "0")
    git_str="+${added}/-${removed}"
else
    git_str="+0/-0"
fi

printf "${blue}%s${reset} | ${yellow}%s${reset} | ${red}%s${reset} | ${blue}%s${reset} | %s\n" \
    "$model" "$context_str" "$cost" "$git_str" "$cwd"
