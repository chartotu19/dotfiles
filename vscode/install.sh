#!/bin/bash
if [ "$(uname -s)" == "Darwin" ] ; then
    if ! brew list --cask visual-studio-code &> /dev/null ; then
        brew install --cask visual-studio-code
    fi
fi
