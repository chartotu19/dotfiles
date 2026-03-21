#!/bin/bash
#
# Node.js and npm installation via NVM
# Works on both macOS and Linux

set -e

NVM_VERSION="v0.40.1"
NODE_VERSION="--lts"

info() {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

# Install NVM if not present
if [ ! -d "$HOME/.nvm" ]; then
  info "Installing NVM ${NVM_VERSION}..."
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
  success "NVM installed"
else
  success "NVM already installed"
fi

# Load NVM for this script
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install Node.js LTS if not present
if ! command -v node &> /dev/null; then
  info "Installing Node.js LTS..."
  nvm install $NODE_VERSION
  nvm use $NODE_VERSION
  nvm alias default $NODE_VERSION
  success "Node.js $(node --version) installed with npm $(npm --version)"
else
  success "Node.js $(node --version) already installed"
fi

# Install global npm packages
if command -v npm &> /dev/null; then
  if ! command -v spoof &> /dev/null; then
    info "Installing spoof globally..."
    npm install -g spoof
    success "spoof installed"
  fi
fi
