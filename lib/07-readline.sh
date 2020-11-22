#!/bin/bash

##################################################################################################
# Readline settings
##################################################################################################
# If tab complete is abimguous, show completions on first <TAB>, not second.
bind 'set show-all-if-ambiguous on'
# Cycle through completions with <TAB>.
bind 'TAB:menu-complete'
# Wait till second <TAB> to complete, list completions on first <TAB>.
bind 'set menu-complete-display-prefix on'
# Tab complete trailing slash for symlinked directories.
bind 'set mark-symlinked-directories on'
