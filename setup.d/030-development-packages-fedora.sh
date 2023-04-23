#!/bin/bash
if prompt_default_no "Install native software development packages?"; then
    PACKAGES=(
        # TODO: On Fedora Bear actually tracks close to the upstream, but as of right now, there's
        # what looks like an important bugfix that isn't in the fedora package yet (3.1.2)
        bear
        boost
        clang
        clang-tools-extra
        cmake
        doxygen
        elfutils
        elfutils-debuginfod
        freeglut-devel
        g++
        gcc
        gdb
        gdb-gdbserver
        git-extras
        graphviz
        hidapi-devel
        iwyu
        kcachegrind
        lld
        lldb
        make
        meld
        optipng
        pandoc
        pkg-config
        python3-devel
        sqlite3
        sqlitebrowser
        valgrind
        zeromq
        zeromq-devel
        cppzmq-devel
    )

    sudo dnf --assumeyes install "${PACKAGES[@]}"
fi # Native

if prompt_default_no "Install Docker?"; then
    sudo dnf config-manager \
        --add-repo \
        https://download.docker.com/linux/fedora/docker-ce.repo
    # TODO: This repo only hasn't been fully updated for Fedora 38 yet.
    sudo dnf --assumeyes install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo groupadd --force docker
    sudo usermod -aG docker "$USER"
    sudo systemctl start docker

    info "${YELLOW}Docker installed, but you need to reboot or start a new shell with 'newgrp docker' to continue"
fi # Docker

if prompt_default_no "Install prettier?"; then
    sudo dnf --assumeyes install npm nodejs
    # shellcheck disable=SC2088
    npm config set prefix '~/.local/'
    npm install --global prettier
fi
