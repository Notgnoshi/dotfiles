#!/bin/bash

##################################################################################################
# History settings
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# NOTE: these settings can have undesirable effects with older bash versions.
##################################################################################################
HISTSIZE=-1
# Save all history
HISTFILESIZE=-1
HISTTIMEFORMAT="%h %d %H:%M:%S "
shopt -s histappend

##################################################################################################
# I keep having problems with my ~/.bash_history getting wiped, so instead of fixing the problem, provide a way to recover.
# Unfortunately, I don't know of a nice way to find new commands and automatically append them to a canonical backup.
# So rely on manual intervention in the case something bad happens.
##################################################################################################
function __backup_histfile() {
    if [ -f ~/.histlogs/logrotate.conf ]; then
        # Make a backup every time a shell is opened.
        logrotate --force --state ~/.histlogs/logrotate.status ~/.histlogs/logrotate.conf

        latest=$(find ~/.histlogs/ -name "${HISTFILE##*/}.*" | sort -n -t . -k 3 | head -1)
        # Complain loudly if $HISTFILE is smaller than the latest backup.
        if [ ! -f "$latest" ] || [ ! -f "$HISTFILE" ] || [ "$(wc -l <"$HISTFILE")" -lt "$(wc -l <"$latest")" ]; then
            echo "${RED}${BOLD}Something horrible has happened to ${WHITE}${HISTFILE}${RED}...${RESET}"
            wc -l "$HISTFILE" "$latest"
        fi
    fi
}

__backup_histfile
