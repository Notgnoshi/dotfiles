#!/bin/bash

# go up n levels
up() {
    TMP=$PWD
    LEVELS=${1:-1}
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

# Generate a random password al la XKCD
randpass() {
    sort -R /usr/share/dict/words |
        head -n ${1:-4} |
        awk '{ sub(".", substr(toupper($0),1,1)); printf "%s", $0 }' \
        ;
    echo
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
    echo "local IP(s):"
    echo ""
    # ifconfig | perl -nle'/dr:(\S+)/ && print $1'
    echo "local IP: $(hostname -I)"
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
remove-from-path() {
    export PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//')
}

# Search for, preview, and open man pages
fman() {
    man -k . |
        fzf -q "$1" --prompt='Man> ' --preview $'echo {} | tr -d \'()\' | awk \'{printf "%s ", $2} {print $1}\' | xargs -r man | col -bx | bat -l man -p --color always' |
        tr -d '()' |
        awk '{printf "%s ", $2} {print $1}' |
        xargs -r man
}

plog() {
    # Log stdin to stdout AND stderr, but prefix stderr with an identifying tag.
    # Taken from https://raimonster.com/scripting-field-guide/#org92f4850
    local log_prefix="${1:-plog}"
    tee >(sed -e "s/^/[$log_prefix] /" 1>&2)
}

shellquote () {
  printf '%q' "$(cat)"
  echo
}
