# dotvim

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Neovim](https://img.shields.io/badge/Neovim-0.9+-brightgreen.svg)](https://neovim.io/)

Neovim を IDE 化するための設定です。macOS / Linux に対応しています。

<!-- TODO: スクリーンショットを追加
![dotvim screenshot](./docs/images/screenshot.png)
-->

## 特徴

- **モダンなプラグイン管理**: lazy.nvim による遅延読み込み
- **LSP対応**: 補完、定義ジャンプ、リファクタリング、診断表示
- **多言語サポート**: Lua, Python, TypeScript, PHP, Kotlin, Go, Rust 等
- **Git連携**: gitsigns, lazygit, diffview
- **ファイル操作**: Telescope（ファジーファインダー）、Neo-tree（ファイルツリー）
- **執筆支援**: Markdown プレビュー、Obsidian 連携

## 必要要件

- Neovim 0.9 以上
- Node.js 16 以上
- Git
- [Nerd Font](https://www.nerdfonts.com/)（アイコン表示に必要）

### Nerd Font のインストール

アイコンを正しく表示するには Nerd Font が必要です。

**おすすめフォント:**
- [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases) - プログラミング向けの読みやすいフォント
- [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases) - シンプルで視認性の高いフォント

**インストール方法:**

```bash
# macOS (Homebrew)
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font

# Linux (手動インストール)
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "JetBrainsMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip JetBrainsMono.zip
fc-cache -fv
```

インストール後、ターミナルのフォント設定を変更してください。

### オプション要件

- **Obsidian** - obsidian.nvim を使用する場合に必要。[Obsidian公式サイト](https://obsidian.md/)からインストールし、`~/Documents/ObsidianVault` にVaultを作成してください
- **lazygit** - Git UI統合に必要（install.shで自動インストール）

## インストール

```bash
git clone https://github.com/Sina-TehraniFard/dotvim.git
cd dotvim
./install.sh
```

`install.sh` は以下を自動で行います：

- Neovim のインストール（未インストールの場合）
- 依存ツールのインストール（fd, ripgrep, lazygit, node）
- Neovim 設定ファイルの配置（`~/.config/nvim`）
- プラグインの初期インストール

## 初回起動後

```bash
nvim
```

1. プラグインが自動インストールされます（初回のみ）
2. `:Mason` でLSPサーバーを確認・インストール
3. `:checkhealth` で環境をチェック

## ディレクトリ構成

```
dotvim/
├── nvim/                    # Neovim設定（~/.config/nvimにコピーされる）
│   ├── init.lua             # エントリーポイント
│   ├── lazy-lock.json       # プラグインバージョン固定
│   └── lua/
│       ├── core/            # 基本設定
│       │   ├── options.lua  # Neovimオプション
│       │   ├── keymaps.lua  # キーマップ
│       │   └── autocmds.lua # 自動コマンド
│       └── plugins/         # プラグイン設定
│           ├── init.lua     # lazy.nvim初期化
│           ├── ui.lua       # UI関連
│           ├── editor.lua   # エディタ機能
│           ├── coding.lua   # コーディング支援
│           ├── git.lua      # Git連携
│           └── writing.lua  # 執筆支援
├── docs/                    # ドキュメント
├── install.sh               # インストールスクリプト
└── LICENSE
```

## キーマップ

`<leader>` は `Space` キーです。

### ファイル操作

| キー | 機能 |
|------|------|
| `<leader>ff` | ファイル検索 |
| `<leader>fg` | テキスト検索（grep） |
| `<leader>fb` | バッファ一覧 |
| `<leader>fr` | 最近開いたファイル |
| `<leader>e` | ファイルツリー表示/非表示 |
| `<C-p>` | Gitファイル検索 |

### LSP

| キー | 機能 |
|------|------|
| `gd` | 定義へジャンプ |
| `gr` | 参照一覧 |
| `K` | ドキュメント表示 |
| `<leader>rn` | リネーム |
| `<leader>ca` | コードアクション |
| `[d` / `]d` | 前後の診断へ移動 |

### Git

| キー | 機能 |
|------|------|
| `<leader>gg` | LazyGit |
| `<leader>gd` | Diffview |
| `<leader>gh` | ファイル履歴 |
| `]h` / `[h` | 次/前の変更箇所 |

### データベース

| キー | 機能 |
|------|------|
| `<leader>du` | DBUIを開く/閉じる |
| `<leader>da` | DB接続を追加 |
| `<leader>df` | DBバッファを検索 |
| `<leader>dr` | DBバッファをリネーム |
| `<leader>dl` | 最後のクエリ情報 |

### 編集

| キー | 機能 |
|------|------|
| `gcc` | 行コメントトグル |
| `gc{motion}` | 範囲コメントトグル |
| `ys{motion}{char}` | 囲みを追加 |
| `cs{old}{new}` | 囲みを変更 |
| `ds{char}` | 囲みを削除 |

## プラグイン一覧

詳細は [docs/plugins.md](docs/plugins.md) を参照してください。

### UI
- **gruvbox.nvim** - カラースキーム
- **bufferline.nvim** - バッファタブライン
- **lualine.nvim** - ステータスライン
- **noice.nvim** - コマンドライン/メッセージUI改善
- **nvim-notify** - 通知表示

### エディタ
- **telescope.nvim** - ファジーファインダー
- **neo-tree.nvim** - ファイルツリー
- **which-key.nvim** - キーマップヘルプ
- **todo-comments.nvim** - TODOコメントハイライト

### コーディング
- **nvim-treesitter** - シンタックスハイライト
- **nvim-lspconfig** - LSP設定
- **mason.nvim** - LSPサーバー管理
- **nvim-cmp** - 補完エンジン
- **LuaSnip** - スニペット

### Git
- **gitsigns.nvim** - Git差分表示
- **lazygit.nvim** - LazyGit統合
- **diffview.nvim** - 高度なDiff表示

### 執筆
- **markdown-preview.nvim** - Markdownプレビュー
- **obsidian.nvim** - Obsidian連携
- **render-markdown.nvim** - Markdown装飾表示

### データベース
- **vim-dadbod** - データベース操作
- **vim-dadbod-ui** - DBクライアントUI
- **vim-dadbod-completion** - SQL補完

## アンインストール

dotvim を完全に削除するには、以下のコマンドを実行します：

```bash
# Neovim設定を削除
rm -rf ~/.config/nvim

# プラグインデータを削除
rm -rf ~/.local/share/nvim

# キャッシュを削除
rm -rf ~/.cache/nvim

# バックアップがある場合は復元
# mv ~/.config/nvim.backup.YYYYMMDDHHMMSS ~/.config/nvim
```

**注意:** 上記のコマンドは全てのNeovim関連データを削除します。必要に応じてバックアップを取ってから実行してください。

## トラブルシューティング

問題が発生した場合は、以下を確認してください：

1. `:checkhealth` を実行して環境をチェック
2. プラグインの更新: `:Lazy sync`
3. LSPサーバーの再インストール: `:Mason` で該当サーバーを再インストール

## ドキュメント

- [クイックスタート](docs/quickstart.md)
- [機能一覧](docs/features.md)
- [キーマップ詳細](docs/keymaps.md)
- [プラグイン詳細](docs/plugins.md)
- [Neovimチュートリアル](docs/neovim-tutorial.md)

## カスタマイズ

設定ファイルは `~/.config/nvim/lua/` 以下にあります：

- オプション変更: `core/options.lua`
- キーマップ追加: `core/keymaps.lua`
- プラグイン追加: `plugins/` 以下に新規ファイル作成

## License

[MIT License](LICENSE)
