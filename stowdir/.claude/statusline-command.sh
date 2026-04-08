#!/bin/bash
input=$(cat)

GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
display_cwd="${cwd/#$HOME/\~}"
model=$(echo "$input" | jq -r '.model.display_name // empty')
model="${model% (*}" # strip parenthesized context size
effort=$(echo "$input" | jq -r '.effort_level // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

base="${GREEN}${display_cwd}${RESET}"

# git info via __git_ps1 if available, otherwise fall back to symbolic-ref
# Ubuntu 24.04: /usr/lib/git-core/git-sh-prompt
# Fedora 43+:  /usr/share/git-core/contrib/completion/git-prompt.sh
source /usr/lib/git-core/git-sh-prompt 2>/dev/null ||
    source /usr/share/git-core/contrib/completion/git-prompt.sh 2>/dev/null

git_info=""
if type __git_ps1 &>/dev/null; then
    # These GIT_PS1_* variables can be overridden per-repo with git config to disable expensive checks
    # in large repositories:
    #
    #   git config bash.showDirtyState false       # skips git diff
    #   git config bash.showUntrackedFiles false   # skips git ls-files (biggest win in large repos)
    #   git config bash.showUpstream false         # skips ahead/behind calculation
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_DESCRIBE_STYLE='branch'
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM='auto'
    export GIT_PS1_SHOWCONFLICTSTATE='yes'
    git_info="$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" rev-parse --is-inside-work-tree &>/dev/null &&
        cd "$cwd" && __git_ps1 " ${BLUE}(%s)${RESET}")"
elif git_branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null); then
    git_info=" ${BLUE}(${git_branch})${RESET}"
elif git_desc=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" describe --tags --exact-match HEAD 2>/dev/null); then
    git_info=" ${BLUE}(${git_desc})${RESET}"
fi

# model info as key:value pairs on a second line
parts=()
[ -n "$model" ] && parts+=("${YELLOW}model: ${model}${RESET}")
[ -n "$effort" ] && parts+=("${YELLOW}effort: ${effort}${RESET}")
[ -n "$used_pct" ] && parts+=("ctx: ${used_pct}%")
[ -n "$five_hour" ] && parts+=("${RED}5h: $(printf '%.0f' "$five_hour")%${RESET}")
[ -n "$seven_day" ] && parts+=("${RED}7d: $(printf '%.0f' "$seven_day")%${RESET}")

printf "%s%s" "$base" "$git_info"
if [ ${#parts[@]} -gt 0 ]; then
    printf "\n%s" "$(
        IFS='  '
        echo "${parts[*]}"
    )"
fi
