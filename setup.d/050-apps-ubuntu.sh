#!/bin/bash
if prompt_default_no "Install base GUI packages?"; then
    PACKAGES=(
        gnome-extensions-app
        gnome-tweaks
        numix-gtk-theme
        numix-icon-theme-circle
    )

    sudo apt install "${PACKAGES[@]}"
fi

if prompt_default_no "Install VS Code?"; then
    curl --location https://go.microsoft.com/fwlink/?LinkID=760868 --output /tmp/code.deb
    sudo apt install /tmp/code.deb
fi

if prompt_default_no "Install Discord?"; then
    curl --location "https://discordapp.com/api/download?platform=linux&format=deb" --output /tmp/discord.deb
    sudo apt install /tmp/discord.deb
fi

if prompt_default_no "Install Spotify?"; then
    curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update
    sudo apt install spotify-client
fi

download_and_install_teams() {
    local version="$1"
    local version_no_v
    version_no_v=$(echo -n "$version" | sed -En 's/v(.*)/\1/p')
    local artifact="teams-for-linux_${version_no_v}_amd64.deb"

    pushd /tmp || exit 1

    debug "downloading $artifact ..."
    github_download_release "IsmaelMartinez/teams-for-linux" "$version" "$artifact"

    debug "installing..."
    sudo apt install "./$artifact"

    popd || exit 1
}

if prompt_default_yes "Install unofficial teams-for-linux?"; then
    latest_version=$(github_latest_release_tag "IsmaelMartinez/teams-for-linux")
    info "Found latest version: $latest_version"

    if command -v teams-for-linux &>/dev/null; then
        installed_version="v$(teams-for-linux --version | tail -1 | tr -d '\n')"
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
    sudo apt install steam
fi
