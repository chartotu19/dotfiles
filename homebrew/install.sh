#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Skip on Linux - homebrew setup is macOS-specific
if test "$(uname)" != "Darwin"
then
  exit 0
fi

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  fi

fi

# Common CLI utilities (macOS-only small tools)
brew install tig
brew install findutils
brew install wget
brew install tree
brew install netcat
brew install telnet
brew install jq
brew install mysql
brew install jumpcut --cask
brew install envchain
brew install stern
brew install hey
brew install nmap

brew cleanup
exit 0
