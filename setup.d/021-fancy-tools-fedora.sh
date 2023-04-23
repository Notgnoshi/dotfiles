#!/bin/bash
if prompt_default_no "Install bat, fd-find, jq, ripgrep?"; then
    sudo dnf --assumeyes install bat fd-find jq ripgrep
fi
