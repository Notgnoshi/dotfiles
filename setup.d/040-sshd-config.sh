#!/bin/bash
CONF=/etc/ssh/sshd_config.d/60-dotfiles.conf

if ! prompt_default_no "Allow ssh clients to set DOTFILES_DISABLE_TMUX when logging in?"; then
    return
fi
if [[ ! -d /etc/ssh/sshd_config.d ]]; then
    error "No /etc/ssh/sshd_config.d/"
    return 1
fi

sudo install --owner=root --group=root --mode=0644 "$DOTFILES_SETUP_SCRIPT_DIR/data/60-dotfiles.conf" "$CONF"

debug "Testing $CONF ..."
if ! sudo sshd -t; then
    error "$CONF broke the sshd config, removing it"
    sudo rm --force "$CONF"
    return 1
fi

if ! sudo sshd -T | grep --quiet --ignore-case DOTFILES_DISABLE_TMUX; then
    error "$CONF had no effect. Does /etc/ssh/sshd_config include sshd_config.d/*.conf?"
    return 1
fi

debug "Restarting sshd ..."
for unit in sshd.service ssh.service; do
    if systemctl is-active --quiet "$unit"; then
        sudo systemctl reload "$unit"
    fi
done
