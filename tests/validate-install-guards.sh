#!/usr/bin/env bash
#
# Validate that install.sh scripts have proper OS/command guards
# to prevent running destructive commands on the wrong platform.

set -e

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

ERRORS=0

error() {
  echo "  ✗ $1"
  ERRORS=$((ERRORS + 1))
}

ok() {
  echo "  ✓ $1"
}

echo "==> Checking install scripts have idempotency guards..."

while IFS= read -r script; do
  rel="${script#"$DOTFILES_ROOT"/}"

  # Check that scripts using brew verify brew exists or check for Darwin
  if grep -q 'brew install' "$script"; then
    if grep -q 'command -v brew\|which brew\|uname.*Darwin\|test.*Darwin\|PKG_MANAGER' "$script"; then
      ok "$rel has brew guard"
    else
      error "$rel uses brew without checking it exists or OS is macOS"
    fi
  fi

  # Check that scripts using apt-get verify it exists or check for Linux
  if grep -q 'apt-get install' "$script"; then
    if grep -q 'command -v apt-get\|uname.*Linux\|test.*Linux' "$script"; then
      ok "$rel has apt guard"
    else
      error "$rel uses apt-get without checking it exists or OS is Linux"
    fi
  fi

  # Check that scripts using sudo have a platform guard
  if grep -q 'sudo ' "$script"; then
    if grep -q 'uname\|command -v' "$script"; then
      ok "$rel has platform guard for sudo usage"
    else
      error "$rel uses sudo without platform detection"
    fi
  fi

done < <(find "$DOTFILES_ROOT" -name 'install.sh' -not -path '*/.git/*' | sort)

echo ""
if [ "$ERRORS" -gt 0 ]; then
  echo "validate-install-guards: $ERRORS error(s) found"
  exit 1
else
  echo "validate-install-guards: all checks passed"
fi
