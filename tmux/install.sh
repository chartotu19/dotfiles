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

# Symlink tmux.conf so tmux (and TPM) can find it
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ ! -e "$HOME/.tmux.conf" ]; then
  echo "  Symlinking tmux.conf..."
  ln -s "$SCRIPT_DIR/tmux.conf.symlink" "$HOME/.tmux.conf"
fi

# Install plugins non-interactively if tmux is available
if command -v tmux &> /dev/null; then
  echo "  Installing tmux plugins..."
  # TPM queries tmux's global environment for this variable; set it before installing
  tmux start-server\; set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins"
  "$TPM_DIR/bin/install_plugins" || true
fi
