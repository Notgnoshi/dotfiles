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

# Test whether the given function exists.
function function_exists() {
    declare -f -F "$1" >/dev/null
    return $?
}

# Decorate PS1 with git branch, rebase, cherry-pick state.
# Further customized by $DOTFILES_DIR/lib/06-environment.sh
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
PS1="${PS1} \[${WHITE}\]\[\$(__decorate_exit_status)\]\$\[${RESET}\] "
