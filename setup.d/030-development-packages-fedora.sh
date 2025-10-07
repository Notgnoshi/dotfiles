#!/bin/bash
if prompt_default_no "Install native software development packages?"; then
    PACKAGES=(
        # TODO: On Fedora Bear actually tracks close to the upstream, but as of right now, there's
        # what looks like an important bugfix that isn't in the fedora package yet (3.1.2)
        bear
        boost-devel
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
        libasan
        libubsan
        lld
        lldb
        make
        meld
        ocaml-csv
        openssl-devel
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

download_and_install_dive() {
    local version="$1"
    local version_no_v
    version_no_v=$(echo -n "$version" | sed -En 's/v(.*)/\1/p')
    local artifact="dive_${version_no_v}_linux_amd64.rpm"

    pushd /tmp || exit 1

    debug "downloading $artifact ..."
    github_download_release "wagoodman/dive" "$version" "$artifact"

    debug "installing..."
    sudo dnf --assumeyes localinstall "$artifact"

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
