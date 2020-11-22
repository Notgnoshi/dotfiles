#!/bin/bash

##################################################################################################
# Environment variables
##################################################################################################

# fzf settings
export FZF_DEFAULT_OPTS="--history-size=100000"
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 60'"
export FZF_CTRL_T_OPTS="--preview 'bat --style changes --color=always --line-range :60 {}'"

# Some customizations for __git_ps1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_DESCRIBE_STYLE='branch'
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM='auto'

# Add ~/.local/bin/ to PATH
PATH="$HOME/.local/bin${PATH:+:${PATH}}"

# Add local manpages, but be sure to not overwrite the defaults
MANPATH="$(manpath --quiet)"
MANPATH="$HOME/.local/man${MANPATH:+:${MANPATH}}"
MANPATH="$HOME/.local/share/man${MANPATH:+:${MANPATH}}"

# Add the user-defined CUDA installation to paths.
# The default CUDA installation directory is /usr/local/cuda-xx.y/. But if there are multiple installations
# available, symlink the desired installation to ~/.local/cuda/.
PATH="$HOME/.local/cuda/bin${PATH:+:${PATH}}"
LIBRARY_PATH="$HOME/.local/cuda/lib64${LIBRARY_PATH:+:${LIBRARY_PATH}}"

# Add local header files to gcc include path
CPATH="$HOME/.local/include${CPATH:+:${CPATH}}"

# Add local libraries to library path.
LIBRARY_PATH="$HOME/.local/lib${LIBRARY_PATH:+:${LIBRARY_PATH}}"

# Setting LIBRARY_PATH is for linking, setting LD_LIBRARY_PATH is for running
LD_LIBRARY_PATH="$LIBRARY_PATH"

export PATH
export CPATH
export LIBRARY_PATH
export LD_LIBRARY_PATH
export MANPATH
export EDITOR=vim
export BAT_THEME=base16
# Path to my vimwiki clone
export VIMWIKI_PATH="$HOME/Documents/notes/"
# Fix less not rendering control characters with git-log on the Opp lab machines.
export LESS=FRX

# Use parallel make by default
export MAKEFLAGS="-j$(nproc)"
