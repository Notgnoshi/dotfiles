#!/bin/bash

##################################################################################################
# PS1 Customization
# Colors are provided by $DOTFILES_DIR/lib/01-colors.sh
##################################################################################################

# Set the base $PS1
PS1="\u@\h \[${GREEN}\]\w"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
    # Prepends title thingy to $PS1
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*) ;;
esac

# Indicate that your shell is polluted by a Yocto eSDK toolchain environment
function __yocto_sysroot_ps1() {
    OLD_EXIT_STATUS=$?
    if [ -n "$OECORE_TARGET_SYSROOT" ]; then
        echo -n "[$(basename "$OECORE_TARGET_SYSROOT")] "
    fi
    return $OLD_EXIT_STATUS
}
PS1="\[${YELLOW}\]\$(__yocto_sysroot_ps1)\[${RESET}\]${PS1}"

# Determine if connected over ssh.
function __is_ssh() {
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        return 0
    else
        case $(ps -o comm= -p $PPID) in
        sshd | */sshd) return 0 ;;
        esac
    fi
    return 1
}

# If connected over SSH, prepend a red (ssh) to the $PS1
if __is_ssh; then
    PS1="\[${BOLD}${RED}\](\[${RESET}${RED}\]ssh\[${BOLD}\]) \[${RESET}\]${PS1}"
fi

function __is_serial() {
    case "$(tty)" in
    /dev/tty[0-9])
        # local console
        return 1
        ;;
    /dev/tty[a-zA-Z]*[0-9])
        # serial console
        return 0
        ;;
    *)
        # Likely a /dev/pty/ pseudo terminal
        return 1
        ;;
    esac
}
# If connected over serial console, prepend a red (serial) to the $PS1
if __is_serial; then
    PS1="\[${BOLD}${RED}\](\[${RESET}${RED}\]serial\[${BOLD}\]) \[${RESET}\]${PS1}"
fi

# Test whether the given function exists.
function function_exists() {
    declare -f -F "$1" >/dev/null
    return $?
}

# Some customizations for __git_ps1
# See https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh for more details.
export GIT_PS1_SHOWDIRTYSTATE=1        # Adds '*' and '+' for unstaged and staged changes
export GIT_PS1_DESCRIBE_STYLE='branch' # When in a detached head state, attempt to find the branch HEAD is on.
export GIT_PS1_SHOWCOLORHINTS=1        # Use colored output to indicate the current status ('git status -sb'). Only works if __git_ps1 is used from PROMPT_COMMAND, not PS1.
export GIT_PS1_SHOWSTASHSTATE=1        # Show a '$' next to the branch name if something is stashed.
export GIT_PS1_SHOWUNTRACKEDFILES=1    # Show a '%' next to the branch name if there are untracked files.
export GIT_PS1_SHOWUPSTREAM='auto'     # '=' means up to date with upstream, '<' means you're behind, and '>' means you're ahead. '<>' means you've diverged.

# Decorate PS1 with git branch, rebase, cherry-pick state.
if function_exists __git_ps1; then
    PS1="${PS1}\[${BLUE}\]\$(__git_ps1)\[${RESET}\]"
fi

function __list_background_jobs() {
    OLD_EXIT_STATUS=$?
    NUM_BACKGROUND_JOBS=$(jobs | wc -l)
    if [ "$NUM_BACKGROUND_JOBS" -gt 0 ]; then
        echo -n " [$NUM_BACKGROUND_JOBS]"
    fi
    return $OLD_EXIT_STATUS
}

# Display how many background jobs there are, when there are background jobs
PS1="${PS1}\$(__list_background_jobs)"

# Prints different escape codes to stdout indicating the exit code of the previous command
function __decorate_exit_status() {
    if [ $? -eq 0 ]; then
        echo -en "${WHITE}"
    else
        echo -en "${BOLD}${RED}"
    fi
}

# Append a colored $ to the end of the $PS1 indicating the exit code
PS1="${PS1} \[\$(__decorate_exit_status)\]\$\[${RESET}\] "

__delta_side_by_side_width() {
    local columns=$(tput cols)
    # Enough room for two side-by-side 80-char diffs with some room for line numbers to spare
    if [ $columns -ge 170 ]; then
        export DELTA_FEATURES="+side-by-side"
    else
        export DELTA_FEATURES=""
    fi
}

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}__delta_side_by_side_width"
