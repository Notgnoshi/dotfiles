#!/bin/bash
if prompt_default_no "Install native software development packages?"; then
    PACKAGES=(
        clang
        clang-format
        clang-tidy
        clangd
        cmake
        debuginfod
        doxygen
        elfutils
        freeglut3-dev
        g++
        gcc
        gdb
        gdb-multiarch
        gdbserver
        git-extras
        graphviz
        libhidapi-dev
        iwyu
        kcachegrind
        libboost-all-dev
        libzmq3-dev
        lld
        lldb
        make
        meld
        optipng
        pandoc
        pkg-config
        python3-dev
        python3-distutils
        sqlite3
        sqlitebrowser
        valgrind
    )

    sudo apt install "${PACKAGES[@]}"

    if [[ -d ~/src/bear/ ]]; then
        pushd ~/src/bear/ || exit 1
        git pull
    else
        git clone https://github.com/rizsotto/Bear.git ~/src/bear/
        pushd ~/src/bear/ || exit 1
    fi
    cmake -B build/ -DCMAKE_INSTALL_PREFIX="$HOME/.local/" .
    cmake --build build/ --parallel
    pushd ~/src/bear/build/ || exit 1
    make install
    popd || exit 1
    popd || exit 1
fi # Native

if prompt_default_no "Install Docker?"; then
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo groupadd --force docker
    sudo usermod -aG docker "$USER"
    sudo systemctl start docker

    info "${YELLOW}Docker installed, but you need to reboot or start a new shell with 'newgrp docker' to continue"
fi # Docker

if prompt_default_no "Install prettier?"; then
    sudo apt install npm nodejs
    # shellcheck disable=SC2088
    npm config set prefix '~/.local/'
    npm install --global prettier
fi
