#!/bin/sh
#
# Linux APT packages
#
# This installs common utilities on Debian/Ubuntu-based systems.

# Skip on non-Linux systems
if test "$(uname)" != "Linux"
then
  exit 0
fi

# Skip if apt-get is not available
if ! command -v apt-get > /dev/null 2>&1
then
  echo "  Skipping apt packages (apt-get not found)"
  exit 0
fi

echo "  Installing apt packages..."

sudo apt-get update

# Utilities
sudo apt-get install -y gnome-shell-pomodoro
sudo apt-get install -y flameshot
sudo apt-get install -y chromium-browser

exit 0
