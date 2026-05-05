#!/bin/bash
if prompt_default_yes "Install/update fancy shell tools?"; then
    if prompt_default_yes "Install/update fzf from GitHub?"; then
        pushd "$DOTFILES_SETUP_SCRIPT_DIR/stowdir/.vim/bundle/fzf/" || exit 1
        git switch master
        git pull
        ./install --all
        popd || exit 1
    fi

    download_and_install_delta() {
        local version="$1"
        local artifact="delta-$version-x86_64-unknown-linux-gnu.tar.gz"

        pushd /tmp || exit 1

        debug "downloading $artifact ..."
        github_download_release "dandavison/delta" "$version" "$artifact"

        debug "unpacking $artifact ..."
        tar -xvf "$artifact"

        debug "installing..."
        cp "delta-$version"*/delta ~/.local/bin/

        popd || exit 1
    }

    if prompt_default_yes "Install/update delta from GitHub?"; then
        latest_version=$(github_latest_release_tag "dandavison/delta")
        info "Found latest version: $latest_version"

        if command -v delta &>/dev/null; then
            installed_version=$(delta --version | sed -En 's/^.*([0-9]+\.[0-9]+\.[0-9]+).*$/\1/p')
            debug "Found installed version: $installed_version"

            if [[ "$installed_version" != "$latest_version" ]]; then
                info "Updating delta..."
                download_and_install_delta "$latest_version"
            else
                info "delta $installed_version already installed."
                if prompt_default_no "Reinstall delta?"; then
                    info "Reinstalling delta..."
                    download_and_install_delta "$latest_version"
                fi
            fi
        else
            info "Installing delta for the first time..."
            download_and_install_delta "$latest_version"
        fi
    fi

    download_and_install_nvim() {
        local -r artifact="nvim-linux-x86_64.tar.gz"
        pushd /tmp || exit 1

        debug "downloading $artifact ..."
        github_download_release "neovim/neovim" "stable" "$artifact"

        debug "installing ..."
        tar -C ~/.local/ --strip-components=1 -xzvf "$artifact"

        popd || exit 1
    }

    if prompt_default_yes "Install/update nvim from GitHub?"; then
        latest_version=$(github_latest_release_tag "neovim/neovim")
        info "Found latest version: $latest_version"

        if command -v nvim &>/dev/null; then
            installed_version=$(nvim --version | sed -En 's/^NVIM (v[0-9]+\.[0-9]+\.[0-9]+).*$/\1/p')
            debug "Found installed version: $installed_version"

            if [[ "$installed_version" != "$latest_version" ]]; then
                info "Updating nvim..."
                download_and_install_nvim
            else
                info "nvim $installed_version already installed."
                if prompt_default_no "Reinstall nvim?"; then
                    info "Reinstalling nvim..."
                    download_and_install_nvim
                fi
            fi
        else
            info "Installing nvim for the first time..."
            download_and_install_nvim
        fi
    fi
fi
