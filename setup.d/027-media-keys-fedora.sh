#!/bin/bash

# For now, only set these up on Fedora, because all these do is configure <Ctrl><Alt><T> to open the
# terminal, which is already configured on Ubuntu.
if prompt_default_no "Setup custom keybinds?"; then
    MEDIA_KEYS="$DOTFILES_SETUP_SCRIPT_DIR/dconf/media-keys.dconf"
    if [[ ! -f "$MEDIA_KEYS.bak" ]]; then
        dconf dump /org/gnome/settings-daemon/plugins/media-keys/ >"$MEDIA_KEYS.bak"

        debug "custom-keybindings original value:" "$(cat "$MEDIA_KEYS.bak")"
    fi
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ <"$MEDIA_KEYS"
fi

