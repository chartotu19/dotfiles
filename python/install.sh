#!/bin/bash
if ! command -v pyenv &> /dev/null ; then
    if command -v brew &> /dev/null ; then
        brew install pyenv
        brew install pyenv-virtualenv
    elif command -v apt-get &> /dev/null ; then
        sudo apt-get update && sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
            libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev \
            xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
        curl https://pyenv.run | bash
    elif command -v pacman &> /dev/null ; then
        sudo pacman -S --noconfirm pyenv
    fi
fi
