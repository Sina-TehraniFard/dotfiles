#!/usr/bin/env bash
# ============================================================
#  Vim Environment Bootstrap Script
#  Author: Sina Tehrani Fard
#  Purpose: Automated setup of Vim + coc.nvim + LSPs (PHP/Kotlin)
# ============================================================

set -e

echo "==> Bootstrapping Vim environment..."

# 1. Copy config files
echo "==> Installing configuration files..."
mkdir -p ~/.vim
cp .vimrc ~/.vimrc
cp coc-settings.json ~/.vim/

# 2. Install vim-plug (plugin manager)
if [ ! -f ~/.vim/autoload/plug.vim ]; then
  echo "==> Installing vim-plug..."
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
  echo "==> vim-plug already installed."
fi

# 3. Check Node.js installation
if ! command -v node >/dev/null 2>&1; then
  echo "==> Node.js not found. Installing via Homebrew..."
  brew install node
else
  echo "==> Node.js found: $(node -v)"
fi

# 4. Install Language Servers
echo "==> Installing language servers..."
npm install -g intelephense || true
brew install kotlin-language-server || true

# 5. Install Vim plugins
echo "==> Installing Vim plugins..."
vim +PlugInstall +qall

echo "==> Bootstrap complete!"
