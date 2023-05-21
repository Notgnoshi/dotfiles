#!/bin/bash
if prompt_default_yes "Install Python development packages?"; then
    if prompt_default_no "Install Pip?"; then
        if ! command -v pip &>/dev/null; then
            info "Pip not installed. Installing..."
            curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
            python3 /tmp/get-pip.py --user
        else
            info "Pip $(pip --version | grep -o '(.*)') already installed"
        fi
    fi

    if prompt_default_yes "Install/update Python development packages?"; then
        pip install --upgrade --user --requirement "$DOTFILES_SETUP_SCRIPT_DIR/requirements.txt"
        info "${YELLOW}Modifying $(which pylint) to use environment python instead of system python..."
        sed -i 's|/usr/bin/python3|/usr/bin/env python3|' "$(which pylint)"
    fi

    if prompt_default_no "Install/update colout?"; then
        mkdir -p "$HOME/src/"
        if [[ -d "$HOME/src/colout/" ]]; then
            pushd "$HOME/src/colout/" || exit 1
            git pull
        else
            git clone https://github.com/nojhan/colout.git "$HOME/src/colout/"
            pushd "$HOME/src/colout/" || exit 1
            python setup.py install --user
        fi

        popd || exit 1
    fi
fi # Python

download_and_install_shellcheck() {
    local version="$1"
    local artifact="shellcheck-$version.linux.x86_64.tar.xz"

    pushd /tmp || exit 1

    debug "downloading $artifact ..."
    github_download_release "koalaman/shellcheck" "$version" "$artifact"

    debug "unpacking $artifact ..."
    tar -xvf "$artifact"

    debug "installing..."
    cp "shellcheck-$version"*/shellcheck ~/.local/bin/

    popd || exit 1
}

download_and_install_shfmt() {
    local version="$1"
    local artifact="shfmt_${version}_linux_amd64"

    pushd /tmp || exit 1

    debug "downloading $artifact ..."
    github_download_release "mvdan/sh" "$version" "$artifact"

    debug "installing..."
    cp "/tmp/$artifact" ~/.local/bin/shfmt
    chmod +x ~/.local/bin/shfmt

    popd || exit 1
}

if prompt_default_yes "Install/update linters and formatters?"; then
    latest_version=$(github_latest_release_tag "koalaman/shellcheck")
    info "Found latest shellcheck version: $latest_version"

    if command -v shellcheck &>/dev/null; then
        installed_version="v$(shellcheck --version | sed -En 's/version: ([0-9]+\.[0-9]+\.[0-9]+)/\1/p')"
        debug "Found installed shellcheck version: $installed_version"

        if [[ "$installed_version" != "$latest_version" ]]; then
            info "Updating shellcheck..."
            download_and_install_shellcheck "$latest_version"
        else
            info "Shellcheck $installed_version already installed."
            if prompt_default_no "Reinstall shellcheck?"; then
                info "Reinstalling shellcheck..."
                download_and_install_shellcheck "$installed_version"
            fi
        fi
    else
        info "Installing shellcheck for the first time..."
        download_and_install_shellcheck "$latest_version"
    fi

    latest_version=$(github_latest_release_tag "mvdan/sh")
    info "Found latest shfmt version: $latest_version"

    if command -v shfmt &>/dev/null; then
        installed_version="$(shfmt --version | tr -d '\n')"
        debug "Found installed shfmt version: $installed_version"

        if [[ "$installed_version" != "$latest_version" ]]; then
            info "Updating shfmt..."
            download_and_install_shfmt "$latest_version"
        else
            info "shfmt $installed_version already installed."
            if prompt_default_no "Reinstall shfmt?"; then
                info "Reinstalling shfmt..."
                download_and_install_shfmt "$installed_version"
            fi
        fi
    else
        info "Installing shfmt for the first time..."
        download_and_install_shfmt "$latest_version"
    fi
fi # Linters/formatters

if prompt_default_yes "Install/update Rust?"; then
    if command -v rustup &>/dev/null; then
        installed_version=$(rustup --version |& sed -En 's/rustup\s+([0-9.]+)\s.*/\1/p')
        info "rustup version $installed_version already installed. Updating..."
        rustup self update
        rustup update
    else
        info "rustup not installed. Installing..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        rustup +nightly component add rust-analyzer-preview
        rustup completions bash >~/.bash_completion.d/rustup
        rustup completions bash cargo >~/.bash_completion.d/cargo
    fi

    if prompt_default_no "Install/update Cargo subcommands?"; then
        # shellcheck disable=SC1090
        [ -f ~/.cargo/env ] && source ~/.cargo/env
        cargo install cargo-outdated cargo-nextest cargo-expand cargo-download cargo-depgraph cargo-deadlinks cargo-bloat cargo-udeps
    fi
fi # Rust

if prompt_default_yes "Install/update hadolint?"; then
    docker pull hadolint/hadolint
fi