#!/bin/sh
#
# JDK (Java Development Kit)
#
# Installs the default JDK package.
# Supports macOS, Ubuntu/Debian, Arch Linux, and Fedora/RHEL.

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

install_jdk() {
  if command -v javac > /dev/null 2>&1; then
    success "JDK already installed ($(javac -version 2>&1))"
    return 0
  fi

  info "installing JDK"

  case "$PKG_MANAGER" in
    brew)
      brew install openjdk
      success "JDK installed"
      ;;
    apt)
      sudo apt-get update
      sudo apt-get install -y default-jdk
      success "JDK installed"
      ;;
    pacman)
      sudo pacman -S --noconfirm jdk-openjdk
      success "JDK installed"
      ;;
    dnf)
      sudo dnf install -y java-latest-openjdk-devel
      success "JDK installed"
      ;;
    yum)
      sudo yum install -y java-latest-openjdk-devel
      success "JDK installed"
      ;;
    *)
      fail "unsupported package manager for JDK"
      return 1
      ;;
  esac
}

# Main
detect_platform
info "detected platform: $OS ($PKG_MANAGER)"

install_jdk

exit 0
