#!/bin/sh
#
# Kubernetes tools
#
# Installs kubectl, helm, and Google Cloud SDK for connecting to k8s clusters.
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

# Install kubectl
install_kubectl() {
  if command -v kubectl > /dev/null 2>&1; then
    success "kubectl already installed"
    return 0
  fi

  info "installing kubectl"

  case "$PKG_MANAGER" in
    brew)
      brew install kubectl
      success "kubectl installed"
      ;;
    apt)
      # Install kubectl via official apt repository
      sudo apt-get update
      sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

      # Add Kubernetes apt key
      curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg --yes
      sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

      # Add Kubernetes apt repository
      echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
      sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list

      sudo apt-get update
      sudo apt-get install -y kubectl
      success "kubectl installed"
      ;;
    pacman)
      sudo pacman -S --noconfirm kubectl
      success "kubectl installed"
      ;;
    dnf)
      # Fedora/RHEL with dnf
      cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key
EOF
      sudo dnf install -y kubectl
      success "kubectl installed"
      ;;
    yum)
      # RHEL/CentOS with yum
      cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key
EOF
      sudo yum install -y kubectl
      success "kubectl installed"
      ;;
    *)
      fail "unsupported package manager for kubectl"
      return 1
      ;;
  esac
}

# Install Google Cloud SDK
install_gcloud() {
  if command -v gcloud > /dev/null 2>&1; then
    success "gcloud SDK already installed"
    return 0
  fi

  info "installing Google Cloud SDK"

  case "$PKG_MANAGER" in
    brew)
      brew install --cask google-cloud-sdk
      success "gcloud SDK installed"
      ;;
    apt)
      # Install gcloud via official apt repository
      sudo apt-get install -y apt-transport-https ca-certificates gnupg curl

      # Add Google Cloud apt key
      curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg --yes
      sudo chmod 644 /usr/share/keyrings/cloud.google.gpg

      # Add Google Cloud apt repository
      echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list

      sudo apt-get update
      sudo apt-get install -y google-cloud-cli google-cloud-cli-gke-gcloud-auth-plugin
      success "gcloud SDK installed"
      ;;
    pacman)
      # Install from AUR using yay or paru, or fallback to manual install
      if command -v yay > /dev/null 2>&1; then
        yay -S --noconfirm google-cloud-cli
      elif command -v paru > /dev/null 2>&1; then
        paru -S --noconfirm google-cloud-cli
      else
        # Fallback: install via official script
        info "no AUR helper found, installing via official script"
        install_gcloud_manual
        return $?
      fi
      success "gcloud SDK installed"
      ;;
    dnf|yum)
      # Install via official script for Fedora/RHEL
      install_gcloud_manual
      return $?
      ;;
    *)
      fail "unsupported package manager for gcloud"
      return 1
      ;;
  esac
}

# Install Helm
install_helm() {
  if command -v helm > /dev/null 2>&1; then
    success "helm already installed"
    return 0
  fi

  info "installing helm"

  case "$PKG_MANAGER" in
    brew)
      brew install helm
      success "helm installed"
      ;;
    pacman)
      sudo pacman -S --noconfirm helm
      success "helm installed"
      ;;
    *)
      # Use official install script for all other platforms (most reliable)
      curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
      success "helm installed"
      ;;
  esac
}

# Manual gcloud installation via official script (fallback)
install_gcloud_manual() {
  info "installing gcloud SDK via official installer"

  GCLOUD_DIR="$HOME/.local/google-cloud-sdk"

  if [ -d "$GCLOUD_DIR" ]; then
    success "gcloud SDK directory already exists at $GCLOUD_DIR"
    return 0
  fi

  # Download and extract
  curl -o /tmp/google-cloud-cli.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
  mkdir -p "$HOME/.local"
  tar -xzf /tmp/google-cloud-cli.tar.gz -C "$HOME/.local"
  rm /tmp/google-cloud-cli.tar.gz

  # Run install script (non-interactive)
  "$GCLOUD_DIR/install.sh" --quiet --path-update=false --command-completion=false

  success "gcloud SDK installed to $GCLOUD_DIR"
  info "add to PATH: export PATH=\"\$HOME/.local/google-cloud-sdk/bin:\$PATH\""
}

# Main
detect_platform
info "detected platform: $OS ($PKG_MANAGER)"

install_kubectl
install_helm
install_gcloud

# Install Argo CLI
if ! command -v argo > /dev/null 2>&1; then
  info "installing argo"
  case "$PKG_MANAGER" in
    brew)
      brew install argoproj/tap/argo
      success "argo installed"
      ;;
    *)
      info "skipping argo (install manually on non-macOS)"
      ;;
  esac
fi

# Install gke-gcloud-auth-plugin if gcloud is available
if command -v gcloud > /dev/null 2>&1; then
  if ! gcloud components list 2>/dev/null | grep -q "gke-gcloud-auth-plugin.*Installed"; then
    info "installing gke-gcloud-auth-plugin"
    case "$PKG_MANAGER" in
      apt)
        # Already installed with google-cloud-cli-gke-gcloud-auth-plugin
        ;;
      brew)
        gcloud components install gke-gcloud-auth-plugin --quiet 2>/dev/null || true
        ;;
      *)
        gcloud components install gke-gcloud-auth-plugin --quiet 2>/dev/null || true
        ;;
    esac
  fi
fi

exit 0
