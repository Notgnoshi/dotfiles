#!/bin/bash

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias tree='tree -C'

alias ls='ls -h --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias back="cd -"
alias xo='xdg-open'

alias upd='sudo apt update'
alias upg='sudo apt upgrade'
alias acl='sudo apt-get autoclean'
alias arem='sudo apt-get autoremove'

alias wiki='vim $VIMWIKI_PATH/index.wiki'
alias todo='vim $VIMWIKI_PATH/todo/todo.wiki'

function man() {
    # Export the variables in a subshell to avoid polluting
    # the global environment in unexpected ways.
    (
        export LESS_TERMCAP_mb="$(printf "\e[1;31m")"
        export LESS_TERMCAP_md="$(printf "\e[1;31m")"
        export LESS_TERMCAP_me="$(printf "\e[0m")"
        export LESS_TERMCAP_se="$(printf "\e[0m")"
        export LESS_TERMCAP_so="$(printf "\e[1;44;33m")"
        export LESS_TERMCAP_ue="$(printf "\e[0m")"
        export LESS_TERMCAP_us="$(printf "\e[1;32m")"

        case "$(type -t -- "$1")" in
        # Use `help -m` to generate a manpage for any bash builtins or keywords
        builtin | keyword)
            # Unfortunately the generated manpages are missing the metadata
            # needed for less to highlight using the LESS_TERMCAP variables above.
            help -m "$1" | less
            ;;
        # Use the system manpages for everything else
        *)
            command man "$@"
            ;;
        esac
    )
}
