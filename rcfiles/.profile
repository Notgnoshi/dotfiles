#!/bin/sh

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # We want login shells (SSH, TTY, etc) to use .bashrc too.
    if [ -f ~/.bashrc ]; then
        . ~/.bashrc
    fi
fi
[ -f ~/.cargo/env ] && source ~/.cargo/env || true
