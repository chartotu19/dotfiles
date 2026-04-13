#!/bin/bash
if ! command -v tmux &> /dev/null ; then
    if command -v brew &> /dev/null ; then
        brew install tmux
    elif command -v apt-get &> /dev/null ; then
        sudo apt-get update && sudo apt-get install -y tmux
    elif command -v dnf &> /dev/null ; then
        sudo dnf install -y tmux
    elif command -v yum &> /dev/null ; then
        sudo yum install -y tmux
    elif command -v pacman &> /dev/null ; then
        sudo pacman -S --noconfirm tmux
    fi
fi
