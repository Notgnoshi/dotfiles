#!/bin/bash

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

##################################################################################################
# Environment variables
##################################################################################################

# fzf settings
export FZF_DEFAULT_OPTS="--history-size=100000"
# Don't ignore files in Vim with C-f-f. You can get git ls-files with C-f-g.
export FZF_DEFAULT_COMMAND="fd --type f --no-ignore"
# But still make C-t from the shell ignore ignored files.
export FZF_CTRL_T_COMMAND="fd --type f"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 60'"
export FZF_CTRL_T_OPTS="--preview 'bat --style changes --color=always --line-range :60 {}'"

# Add ~/.local/bin/ to PATH
PATH="$HOME/.local/bin${PATH:+:${PATH}}"

# Add local manpages, but be sure to not overwrite the defaults
MANPATH="$(manpath --quiet)"
MANPATH="$HOME/.local/man${MANPATH:+:${MANPATH}}"
MANPATH="$HOME/.local/share/man${MANPATH:+:${MANPATH}}"
# Use vim as my MANPAGER. Has folding, ability to follow links.
MANPAGER="vim -M +MANPAGER -"
MANWIDTH=100

# Add local header files to gcc include path
C_INCLUDE_PATH="$HOME/.local/include${C_INCLUDE_PATH:+:${C_INCLUDE_PATH}}"
CPLUS_INCLUDE_PATH="$HOME/.local/include${CPLUS_INCLUDE_PATH:+:${CPLUS_INCLUDE_PATH}}"

# Add local libraries to library path.
LIBRARY_PATH="$HOME/.local/lib${LIBRARY_PATH:+:${LIBRARY_PATH}}"

# Setting LIBRARY_PATH is for linking, setting LD_LIBRARY_PATH is for running
LD_LIBRARY_PATH="$LIBRARY_PATH"

export PATH
export C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH
export LIBRARY_PATH
export LD_LIBRARY_PATH
export MANPATH
export MANPAGER
export MANWIDTH
export EDITOR=vim
export BAT_THEME=base16
# Path to my vimwiki clone
export VIMWIKI_PATH="$HOME/Documents/notes/"
# Fix less not rendering control characters with git-log on the Opp lab machines.
export LESS=FRX

# Use parallel make by default
PROCS=$(( $(nproc) - 1 ))
export MAKEFLAGS="-j$PROCS"
