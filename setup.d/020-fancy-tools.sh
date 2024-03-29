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

    download_and_install_qsv() {
        local version="$1"
        local artifact="qsv-$version-x86_64-unknown-linux-gnu.zip"
        pushd /tmp || exit
        debug "downloading $artifact ..."
        github_download_release "jqnatividad/qsv" "$version" "$artifact"
        debug "unpacking $artifact ..."
        unzip -d qsv "$artifact"
        debug "installing ..."
        cp qsv/qsv ~/.local/bin/

        popd || exit 1
    }

    if prompt_default_yes "Install/update qsv from GitHub"; then
        latest_version=$(github_latest_release_tag "jqnatividad/qsv")
        info "Found latest version: $latest_version"

        if command -v qsv &>/dev/null; then
            installed_version=$(qsv --version | sed -En 's/^qsv ([0-9]+\.[0-9]+\.[0-9]+).*$/\1/p')
            debug "Found installed version: $installed_version"
            if [[ "$installed_version" != "$latest_version" ]]; then
                info "Updating qsv ..."
                download_and_install_qsv "$latest_version"
            else
                info "qsv $latest_version already installed"
                if prompt_default_no "Reinstall qsv?"; then
                    info "Reinstalling qsv ..."
                    download_and_install_qsv "$latest_version"
                fi
            fi
        else
            info "Installing qsv for the first time..."
            download_and_install_qsv "$latest_version"
        fi
    fi
fi
