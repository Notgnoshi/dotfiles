#!/bin/bash
# shellcheck disable=SC1090

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Add ~/.local/bin/ to PATH
export PATH="$HOME/.local/bin${PATH:+:${PATH}}"
# Need to be sourced before everything else so that bash-completion works as expected.
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.cargo/env ] && source ~/.cargo/env

# TODO: Default session and layouts?
if [[ -z "$TMUX" ]]; then
    if ! tmux; then
        echo "Failed to start tmux"
    else
        echo "Exiting tmux..."
    fi
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

##################################################################################################
# Source each of components in alphabetical order.
# This is where most of the customizations come from.
##################################################################################################
for rcfile in "${DOTFILES_DIR}/bashrc.d/"*.sh; do
    [ -f "$rcfile" ] && source "$rcfile"
done
