#!/bin/bash

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
    if [ ! -d ~/.bash_completion.d ]; then
        mkdir -p ~/.bash_completion.d
    fi
    for completion_file in ~/.bash_completion.d/*; do
        [ -f "$completion_file" ] && source "$completion_file"
    done
    # Find and source clang bash completion scripts
    for f in $(find /usr/lib -name 'bash-autocomplete.sh'); do
        source "$f"
    done
fi
