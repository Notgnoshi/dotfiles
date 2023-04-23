#!/bin/bash
if prompt_default_no "Install Tilix?"; then
    sudo apt install tilix
    sudo update-alternatives --set x-terminal-emulator /usr/bin/tilix.wrapper
    # As per https://askubuntu.com/a/294430, nautilus uses a hard coded list of terminals.
    # The suggested "fix" of removing gnome-terminal and symlinking to tilix doesn't work
    # See https://bugzilla.gnome.org/show_bug.cgi?id=627943 for asinine WONTFIX justifications.
fi
