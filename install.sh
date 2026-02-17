#!/usr/bin/env bash
# ============================================================
#  Neovim/Vim Environment Bootstrap Script
#  Author: Sina Tehrani Fard
#  Purpose: Automated setup of Neovim + WezTerm + LSPs
# ============================================================

set -euo pipefail

# 一時ディレクトリのクリーンアップ用trap
TEMP_DIR=""
cleanup() {
  if [ -n "${TEMP_DIR:-}" ] && [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
  fi
}
trap cleanup EXIT

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
# ヘルプ表示
# ============================================================

show_help() {
  cat << 'HELP'
Usage: ./install.sh [OPTIONS]

Neovim/Vim Environment Bootstrap Script

OPTIONS:
  -y, --yes     確認プロンプトをスキップして自動実行
  -h, --help    このヘルプメッセージを表示

ENVIRONMENT VARIABLES:
  OBSIDIAN_VAULT    Obsidian Vaultのパス（デフォルト: ~/Documents/ObsidianVault）
  XDG_CONFIG_HOME   Neovim設定のインストール先（デフォルト: ~/.config）

EXAMPLES:
  ./install.sh              # 対話モードでインストール
  ./install.sh -y           # 確認をスキップしてインストール
  OBSIDIAN_VAULT=~/notes ./install.sh  # カスタムVaultパスでインストール

このスクリプトは以下の処理を行います：
  1. 依存ツールのインストール（Neovim, fd, ripgrep, lazygit, node）
  2. 既存の設定をバックアップ
  3. Neovim/WezTerm設定をシンボリックリンクで配置
  4. Obsidian Vaultの作成
  5. Neovimプラグインのインストール
HELP
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

      # sudoが利用可能か、またはroot権限があるかチェック
      run_privileged() {
        if [ "$(id -u)" -eq 0 ]; then
          "$@"
        elif command -v sudo >/dev/null 2>&1; then
          sudo "$@"
        else
          print_error "Root privileges required but sudo is not available"
          return 1
        fi
      }

      # Neovim (最新版のためPPA追加)
      if ! command -v nvim >/dev/null 2>&1; then
        print_status "Installing Neovim..."
        print_warning "This will add the Neovim PPA (ppa:neovim-ppa/unstable) to install the latest version."
        read -p "Do you want to continue? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          run_privileged apt update
          run_privileged apt install -y software-properties-common
          run_privileged add-apt-repository -y ppa:neovim-ppa/unstable
          run_privileged apt update
          run_privileged apt install -y neovim
        else
          print_warning "Skipping Neovim installation from PPA"
        fi
      else
        print_status "Neovim found: $(nvim --version | head -n1)"
      fi

      # 依存ツール
      run_privileged apt install -y fd-find ripgrep nodejs npm git curl

      # fdのエイリアス（Ubuntu/Debianではfdfindという名前）
      if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
        mkdir -p ~/.local/bin
        ln -sf "$(which fdfind)" ~/.local/bin/fd
        print_status "Created fd alias"
      fi

      # lazygit
      if ! command -v lazygit >/dev/null 2>&1; then
        print_status "Installing lazygit..."
        LAZYGIT_VERSION=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | sed -n 's/.*"tag_name": "v\([^"]*\)".*/\1/p')

        # アーキテクチャを動的に検出
        MACHINE_ARCH=$(uname -m)
        case "$MACHINE_ARCH" in
          x86_64)  LAZYGIT_ARCH="x86_64" ;;
          aarch64) LAZYGIT_ARCH="arm64" ;;
          arm64)   LAZYGIT_ARCH="arm64" ;;
          *)       print_error "Unsupported architecture: $MACHINE_ARCH"; exit 1 ;;
        esac

        # 一時ディレクトリで作業
        TEMP_DIR=$(mktemp -d)
        curl -fsSL -o "$TEMP_DIR/lazygit.tar.gz" "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz"
        tar xf "$TEMP_DIR/lazygit.tar.gz" -C "$TEMP_DIR" lazygit
        run_privileged install "$TEMP_DIR/lazygit" /usr/local/bin
        rm -rf "$TEMP_DIR"
        TEMP_DIR=""
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
# 4. 設定ファイルのシンボリックリンク作成
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

