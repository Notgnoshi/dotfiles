#!/bin/bash
if prompt_default_no "Install native software development packages?"; then
    PACKAGES=(
        bear
        clang
        clang-format
        clang-tidy
        clangd
        cmake
        csvtool
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
        libasan6
        libboost-all-dev
        libssl-dev
        libubsan1
        libzmq3-dev
        lld
        lldb
        make
        meld
        optipng
        pandoc
        pkg-config
        python3-dev
        sqlite3
        sqlitebrowser
        valgrind
    )

    sudo apt install "${PACKAGES[@]}"
fi # Native

if prompt_default_no "Install Docker?"; then
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo groupadd --force docker
    sudo usermod -aG docker "$USER"
    sudo systemctl enable docker
    sudo systemctl start docker

    info "${YELLOW}Docker installed, but you need to reboot or start a new shell with 'newgrp docker' to continue"
fi # Docker

download_and_install_dive() {
    local version="$1"
    local version_no_v
    version_no_v=$(echo -n "$version" | sed -En 's/v(.*)/\1/p')
    local artifact="dive_${version_no_v}_linux_amd64.deb"

    pushd /tmp || exit 1

    debug "downloading $artifact ..."
    github_download_release "wagoodman/dive" "$version" "$artifact"

    debug "installing..."
    sudo apt install "./$artifact"

    popd || exit 1
}

if prompt_default_no "Install Docker dive?"; then
    latest_version=$(github_latest_release_tag "wagoodman/dive")
    info "Found latest version: $latest_version"

    if command -v dive &>/dev/null; then
        installed_version="v$(dive --version | cut -d ' ' -f 2 | tr -d '\n')"
        debug "Found installed version: $installed_version"

        if [[ "$installed_version" != "$latest_version" ]]; then
            info "Updating dive..."
            download_and_install_dive "$latest_version"
        else
            info "dive $installed_version already installed."
            if prompt_default_no "Reinstall dive?"; then
                info "Reinstalling dive..."
                download_and_install_dive "$latest_version"
            fi
        fi
    else
        info "Installing dive for the first time..."
        download_and_install_dive "$latest_version"
    fi
fi
