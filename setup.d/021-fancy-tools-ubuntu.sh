#!/bin/bash
if prompt_default_no "Install bat, fd-find, jq ripgrep?"; then
    # workaround https://bugs.launchpad.net/ubuntu/+source/rust-bat/+bug/1868517
    sudo apt install -o Dpkg::Options::="--force-overwrite" bat fd-find jq ripgrep
    # Make symlinks so that we can use their canonical names from scripts
    ln -s "$(which fdfind)" ~/.local/bin/fd || true
    ln -s "$(which batcat)" ~/.local/bin/bat || true
fi