# 指定ディレクトリへのシンボリックリンクを作成（既存があればバックアップ）
create_symlink() {
  local source="$1"
  local target="$2"

  if [ -L "$target" ]; then
    rm "$target"
    print_status "Removed existing symlink: $target"
  elif [ -d "$target" ] || [ -f "$target" ]; then
    local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
    print_warning "Backing up existing config: $target → $backup"
    mv "$target" "$backup"
  fi

  ln -sf "$source" "$target"
  print_status "Linked: $target → $source"
}

install_configs() {
  print_status "Installing configuration symlinks..."

  mkdir -p "$CONFIG_DIR"

  # Neovim
  create_symlink "$SCRIPT_DIR/.config/nvim" "$CONFIG_DIR/nvim"

  # WezTerm
  create_symlink "$SCRIPT_DIR/.config/wezterm" "$CONFIG_DIR/wezterm"

  print_status "Configuration symlinks created"
}

# ============================================================
# 5. Obsidian Vault の作成
# ============================================================

setup_obsidian_vault() {
  print_status "Setting up Obsidian Vault..."

  # 環境変数 OBSIDIAN_VAULT が設定されていればそれを使用、なければデフォルト
  VAULT_DIR="${OBSIDIAN_VAULT:-$HOME/Documents/ObsidianVault}"

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
# 6. プラグインのインストール
# ============================================================

install_plugins() {
  print_status "Installing Neovim plugins..."

  # Neovimを起動してlazy.nvimにプラグインをインストールさせる
  nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

  print_status "Plugins installation initiated. First launch may take a moment."
}

# ============================================================
# 7. 実行前の確認プロンプト
# ============================================================

confirm_installation() {
  echo ""
  echo "============================================================"
  echo "  Neovim Environment Bootstrap Script"
  echo "============================================================"
  echo ""
  echo "このスクリプトは以下の処理を行います："
  echo ""
  echo "  1. 依存ツールのインストール（Neovim, fd, ripgrep, lazygit, node）"
  echo "  2. 既存の設定をバックアップ"
  echo "  3. Neovim/WezTerm設定をシンボリックリンクで配置"
  echo "  4. Obsidian Vaultの作成（\${OBSIDIAN_VAULT:-~/Documents/ObsidianVault}）"
  echo "  5. Neovimプラグインのインストール"
  echo ""
  echo "注意: 既存の設定がある場合、自動的にバックアップされます。"
  echo ""

  # -y オプションで確認をスキップ
  if [ "${1:-}" = "-y" ] || [ "${1:-}" = "--yes" ]; then
    return 0
  fi

  read -p "続行しますか？ [y/N]: " response
  case "$response" in
    [yY][eE][sS]|[yY])
      return 0
      ;;
    *)
      print_warning "インストールがキャンセルされました。"
      exit 0
      ;;
  esac
}

# ============================================================
# メイン処理
# ============================================================

main() {
  # --help オプションのチェック
  case "${1:-}" in
    -h|--help)
      show_help
      exit 0
      ;;
  esac

  # 確認プロンプト
  confirm_installation "$@"

  # 依存ツールのインストール
  install_dependencies

  # Node.jsの確認
  check_nodejs

  # 設定ファイルのシンボリックリンク作成
  install_configs

  # Obsidian Vaultのセットアップ
  setup_obsidian_vault

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
  echo "Obsidian Vault location: ${OBSIDIAN_VAULT:-~/Documents/ObsidianVault}"
  echo "Tutorial: docs/neovim-tutorial.md"
  echo ""
}

main "$@"
