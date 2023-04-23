#!/bin/bash
if prompt_default_no "Install Tilix?"; then
    sudo dnf --assumeyes install tilix
fi
