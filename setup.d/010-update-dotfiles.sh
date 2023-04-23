#!/bin/bash
if prompt_default_no "Install/update dotfiles?"; then
    if prompt_default_yes "Update Git submodules?"; then
        pushd "$DOTFILES_SETUP_SCRIPT_DIR" || exit 1
        git submodule update --init --recursive --remote
        popd || exit 1
    fi

    if prompt_default_yes "Deploy dotfiles?"; then
        stow --verbose=1 --dir="$DOTFILES_SETUP_SCRIPT_DIR" --target="$HOME" --restow dotfiles
        # Stow seems to ignore .gitignore, and I can't figure out how to force it, so do it by hand.
        if [[ ! -e "$HOME/.gitignore" ]]; then
            ln "$DOTFILES_SETUP_SCRIPT_DIR/dotfiles/.gitignore" "$HOME/.gitignore"
        fi
    elif prompt_default_no "Undeploy dotfiles?"; then
        stow --verbose=1 --dir="$DOTFILES_SETUP_SCRIPT_DIR" --target="$HOME" --delete dotfiles
        if [[ -L "$HOME/.gitignore" ]]; then
            rm "$HOME/.gitignore"
        fi
    fi
fi
