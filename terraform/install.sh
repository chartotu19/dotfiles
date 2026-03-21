#!/bin/sh
#
# Terraform
#
# Installs Terraform for infrastructure as code.
# Supports macOS, Ubuntu/Debian, and Arch Linux.

set -e

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
}

# Detect OS and package manager
detect_platform() {
  OS="$(uname -s)"
  PKG_MANAGER=""

  if [ "$OS" = "Darwin" ]; then
    PKG_MANAGER="brew"
  elif [ "$OS" = "Linux" ]; then
    if command -v apt-get > /dev/null 2>&1; then
      PKG_MANAGER="apt"
    elif command -v pacman > /dev/null 2>&1; then
      PKG_MANAGER="pacman"
    elif command -v dnf > /dev/null 2>&1; then
      PKG_MANAGER="dnf"
    elif command -v yum > /dev/null 2>&1; then
      PKG_MANAGER="yum"
    fi
  fi
}

install_terraform() {
  if command -v terraform > /dev/null 2>&1; then
    success "terraform already installed"
    return 0
  fi

  info "installing terraform"

  case "$PKG_MANAGER" in
    brew)
      brew tap hashicorp/tap
      brew install hashicorp/tap/terraform
      success "terraform installed"
      ;;
    apt)
      # Install via HashiCorp apt repository
      sudo apt-get update
      sudo apt-get install -y gnupg software-properties-common curl

      # Add HashiCorp GPG key
      curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg --yes
      sudo chmod 644 /usr/share/keyrings/hashicorp-archive-keyring.gpg

      # Add HashiCorp repository
      echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

      sudo apt-get update
      sudo apt-get install -y terraform
      success "terraform installed"
      ;;
    pacman)
      sudo pacman -S --noconfirm terraform
      success "terraform installed"
      ;;
    dnf)
      # Install via HashiCorp yum repository
      sudo dnf install -y dnf-plugins-core
      sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
      sudo dnf install -y terraform
      success "terraform installed"
      ;;
    yum)
      # Install via HashiCorp yum repository
      sudo yum install -y yum-utils
      sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
      sudo yum install -y terraform
      success "terraform installed"
      ;;
    *)
      fail "unsupported package manager for terraform"
      return 1
      ;;
  esac
}

# Main
detect_platform
info "detected platform: $OS ($PKG_MANAGER)"

install_terraform

exit 0
