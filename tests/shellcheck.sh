#!/usr/bin/env bash
#
# Run shellcheck on all shell scripts in the repo.

set -e

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

ERRORS=0

echo "==> Running shellcheck on all .sh files..."

while IFS= read -r script; do
  if shellcheck -S warning "$script" 2>/dev/null; then
    echo "  ✓ $script"
  else
    echo "  ✗ $script"
    ERRORS=$((ERRORS + 1))
  fi
done < <(find "$DOTFILES_ROOT" -name '*.sh' -not -path '*/.git/*' -not -path '*/oh-my-zsh/*' | sort)

echo ""
if [ "$ERRORS" -gt 0 ]; then
  echo "shellcheck: $ERRORS file(s) had warnings"
  exit 1
else
  echo "shellcheck: all files passed"
fi
