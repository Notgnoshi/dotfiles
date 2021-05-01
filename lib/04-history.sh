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
