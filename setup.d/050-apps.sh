#!/bin/bash
if prompt_default_no "Install GUI apps?"; then
    if prompt_default_no "Install base GUI packages?"; then
        PACKAGES=(
            gnome-extensions-app
            gnome-tweaks
            numix-gtk-theme
            numix-icon-theme-circle
        )

        sudo dnf --assumeyes install "${PACKAGES[@]}"
    fi

    if prompt_default_no "Install VS Code?"; then
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

        dnf check-update
        sudo dnf --assumeyes install code
    fi

    if prompt_default_no "Install Discord?"; then
        sudo dnf --assumeyes install discord
    fi

    if prompt_default_no "Install Spotify?"; then
        sudo flatpak install --assumeyes flathub com.spotify.Client
    fi

    download_and_install_teams() {
        local version="$1"
        local version_no_v
        version_no_v=$(echo -n "$version" | sed -En 's/v(.*)/\1/p')
        local artifact="teams-for-linux-${version_no_v}.x86_64.rpm"

        pushd /tmp || exit 1

        debug "downloading $artifact ..."
        github_download_release "IsmaelMartinez/teams-for-linux" "$version" "$artifact"

        debug "installing..."
        sudo dnf --assumeyes localinstall "$artifact"

        popd || exit 1
    }

    if prompt_default_no "Install unofficial teams-for-linux?"; then
        latest_version=$(github_latest_release_tag "IsmaelMartinez/teams-for-linux")
        info "Found latest version: $latest_version"

        if command -v teams-for-linux &>/dev/null; then
            installed_version="v$(teams-for-linux --version | tr -d '\n')"
            debug "Found installed version: $installed_version"

            if [[ "$installed_version" != "$latest_version" ]]; then
                info "Updating teams-for-linux..."
                download_and_install_teams "$latest_version"
            else
                info "MS Teams $installed_version already installed."
                if prompt_default_no "Reinstall teams-for-linux?"; then
                    info "Reinstalling teams-for-linux..."
                    download_and_install_teams "$latest_version"
                fi
            fi
        else
            info "Installing teams-for-linux for the first time..."
            download_and_install_teams "$latest_version"
        fi
    fi

    if prompt_default_no "Install Steam?"; then
        sudo dnf --assumeyes install steam
    fi
fi
