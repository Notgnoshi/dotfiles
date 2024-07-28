##################################################################################################
# Set the base $PS1
##################################################################################################
PS1="\u@\h \[${GREEN}\]\w"

##################################################################################################
# Add a colored (VPN) to the beginning if VPN is running and connected
#
# VPN_GATEWAY should be set in a non-vcs tracked ./bashrc.d/ file to determine if the VPN is
# connected.
##################################################################################################
__vpn_connection_status() {
    local -r OLD_EXIT_STATUS=$?

    if [[ -z "$VPN_GATEWAY" ]]; then
        return $OLD_EXIT_STATUS
    fi

    # Check if there's a route to the gateway that goes through a 'tun' device
    if ip route get "$VPN_GATEWAY" | grep tun >/dev/null; then
        echo -en "${GREEN}"
    else
        echo -en "${RED}"
    fi
    return $OLD_EXIT_STATUS
}

__vpn_running() {
    local -r OLD_EXIT_STATUS=$?
    if pgrep openconnect >/dev/null; then
        echo -n "(VPN) "
    fi

    return $OLD_EXIT_STATUS
}
PS1="\[\$(__vpn_connection_status)\]\$(__vpn_running)\[${RESET}\]${PS1}"

##################################################################################################
# Indicate that your shell is polluted by a Yocto eSDK toolchain environment
##################################################################################################
__yocto_sysroot_ps1() {
    local -r OLD_EXIT_STATUS=$?
    if [[ -n "$OECORE_TARGET_SYSROOT" ]]; then
        echo -n "[$(basename "$OECORE_TARGET_SYSROOT")] "
    fi
    return $OLD_EXIT_STATUS
}
PS1="\[${YELLOW}\]\$(__yocto_sysroot_ps1)\[${RESET}\]${PS1}"

##################################################################################################
# If connected over SSH, prepend a red (ssh) to the $PS1
##################################################################################################
__is_ssh() {
    if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
        return 0
    else
        case $(ps -o comm= -p $PPID) in
        sshd | */sshd) return 0 ;;
        esac
    fi
    return 1
}
if __is_ssh; then
    PS1="\[${BOLD}${RED}\](\[${RESET}${RED}\]ssh\[${BOLD}\]) \[${RESET}\]${PS1}"
fi

##################################################################################################
# If connected over a serial port, prepend a red (serial) to the $PS1
##################################################################################################
__is_serial() {
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
if __is_serial; then
    PS1="\[${BOLD}${RED}\](\[${RESET}${RED}\]serial\[${BOLD}\]) \[${RESET}\]${PS1}"
fi

##################################################################################################
# Add the __git_ps1 from /usr/share/git-core/contrib/completion/git-prompt.sh
##################################################################################################
function_exists() {
    declare -f -F "$1" >/dev/null
    return $?
}

# See https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh for more details.
#
# Adds '*' and '+' for unstaged and staged changes
export GIT_PS1_SHOWDIRTYSTATE=1
# When in a detached head state, attempt to find the branch HEAD is on.
export GIT_PS1_DESCRIBE_STYLE='branch'
# Use colored output to indicate the current status
export GIT_PS1_SHOWCOLORHINTS=
# Show a '$' next to the branch name if something is stashed.
export GIT_PS1_SHOWSTASHSTATE=1
# Show a '%' next to the branch name if there are untracked files.
export GIT_PS1_SHOWUNTRACKEDFILES=1
# '=' means up to date with upstream, '<' means you're behind, and '>' means you're ahead. '<>' means you've diverged.
export GIT_PS1_SHOWUPSTREAM='auto'
# Add |CONFLICT markers if there are merge conflicts
export GIT_PS1_SHOWCONFLICTSTATE='yes'

if function_exists __git_ps1; then
    PS1="${PS1}\[${BLUE}\]\$(__git_ps1)\[${RESET}\]"
fi

##################################################################################################
# List the number of background jobs
##################################################################################################
__list_background_jobs() {
    local -r OLD_EXIT_STATUS=$?
    local -r NUM_BACKGROUND_JOBS=$(jobs | wc -l)
    if [[ "$NUM_BACKGROUND_JOBS" -gt 0 ]]; then
        echo -n " [$NUM_BACKGROUND_JOBS]"
    fi
    return $OLD_EXIT_STATUS
}
PS1="${PS1}\$(__list_background_jobs)"

##################################################################################################
# Color the $ sign based on the exit status of the last command
#
# Requires each of the \$(foo) functions that the PS1 invokes do not clobber the exit status:
#
#   OLD_EXIT_STATUS=$?
#   ...
#   return $OLD_EXIT_STATUS
##################################################################################################
__decorate_exit_status() {
    if [[ $? -eq 0 ]]; then
        echo -en "${WHITE}"
    else
        echo -en "${BOLD}${RED}"
    fi
}
PS1="${PS1} \[\$(__decorate_exit_status)\]\$\[${RESET}\] "

##################################################################################################
# Add the +side-by-side feature to delta when the terminal is wide enough
##################################################################################################
__delta_side_by_side_width() {
    local columns
    columns=$(tput cols)
    # Enough room for two side-by-side 80-char diffs with some room for line numbers to spare
    if [[ "$columns" -ge 170 ]]; then
        export DELTA_FEATURES="+side-by-side"
    else
        export DELTA_FEATURES=""
    fi
}
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}__delta_side_by_side_width"
