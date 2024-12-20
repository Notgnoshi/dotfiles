#!/bin/bash

# go up n levels
up() {
    local -r TMP=$PWD
    local -r LEVELS=${1:-1}
    for _ in $(seq "$LEVELS"); do
        cd ..
    done
    # $OLDPWD allows for `cd -`
    export OLDPWD=$TMP
}

# View a random man page
randman() {
    man "$(ls -1 /usr/share/man/man?/ | shuf -n1 | cut -d. -f1)"
}

# attempt to rhyme the given word
rhyme() {
    {
        cat /usr/share/dict/words
        printf %s\\n "$1"
    } | rev | sort | rev | grep -FxC15 -e "${1?}" | grep -Fxve "$1" | shuf -n1
}

# grabs the local IP
localip() {
    ip -4 -br -c a show
}

# grabs the external IP
publicip() {
    echo "public IP:"
    echo ""
    curl -s 'ipecho.net/plain'
    echo ""
}

# sorts directories by size
dsort() {
    du -a -d 1 -h | sort -h
}

# Gives number of additions author has made in current git repo
additions() {
    git log --author="$*" --pretty=tformat: --numstat |
        awk '{ add += $1; subs += $2; loc += $1 - $2 } END                    \
             { printf "added lines: %s removed lines: %s total lines: %s\n", add, subs, loc }' -
}

# Remove the given item from your $PATH.
remove-path() {
    local entry="$1"
    entry="$(readlink -f "$entry")"

    if [[ ":$PATH:" == *":$entry:"* ]]; then
        local intermediate=":$PATH:"
        intermediate="${intermediate//:/::}"
        intermediate="${intermediate//:"$entry:"/}"
        intermediate="${intermediate//::/:}"
        intermediate="${intermediate#:}"
        intermediate="${intermediate%:}"
        export PATH="$intermediate"
        echo "$PATH" >&2
    else
        echo "'$entry' not found in PATH: '$PATH'" >&2
        return 1
    fi
}

# Append the given item to the end of your $PATH
append-path() {
    local entry="$1"
    entry="$(readlink -f "$entry")"

    if [[ ":$PATH:" == *":$entry:"* ]]; then
        echo "'$entry' already in PATH: '$PATH'" >&2
        return 1
    fi

    export PATH="$PATH:$entry"
    echo "$PATH" >&2
}

# Prepend the given item to the beginning of your $PATH
prepend-path() {
    local entry="$1"
    entry="$(readlink -f "$entry")"

    if [[ ":$PATH:" == *":$entry:"* ]]; then
        echo "'$entry' already in PATH: '$PATH'" >&2
        return 1
    fi

    export PATH="$entry:$PATH"
    echo "$PATH" >&2
}

# Search for, preview, and open man pages
fman() {
    man -k . |
        fzf -q "$1" --prompt='Man> ' --preview $'echo {} | tr -d \'()\' | awk \'{printf "%s ", $2} {print $1}\' | xargs -r man | col -bx | bat -l man -p --color always' |
        tr -d '()' |
        awk '{printf "%s ", $2} {print $1}' |
        xargs -r man
}

shellquote() {
    printf '%q' "$(cat)"
    echo
}
