#!/usr/bin/env bash
#
# Validate dotfiles repo structure:
#   - All install.sh scripts are executable
#   - All install.sh scripts have a shebang or valid syntax
#   - All .symlink files exist and are regular files
#   - No broken internal references

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

# --- Check install.sh scripts are executable ---
echo "==> Checking install.sh scripts are executable..."

while IFS= read -r script; do
  rel="${script#"$DOTFILES_ROOT"/}"
  if [ -x "$script" ]; then
    ok "$rel"
  else
    error "$rel is not executable (run: chmod +x $rel)"
  fi
done < <(find "$DOTFILES_ROOT" -name 'install.sh' -not -path '*/.git/*' | sort)

# --- Check install.sh scripts have valid bash syntax ---
echo ""
echo "==> Checking install.sh scripts have valid syntax..."

while IFS= read -r script; do
  rel="${script#"$DOTFILES_ROOT"/}"
  if bash -n "$script" 2>/dev/null; then
    ok "$rel"
  else
    error "$rel has syntax errors"
  fi
done < <(find "$DOTFILES_ROOT" -name 'install.sh' -not -path '*/.git/*' | sort)

# --- Check .symlink files exist and are regular files ---
echo ""
echo "==> Checking .symlink files..."

while IFS= read -r symlink; do
  rel="${symlink#"$DOTFILES_ROOT"/}"
  if [ -f "$symlink" ]; then
    ok "$rel"
  else
    error "$rel is not a regular file"
  fi
done < <(find "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*/.git/*' | sort)

# --- Check script/bootstrap and script/install exist and are executable ---
echo ""
echo "==> Checking entry point scripts..."

for entry in script/bootstrap script/install; do
  if [ -x "$DOTFILES_ROOT/$entry" ]; then
    ok "$entry"
  else
    error "$entry is missing or not executable"
  fi
done

# --- Check zshrc.symlink references valid paths ---
echo ""
echo "==> Checking zshrc.symlink internal references..."

ZSHRC="$DOTFILES_ROOT/zsh/zshrc.symlink"
if [ -f "$ZSHRC" ]; then
  # Check that $ZSH is set to .dotfiles path
  if grep -q 'export ZSH=\$HOME/\.dotfiles' "$ZSHRC"; then
    ok "zshrc exports ZSH=\$HOME/.dotfiles"
  else
    error "zshrc may have incorrect ZSH path"
  fi
fi

echo ""
if [ "$ERRORS" -gt 0 ]; then
  echo "validate-structure: $ERRORS error(s) found"
  exit 1
else
  echo "validate-structure: all checks passed"
fi
