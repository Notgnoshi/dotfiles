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
        ncurses-term
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
    )

    sudo apt install -y --no-install-recommends "${PACKAGES[@]}"
fi
