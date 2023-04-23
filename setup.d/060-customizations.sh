#!/bin/bash
if prompt_default_no "Install Gnome extensions?"; then
    EXTENSIONS=(
        https://extensions.gnome.org/extension/3724/net-speed-simplified/
        https://extensions.gnome.org/extension/1319/gsconnect/
    )

    info "Opening extensions..."
    for extension in "${EXTENSIONS[@]}"; do
        xdg-open "$extension"
    done
fi

if prompt_default_no "Install multi-monitors-add-on fork?"; then
    error "The https://github.com/realh/multi-monitors-add-on/ fork doesn't work for Gnome 44"
    # git clone https://github.com/realh/multi-monitors-add-on.git ~/src/multi-monitors-add-on/
    # pushd ~/src/multi-monitors-add-on/ || exit 1
    # cp -r multi-monitors-add-on@spin83 ~/.local/share/gnome-shell/extensions/
    # popd || exit 1
fi

if prompt_default_no "Install Pointfree font?"; then
    # https://docs.fedoraproject.org/en-US/quick-docs/fonts/
    mkdir -p ~/.local/share/fonts
    curl --location --output /tmp/pointfree.zip "https://dl.dafont.com/dl/?f=pointfree"
    unzip -d /tmp/ /tmp/pointfree.zip
    mkdir -p ~/.local/share/fonts/
    mv /tmp/pointfree.ttf ~/.local/share/fonts/

    # When I was testing this, I had to restart my session for it to take effect.
    sudo fc-cache -f -v
    gsettings set org.gnome.desktop.interface monospace-font-name 'Pointfree 11'
fi

if prompt_default_no "Configure system settings?"; then
    gsettings set org.gnome.desktop.datetime automatic-timezone true
    gsettings set org.gnome.desktop.wm.preferences focus-mode 'sloppy'
    gsettings set org.gnome.desktop.interface clock-format '12h'
    gsettings set org.gnome.desktop.notifications show-in-lock-screen false
    # Who in their right mind uses natural scrolling?
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
    gsettings set org.gnome.desktop.privacy remember-recent-files false
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
    gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled true
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
    gsettings set org.gnome.desktop.interface clock-show-weekday true
    gsettings set org.gnome.mutter attach-modal-dialogs false
    gsettings set org.gnome.mutter center-new-windows true
    gsettings set org.gnome.mutter dynamic-workspaces false
    gsettings set org.gnome.mutter workspaces-only-on-primary false
fi

if prompt_default_no "Install/update HeadsetControl?"; then
    if [[ -d ~/src/HeadesetControl/ ]]; then
        pushd ~/src/HeadsetControl/ || exit 1
        git pull
    else
        git clone https://github.com/Sapd/HeadsetControl.git ~/src/HeadsetControl/
        pushd ~/src/HeadsetControl/ || exit 1
    fi

    cmake -B build/
    cmake --build build/
    pushd ~/src/HeadsetControl/build/ || exit 1
    sudo make install
    sudo udevadm control --reload-rules && sudo udevadm trigger
    popd || exit 1
    popd || exit 1
fi
