#!/bin/bash

# Taken from https://stackoverflow.com/questions/47781631/how-to-auto-complete-a-multi-level-command-aliased-to-a-single-command
# and modified to pass the --repo --tag --id arguments to __docker_complete_images, because
# otherwise the completion results would include stuff like the image size...
_docker_cwd() {
    local previous_extglob_setting
    previous_extglob_setting=$(shopt -p extglob)
    shopt -s extglob

    _get_comp_words_by_ref -n : cur prev words cword

    # TODO: Include other "docker run" arguments
    # Unfortunately /usr/share/bash-completion/completions/docker is a bit hard to follow, so it's
    # not entirely obvious how to do this.
    declare -F __docker_complete_images >/dev/null && __docker_complete_images --repo --tag --id

    eval "$previous_extglob_setting"
    return 0
}

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
    # # Find and source clang bash completion scripts
    # for f in $(find /usr/lib -name 'bash-autocomplete.sh'); do
    #     source "$f"
    # done

    if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
        source /usr/share/git-core/contrib/completion/git-prompt.sh
    fi
    if [ -f /usr/share/bash-completion/completions/docker ]; then
        source /usr/share/bash-completion/completions/docker
        complete -F _docker_cwd docker-cwd
    fi
fi
