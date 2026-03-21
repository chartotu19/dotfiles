#!/bin/bash
#
# GitHub CLI installation for Debian/Ubuntu-based systems

set -e

info() {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

# Skip on non-Linux systems
if [ "$(uname)" != "Linux" ]; then
  exit 0
fi

# Skip if apt-get is not available
if ! command -v apt-get > /dev/null 2>&1; then
  info "Skipping gh CLI (apt-get not found)"
  exit 0
fi

# Check if gh is already installed
if command -v gh > /dev/null 2>&1; then
  success "GitHub CLI $(gh --version | head -n1) already installed"
  exit 0
fi

info "Installing GitHub CLI..."

# Ensure wget is available
if ! command -v wget > /dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y wget
fi

# Set up GPG keyring
sudo mkdir -p -m 755 /etc/apt/keyrings
out=$(mktemp)
wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg
cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
rm "$out"
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

# Add the official repository
sudo mkdir -p -m 755 /etc/apt/sources.list.d
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Install GitHub CLI
sudo apt-get update
sudo apt-get install -y gh

success "GitHub CLI $(gh --version | head -n1) installed"
