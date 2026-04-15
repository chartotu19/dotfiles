#!/bin/bash

set -e

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
#
# tmux plugin installation
# Installs TPM (Tmux Plugin Manager) which handles tmux-resurrect and tmux-continuum


TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
  echo "  Installing TPM (Tmux Plugin Manager)..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "  TPM already installed"
fi

# Install plugins non-interactively if tmux is available
if command -v tmux &> /dev/null; then
  echo "  Installing tmux plugins..."
  "$TPM_DIR/bin/install_plugins" || true
fi
