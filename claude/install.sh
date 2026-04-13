#!/bin/bash
if [ "$(uname -s)" == "Darwin" ] ; then
    if ! brew list --cask claude &> /dev/null ; then
        brew install --cask claude
    fi
fi

if ! command -v claude &> /dev/null ; then
    npm install -g @anthropic-ai/claude-code
fi
