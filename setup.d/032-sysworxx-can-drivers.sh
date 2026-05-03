#!/bin/bash
# shellcheck disable=SC2164

# CAN_INTERPRETER_DOWNLOAD_LINK="https://www.systec-electronic.com/media/default/Redakteur/produkte/Interfaces_Gateways/sysWORXX_USB_CANmodul_Series/Downloads/linux-systec-cin-lite.zip"
SYSWORXX_SOCKETCAN_DRIVER_DOWNLOAD_LINK="https://www.systec-electronic.com/media/default/Redakteur/produkte/Interfaces_Gateways/sysWORXX_USB_CANmodul_Series/Downloads/SO-1139-systec_can.tar.bz2"

if ! prompt_default_no "Install sysWORXX SocketCAN Linux driver?"; then
    return
fi

if [[ ! -f /tmp/driver.tar.bz2 ]]; then
    debug "Downloading driver ..."
    pushd /tmp/
    curl --fail --show-error --location "$SYSWORXX_SOCKETCAN_DRIVER_DOWNLOAD_LINK" --output /tmp/driver.tar.bz2
    tar -xjvf /tmp/driver.tar.bz2
    popd
fi

debug "Querying dkms for previously installed driver ..."
INSTALLED_VERSION=""
if dkms status | grep --silent systec_can; then
    INSTALLED_VERSION="$(dkms status | tee /dev/stderr | grep systec_can | cut -d ',' -f1)"
fi
if [[ -n "$INSTALLED_VERSION" ]]; then
    info "Found installed version '$INSTALLED_VERSION'"
    if prompt_default_no "Reinstall sysWORXX SocketCAN Linux driver?"; then
        sudo dkms remove "$INSTALLED_VERSION" --all
        sudo rm -rf /usr/src/systec_can*
    else
        return
    fi
fi

debug "Installing sysWORXX driver ..."
pushd /tmp/systec_can-v*
sudo dkms install .
popd

dkms status

if ! prompt_default_no "Add blanket udev rule for a USB CANmodule1?"; then
    return
fi
sudo cp "$DOTFILES_SETUP_SCRIPT_DIR/udev/99-sysworxx-can-probe.rules" /etc/udev/rules.d/
sudo udevadm control --reload

# Useful information for troubleshooting:
#
# * Use 'udevadm monitor' to monitor udev events
# * Use 'sudo dmesg --follow' to monitor kernel
# * This will output something like
#       /devices/pci0000:00/0000:00:07.3/0000:3c:00.0/0000:3d:02.0/0000:3e:00.0/usb5/5-2/5-2.3/5-2.3.1/5-2.3.1:1.0
#   which is a path in /sys/
# * Using this path, you can run 'udevadm test /sys/devices/pci0000:00/big/long/path'
