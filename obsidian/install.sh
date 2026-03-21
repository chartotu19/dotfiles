#!/bin/sh
#
# Obsidian
#
# Installs Obsidian note-taking app.
# Supports macOS, Ubuntu/Debian (via Snap or AppImage), Arch Linux, and Fedora.

set -e

OBSIDIAN_VERSION="1.7.7"

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
  DISTRO=""
  PKG_MANAGER=""

  if [ "$OS" = "Darwin" ]; then
    PKG_MANAGER="brew"
  elif [ "$OS" = "Linux" ]; then
    if command -v apt-get > /dev/null 2>&1; then
      PKG_MANAGER="apt"
      DISTRO="debian"
    elif command -v pacman > /dev/null 2>&1; then
      PKG_MANAGER="pacman"
      DISTRO="arch"
    elif command -v dnf > /dev/null 2>&1; then
      PKG_MANAGER="dnf"
      DISTRO="fedora"
    fi
  fi
}

# Install Obsidian via AppImage (universal Linux fallback)
install_appimage() {
  APPIMAGE_DIR="$HOME/.local/bin"
  APPIMAGE_PATH="$APPIMAGE_DIR/Obsidian.AppImage"
  DESKTOP_FILE="$HOME/.local/share/applications/obsidian.desktop"

  if [ -f "$APPIMAGE_PATH" ]; then
    success "Obsidian AppImage already installed"
    return 0
  fi

  info "downloading Obsidian AppImage v${OBSIDIAN_VERSION}..."

  mkdir -p "$APPIMAGE_DIR"
  mkdir -p "$HOME/.local/share/applications"

  curl -L -o "$APPIMAGE_PATH" \
    "https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/Obsidian-${OBSIDIAN_VERSION}.AppImage"

  chmod +x "$APPIMAGE_PATH"

  # Create desktop entry
  cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Name=Obsidian
Exec=$APPIMAGE_PATH %u
Terminal=false
Type=Application
Icon=obsidian
Categories=Office;
MimeType=x-scheme-handler/obsidian;
EOF

  success "Obsidian AppImage installed to $APPIMAGE_PATH"
}

# Install Obsidian
install_obsidian() {
  if command -v obsidian > /dev/null 2>&1; then
    success "Obsidian already installed"
    return 0
  fi

  # Check for AppImage
  if [ -f "$HOME/.local/bin/Obsidian.AppImage" ]; then
    success "Obsidian already installed (AppImage)"
    return 0
  fi

  info "installing Obsidian"

  case "$PKG_MANAGER" in
    brew)
      brew install --cask obsidian
      success "Obsidian installed via Homebrew"
      ;;
    apt)
      # Try snap first (most reliable on Ubuntu/Debian)
      if command -v snap > /dev/null 2>&1; then
        sudo snap install obsidian --classic
        success "Obsidian installed via Snap"
      else
        # Fallback to AppImage
        install_appimage
      fi
      ;;
    pacman)
      # Install from AUR using yay or paru
      if command -v yay > /dev/null 2>&1; then
        yay -S --noconfirm obsidian
        success "Obsidian installed via AUR (yay)"
      elif command -v paru > /dev/null 2>&1; then
        paru -S --noconfirm obsidian
        success "Obsidian installed via AUR (paru)"
      else
        # Fallback to AppImage
        info "no AUR helper found, using AppImage"
        install_appimage
      fi
      ;;
    dnf)
      # Fedora: try flatpak first, then AppImage
      if command -v flatpak > /dev/null 2>&1; then
        flatpak install -y flathub md.obsidian.Obsidian
        success "Obsidian installed via Flatpak"
      else
        install_appimage
      fi
      ;;
    *)
      # Universal fallback: AppImage
      install_appimage
      ;;
  esac
}

# Main
detect_platform
info "detected platform: $OS ($PKG_MANAGER)"

install_obsidian

exit 0
