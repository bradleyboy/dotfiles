#!/usr/bin/env bash
# Claude Code status line — pure-style prompt info + Claude context info

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')

# Identity: prefer devbox emoji+name if available, else user@host
if [ -f /pay/conf/box-emoji ] && [ -f /pay/conf/box-name ]; then
  box_emoji=$(cat /pay/conf/box-emoji)
  box_name=$(cat /pay/conf/box-name)
  identity="${box_emoji} ${box_name}"
else
  identity="$(whoami)@$(hostname -s)"
fi

# Shorten home directory to ~
short_cwd=$(echo "$cwd" | sed "s|^$HOME|~|")

# Git branch (skip optional locks)
git_branch=""
if git_branch_raw=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null); then
  git_branch="$git_branch_raw"
fi

model=$(echo "$input" | jq -r '.model.display_name // ""')

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Colors matching pure/tokyonight palette
RESET="\033[0m"
DIM="\033[2m"
BLUE="\033[38;2;122;162;247m"      # tokyonight blue (#7aa2f7)
PURPLE="\033[38;2;169;177;214m"    # pure git branch color (#a9b1d6)
MUTED="\033[38;2;86;95;137m"       # tokyonight comment (#565f89)
CYAN="\033[38;2;42;195;222m"       # tokyonight cyan (#2ac3de)

# Build the line
line=""

# identity (muted)
line+="$(printf "${DIM}${MUTED}%s${RESET}" "$identity")"

# directory (blue)
line+=" $(printf "${BLUE}%s${RESET}" "$short_cwd")"

# git branch (purple), if present
if [ -n "$git_branch" ]; then
  line+=" $(printf "${PURPLE}%s${RESET}" "$git_branch")"
fi

# separator
line+="$(printf " ${MUTED}|${RESET}")"

# model (cyan, shortened: strip "Claude " prefix and version suffix for brevity)
short_model=$(echo "$model" | sed 's/^Claude //' | sed 's/ [0-9]*\.[0-9]*$//')
line+=" $(printf "${CYAN}%s${RESET}" "$short_model")"

# context window usage, if available
if [ -n "$used_pct" ]; then
  used_int=$(printf '%.0f' "$used_pct")
  line+=" $(printf "${MUTED}ctx:%s%%${RESET}" "$used_int")"
fi

printf "%b\n" "$line"
