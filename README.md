# dotvim

VimをIDE化するための設定です。PHP と Kotlin に対応したLSP環境を構築できます。

## 特徴

- **LSP対応**: 自動補完、定義ジャンプ、リファクタリング機能
- **ファイル操作**: NERDTree（ファイルツリー）、fzf（ファジーファインダー）
- **Git連携**: fugitive（Gitコマンド）、gitgutter（差分表示）
- **編集効率化**: コメントアウト、括弧補完、サラウンド操作
- **対応言語**: PHP（Intelephense）、Kotlin（Kotlin Language Server）

## 構成ファイル

| ファイル | 説明 |
|----------|------|
| `.vimrc` | Vim本体の設定 |
| `coc-settings.json` | LSP（coc.nvim）の設定 |
| `install.sh` | 初期構築スクリプト |
| `update-config.sh` | 設定反映スクリプト |

## セットアップ

```bash
# 1. リポジトリを取得
git clone https://github.com/Sina-TehraniFard/dotvim.git
cd dotvim

# 2. 実行権限を付与
chmod +x install.sh update-config.sh

# 3. インストール実行
./install.sh
```

`install.sh` は以下を自動実行します:

- `.vimrc` と `coc-settings.json` の配置
- vim-plug（プラグインマネージャ）の導入
- Node.js の確認と自動インストール
- PHP / Kotlin 用 LSP サーバの導入
- coc.nvim プラグインのインストール

## 設定の更新

設定ファイルを変更した場合:

```bash
./update-config.sh
```

このスクリプトは:
- 現行設定を `backups/` にバックアップ
- 最新設定をホームディレクトリへ反映

Vim起動中の場合は `:CocRestart` で即時反映できます。

## 主な機能

### LSP（コード補完・ナビゲーション）

| 操作 | 機能 |
|------|------|
| `gd` | 定義へジャンプ |
| `gy` | 型定義へジャンプ |
| `gi` | 実装へジャンプ |
| `gr` | 参照一覧を表示 |
| `K` | ドキュメントを表示 |
| `[g` / `]g` | 前後のエラーへ移動 |
| `Ctrl + Space` | 補完候補を表示 |
| `<leader>f` | コードフォーマット |
| `<leader>a` | コードアクション |
| `<leader>rn` | リネーム |

### ファイル操作

| 操作 | 機能 |
|------|------|
| `<leader>e` | ファイルツリー表示/非表示 |
| `<leader>n` | 現在のファイルをツリーで表示 |
| `Ctrl + p` | ファイル検索（fzf） |
| `<leader>b` | バッファ一覧 |
| `<leader>g` | 文字列検索（ripgrep） |
| `<leader>h` | 履歴検索 |

### Git連携

| 操作 | 機能 |
|------|------|
| `<leader>gs` | Git status |
| `<leader>gd` | Git diff（分割表示） |
| `<leader>gb` | Git blame |
| `<leader>gl` | Git log |
| `]h` / `[h` | 次/前の変更箇所へ移動 |

### 編集効率化

| 操作 | 機能 |
|------|------|
| `gcc` | 行をコメントアウト |
| `gc` + 動作 | 範囲をコメントアウト |
| `cs"'` | `"` を `'` に変更 |
| `ds"` | `"` を削除 |
| `ysiw"` | 単語を `"` で囲む |

### `<leader>` キーについて

デフォルトは `\` です。`.vimrc` で以下のように設定すると `Space` キーに変更できます:

```vim
let mapleader=" "
```

## ディレクトリ構成

```
dotvim/
├── .vimrc
├── coc-settings.json
├── install.sh
├── update-config.sh
├── .gitignore
└── backups/
```

## 必要要件

- Vim 8.0 以上（または Neovim）
- Node.js 14 以上
- Git
- ripgrep（fzfの文字列検索に必要）

## プラグイン一覧

| プラグイン | 機能 |
|-----------|------|
| coc.nvim | LSP補完エンジン |
| gruvbox | カラースキーム |
| NERDTree | ファイルツリー |
| fzf.vim | ファジーファインダー |
| vim-fugitive | Git操作 |
| vim-gitgutter | Git差分表示 |
| vim-commentary | コメントアウト |
| vim-surround | 括弧・引用符操作 |
| auto-pairs | 括弧自動補完 |
| vim-airline | ステータスライン |

## License

MIT License © 2025 Sina Tehrani Fard

