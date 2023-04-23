#!/bin/bash
if prompt_default_no "Install base system packages?"; then

    # https://docs.fedoraproject.org/en-US/quick-docs/setup_rpmfusion/
    sudo dnf --assumeyes install \
        "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    sudo dnf --assumeyes install \
        "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

    dnf check-update

    PACKAGES=(
        ca-certificates
        colordiff
        curl
        dnf-plugins-core
        dos2unix
        flatpak
        git
        htop
        iperf
        make
        moreutils
        net-tools
        nmap
        openssh-server
        openssl
        poke
        poke-vim
        pv
        screen
        screenfetch
        stow
        traceroute
        tree
        vim-X11
        wl-clipboard
    )

    sudo dnf --assumeyes install "${PACKAGES[@]}"

    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi
