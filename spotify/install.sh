#!/bin/bash
if [ "$(uname -s)" == "Darwin" ] ; then
    if ! brew list --cask spotify &> /dev/null ; then
        brew install --cask spotify
    fi
fi
