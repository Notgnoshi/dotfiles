#!/bin/bash
# shellcheck disable=SC1090

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Add ~/.local/bin/ to PATH
export PATH="$HOME/.local/bin${PATH:+:${PATH}}"

if [[ -z "$TMUX" ]]; then
    # Find the first non-scratch session, if any. The scratch session is ephemeral and gets killed
    # when its parent session closes so it should never be the target.
    target="$(tmux list-sessions -F '#S' -f '#{?#{==:#S,scratch},0,1}' 2>/dev/null | head -1)"
    if [[ -n "$target" ]]; then
        tmux attach-session -t "$target"
    else
        tmux new-session
    fi
    unset -v target
fi

##################################################################################################
# Find the location of the dotfiles repository by resolving the ~/.bashrc symlink.
##################################################################################################
SOURCE="${BASH_SOURCE[0]}"
# resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE" ]; do
    DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DOTFILES_DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)/.."
DOTFILES_DIR="$(readlink --canonicalize --no-newline "${DOTFILES_DIR}")"
export DOTFILES_DIR
unset -v DIR
unset -v SOURCE

##################################################################################################
# Source each of components in alphabetical order.
# This is where most of the customizations come from.
##################################################################################################
for rcfile in "${DOTFILES_DIR}/bashrc.d/"*.sh; do
    [ -f "$rcfile" ] && source "$rcfile"
done
unset -v rcfile
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.cargo/env ] && source ~/.cargo/env

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
