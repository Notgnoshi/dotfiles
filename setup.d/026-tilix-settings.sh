#!/bin/bash
TILIX_SETTINGS="$DOTFILES_SETUP_SCRIPT_DIR/dconf/tilix.dconf"
if prompt_default_no "Overwrite Tilix settings?"; then
    if [[ ! -f "$TILIX_SETTINGS.bak" ]]; then
        dconf dump /com/gexperts/Tilix/ >"$TILIX_SETTINGS.bak"
    fi
    dconf load /com/gexperts/Tilix <"$TILIX_SETTINGS"
elif prompt_default_no "Update saved Tilix settings with current values?"; then
    dconf dump /com/gexperts/Tilix/ >"$TILIX_SETTINGS"
fi
