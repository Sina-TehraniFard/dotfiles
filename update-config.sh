#!/usr/bin/env bash
# ============================================================
#  Vim Configuration Update Script
#  Purpose: Apply the latest .vimrc and coc-settings.json
#           from this repository to the existing environment.
# ============================================================

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
VIM_DIR="$HOME/.vim"
VIMRC="$HOME/.vimrc"
COC_SETTINGS="$VIM_DIR/coc-settings.json"

echo "==> Updating Vim configuration..."

# --- backup existing files (safety first)
timestamp=$(date +"%Y%m%d_%H%M%S")
mkdir -p "$REPO_DIR/backups"

if [ -f "$VIMRC" ]; then
  cp "$VIMRC" "$REPO_DIR/backups/.vimrc_$timestamp"
  echo "   Backed up existing .vimrc"
fi

if [ -f "$COC_SETTINGS" ]; then
  cp "$COC_SETTINGS" "$REPO_DIR/backups/coc-settings.json_$timestamp"
  echo "   Backed up existing coc-settings.json"
fi

# --- overwrite with repo versions
cp "$REPO_DIR/.vimrc" "$VIMRC"
mkdir -p "$VIM_DIR"
cp "$REPO_DIR/coc-settings.json" "$COC_SETTINGS"

# --- reload coc.nvim (if Vim is running)
if pgrep -x "vim" >/dev/null; then
  echo "==> Detected running Vim instance."
  echo "   Restart Vim manually or execute ':CocRestart' to reload settings."
fi

echo "==> Update complete!"
