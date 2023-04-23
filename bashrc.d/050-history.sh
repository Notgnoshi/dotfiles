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
# Append (not overwrite) to the HISTFILE on session exit.
shopt -s histappend

# Doesn't matter when using FZF, but useful for vanilla readline
shopt -s histreedit
shopt -s histverify

# After each command, append, clear, and reload history.
# This allows sharing history between concurrent sessions.
# https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r;"
