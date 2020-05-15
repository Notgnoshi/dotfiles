#!/bin/bash

# Browse git log
fzf-git-browse() {
    # Ignore tags, and ignore branches prefixed with save/ or trash/
    git log \
        --graph \
        --exclude='save/*' \
        --exclude='trash/*' \
        --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%an, %cr" \
        --decorate=short \
        --decorate-refs-exclude='refs/tags/*' \
        "$@" |
        fzf \
            --no-mouse \
            --ansi \
            --no-sort \
            --reverse \
            --exit-0 \
            --preview "echo {} \
                | grep -o '[a-f0-9]\{7,\}' \
                | head -1 \
                | xargs -I % sh -c 'git show --color=always %' \
                | perl /usr/share/doc/git/contrib/diff-highlight/diff-highlight" \
            --bind "enter:execute(
                echo {} \
                    | grep -o '[a-f0-9]\{7,\}' \
                    | head -1 \
                    | xargs -I % sh -c 'git show --color=always %' \
                    | perl /usr/share/doc/git/contrib/diff-highlight/diff-highlight \
                    | LESS=RX less \
                )" \
            --bind "ctrl-y:execute(
                echo {} \
                    | grep -o '[a-f0-9]\{7,\}' \
                    | head -1 \
                    | xargs -I % sh -c \
                        'git checkout %' \
                )+abort" \
            --bind "ctrl-h:execute(
                echo {} \
                    | grep -o '[a-f0-9]\{7,\}' \
                    | head -1 \
                    | tr -d '\n' \
                    | xclip -selection clipboard \
                )+abort" \
            --bind "ctrl-r:execute(
                echo {} \
                    | grep -o '[a-f0-9]\{7,\}' \
                    | head -1 \
                    | tr -d '\n' \
                    | xargs -oI % git rebase --interactive --autosquash %~ \
                )+abort"
    # Do not register a user exit of fzf as an error.
    if [ $? -eq 130 ]; then
        true
    fi
}
