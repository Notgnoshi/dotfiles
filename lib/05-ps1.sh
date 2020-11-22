#!/bin/bash

##################################################################################################
# PS1 Customization
##################################################################################################

# Prints different escape codes to stdout indicating the exit code of the previous command
# Colors are provided by $DOTFILES_DIR/lib/colors.sh
function __decorate_exit_status() {
    if [ $? -eq 0 ]; then
        echo -en "${WHITE}"
    else
        echo -en "${BOLD}${RED}"
    fi
}

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

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

# Test whether the given function exists.
function function_exists() {
    declare -f -F "$1" >/dev/null
    return $?
}

# Set the base $PS1
PS1="\u@\h \[${GREEN}\]\w"
# If connected over SSH, prepend a red (ssh) to the $PS1
if __is_ssh; then
    PS1="\[${BOLD}${RED}\](\[${RESET}${RED}\]ssh\[${BOLD}\]) \[${RESET}\]${PS1}"
fi
# Decorate PS1 with git branch, rebase, cherry-pick state.
if function_exists __git_ps1; then
    PS1="${PS1}\[${BLUE}\]\$(__git_ps1)\[${RESET}\]"
fi
# Append a colored $ to the end of the $PS1 indicating the exit code
PS1="${PS1} \[${WHITE}\]\[\$(__decorate_exit_status)\]\$\[${RESET}\] "
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
    # Prepends title thingy to $PS1
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*) ;;
esac
