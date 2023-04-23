#!/bin/bash

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

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

[ -f ~/.cargo/env ] && source ~/.cargo/env
##################################################################################################
# Source each of components in alphabetical order.
# This is where most of the customizations come from.
##################################################################################################
for rcfile in "${DOTFILES_DIR}/bashrc.d/"*.sh; do
    [ -f "$rcfile" ] && source "$rcfile"
done

# Enable fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
