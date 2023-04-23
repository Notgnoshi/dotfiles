#!/bin/bash
if prompt_default_no "Install base system packages?"; then

    PACKAGES=(
        ca-certificates
        colordiff
        curl
        dos2unix
        git
        htop
        iperf
        make
        moreutils
        net-tools
        nmap
        openssh-server
        openssl
        pv
        screen
        screenfetch
        stow
        traceroute
        tree
        vim-gtk
        wl-clipboard
    )

    sudo apt install -y --no-install-recommends "${PACKAGES[@]}"
    sudo snap install poke
fi
