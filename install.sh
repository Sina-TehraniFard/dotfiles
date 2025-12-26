#!/usr/bin/env bash
# ============================================================
#  Neovim/Vim Environment Bootstrap Script
#  Author: Sina Tehrani Fard
#  Purpose: Automated setup of Neovim + LSPs
# ============================================================

set -e

# カラー出力用
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
  echo -e "${GREEN}==> $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}==> WARNING: $1${NC}"
}

print_error() {
  echo -e "${RED}==> ERROR: $1${NC}"
}

# ============================================================
# 1. 環境の検出
# ============================================================

detect_os() {
  case "$(uname -s)" in
    Linux*)   OS=Linux;;
    Darwin*)  OS=Mac;;
    *)        OS="Unknown"
  esac
  echo "$OS"
}

OS=$(detect_os)
print_status "Detected OS: $OS"

# ============================================================
# 2. 必要なツールのインストール
# ============================================================

install_dependencies() {
  print_status "Installing dependencies..."

  if [ "$OS" = "Mac" ]; then
    # macOS: Homebrew
    if ! command -v brew >/dev/null 2>&1; then
      print_error "Homebrew not found. Please install Homebrew first."
      exit 1
    fi

    # Neovim
    if ! command -v nvim >/dev/null 2>&1; then
      print_status "Installing Neovim..."
      brew install neovim
    else
      print_status "Neovim found: $(nvim --version | head -n1)"
    fi

    # 依存ツール
    brew install fd ripgrep lazygit node || true

  elif [ "$OS" = "Linux" ]; then
    # Linux: apt (Ubuntu/Debian)
    if command -v apt >/dev/null 2>&1; then
      print_status "Installing via apt..."

      # Neovim (最新版のためPPA追加)
      if ! command -v nvim >/dev/null 2>&1; then
        print_status "Installing Neovim..."
        sudo apt update
        sudo apt install -y software-properties-common
        sudo add-apt-repository -y ppa:neovim-ppa/unstable
        sudo apt update
        sudo apt install -y neovim
      else
        print_status "Neovim found: $(nvim --version | head -n1)"
      fi

      # 依存ツール
      sudo apt install -y fd-find ripgrep nodejs npm git curl

      # fdのエイリアス（Ubuntu/Debianではfdfindという名前）
      if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
        mkdir -p ~/.local/bin
        ln -sf "$(which fdfind)" ~/.local/bin/fd
        print_status "Created fd alias"
      fi

      # lazygit
      if ! command -v lazygit >/dev/null 2>&1; then
        print_status "Installing lazygit..."
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm lazygit lazygit.tar.gz
      fi
    else
      print_warning "apt not found. Please install dependencies manually."
    fi
  fi
}

# ============================================================
# 3. Node.js の確認
# ============================================================

check_nodejs() {
  print_status "Checking Node.js..."

  if ! command -v node >/dev/null 2>&1; then
    print_error "Node.js not found. Please install Node.js."
    exit 1
  fi

  NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
  if [ "$NODE_VERSION" -lt 16 ]; then
    print_warning "Node.js version is old. Recommended: v16+"
  fi

  print_status "Node.js found: $(node -v)"
}

# ============================================================
# 4. Neovim 設定のインストール
# ============================================================

install_neovim_config() {
  print_status "Installing Neovim configuration..."

  NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # 既存の設定をバックアップ
  if [ -d "$NVIM_CONFIG_DIR" ]; then
    BACKUP_DIR="${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d%H%M%S)"
    print_warning "Existing Neovim config found. Backing up to $BACKUP_DIR"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
  fi

  # 設定ファイルをコピー
  mkdir -p "$NVIM_CONFIG_DIR"
  cp -r "$SCRIPT_DIR/nvim/"* "$NVIM_CONFIG_DIR/"

  print_status "Neovim config installed to $NVIM_CONFIG_DIR"
}

# ============================================================
# 5. Obsidian Vault の作成
# ============================================================

setup_obsidian_vault() {
  print_status "Setting up Obsidian Vault..."

  VAULT_DIR="$HOME/Documents/ObsidianVault"

  if [ ! -d "$VAULT_DIR" ]; then
    mkdir -p "$VAULT_DIR"/{notes,daily,templates,attachments}

    # サンプルテンプレート
    cat > "$VAULT_DIR/templates/daily.md" << 'EOF'
# {{date}}

## Tasks
- [ ]

## Notes

## Log

EOF

    print_status "Obsidian Vault created at $VAULT_DIR"
  else
    print_status "Obsidian Vault already exists at $VAULT_DIR"
  fi
}

# ============================================================
# 6. Vim 設定のインストール（オプション、後方互換用）
# ============================================================

install_vim_config() {
  print_status "Installing Vim configuration (for backward compatibility)..."

  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # .vimrc
  if [ -f "$SCRIPT_DIR/.vimrc" ]; then
    if [ -f "$HOME/.vimrc" ]; then
      cp "$HOME/.vimrc" "$HOME/.vimrc.backup.$(date +%Y%m%d%H%M%S)"
    fi
    cp "$SCRIPT_DIR/.vimrc" "$HOME/.vimrc"
  fi

  # vim-plug for Vim
  if [ ! -f ~/.vim/autoload/plug.vim ]; then
    print_status "Installing vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  # coc-settings.json
  if [ -f "$SCRIPT_DIR/coc-settings.json" ]; then
    mkdir -p ~/.vim
    cp "$SCRIPT_DIR/coc-settings.json" ~/.vim/
  fi

  print_status "Vim config installed"
}

# ============================================================
# 7. プラグインのインストール
# ============================================================

install_plugins() {
  print_status "Installing Neovim plugins..."

  # Neovimを起動してlazy.nvimにプラグインをインストールさせる
  nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

  print_status "Plugins installation initiated. First launch may take a moment."
}

# ============================================================
# メイン処理
# ============================================================

main() {
  echo ""
  echo "============================================================"
  echo "  Neovim Environment Bootstrap Script"
  echo "============================================================"
  echo ""

  # 依存ツールのインストール
  install_dependencies

  # Node.jsの確認
  check_nodejs

  # Neovim設定のインストール
  install_neovim_config

  # Obsidian Vaultのセットアップ
  setup_obsidian_vault

  # Vim設定のインストール（後方互換）
  install_vim_config

  # プラグインのインストール
  install_plugins

  echo ""
  echo "============================================================"
  print_status "Bootstrap complete!"
  echo "============================================================"
  echo ""
  echo "Next steps:"
  echo "  1. Open Neovim: nvim"
  echo "  2. Wait for plugins to install (first launch)"
  echo "  3. Run :Mason to install language servers"
  echo "  4. Run :checkhealth to verify setup"
  echo ""
  echo "Obsidian Vault location: ~/Documents/ObsidianVault"
  echo "Tutorial: docs/neovim-tutorial.md"
  echo ""
}

main "$@"
