# Neovim設定チュートリアル

このドキュメントでは、この設定ファイル群の構造と各設定の役割を解説します。
Neovimの設定をカスタマイズする際のリファレンスとしてご活用ください。

---

## 目次

1. [全体構造](#1-全体構造)
2. [core/ の理解](#2-core-の理解)
3. [plugins/ の理解](#3-plugins-の理解)
4. [LSP/補完の仕組み](#4-lsp補完の仕組み)
5. [カスタマイズガイド](#5-カスタマイズガイド)
6. [トラブルシューティング](#6-トラブルシューティング)
7. [キーマップ一覧](#7-キーマップ一覧)

---

## 1. 全体構造

### ディレクトリ構成

```
~/.config/nvim/
├── init.lua              # エントリーポイント（最初に読み込まれる）
└── lua/
    ├── core/
    │   ├── options.lua   # 基本設定（行番号、タブ幅など）
    │   ├── keymaps.lua   # キーバインド設定
    │   └── autocmds.lua  # 自動コマンド
    └── plugins/
        ├── init.lua      # lazy.nvim（プラグインマネージャ）
        ├── coding.lua    # LSP + 補完 + Treesitter
        ├── editor.lua    # ファイル操作 + 編集効率化
        ├── ui.lua        # 見た目（カラースキーム、ステータスライン）
        ├── git.lua       # Git連携
        └── writing.lua   # Markdown + Obsidian
```

### init.lua の役割

`init.lua` は Neovim 起動時に最初に読み込まれるファイルです。

```lua
require("core.options")  -- まず基本設定を読み込む
require("plugins")       -- プラグインを読み込む
require("core.keymaps")  -- キーマップを設定
require("core.autocmds") -- 自動コマンドを設定
```

**`require()` の仕組み**:
- `require("core.options")` は `lua/core/options.lua` を読み込む
- パスはドット（`.`）で区切る（スラッシュではない）
- 一度読み込んだファイルはキャッシュされ、二度目以降は再読み込みされない

### lazy.nvim の遅延読み込み

lazy.nvimは「必要なときにだけプラグインを読み込む」ことで起動を高速化します。

```lua
{
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",          -- :Telescope コマンド実行時に読み込み
  keys = {                    -- これらのキーが押されたときに読み込み
    { "<leader>ff", ... },
  },
}
```

**遅延読み込みのトリガー**:
- `event`: 特定のイベント発生時（例: `BufReadPost` = ファイルを開いたとき）
- `cmd`: 特定のコマンド実行時
- `keys`: 特定のキーが押されたとき
- `ft`: 特定のファイルタイプを開いたとき

---

## 2. core/ の理解

### options.lua: 基本設定

Neovimのオプション設定は `vim.opt` で行います。

```lua
-- 従来のVimScript
set number
set tabstop=4

-- Luaでの書き方
vim.opt.number = true
vim.opt.tabstop = 4
```

**vim.opt vs vim.o の違い**:
- `vim.opt`: テーブル形式で複数値を設定可能
- `vim.o`: 単一値のみ（VimScriptの `set` に近い）

```lua
-- vim.opt はリスト値に対応
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- vim.o は文字列のみ
vim.o.completeopt = "menu,menuone,noselect"
```

**グローバル変数の設定**:
```lua
vim.g.mapleader = " "  -- リーダーキーをスペースに
```

### keymaps.lua: キーマップ設定

`vim.keymap.set()` でキーマップを設定します。

```lua
vim.keymap.set(
  "n",              -- モード: n=ノーマル, i=インサート, v=ビジュアル
  "<leader>ff",     -- キー
  "<cmd>Telescope find_files<CR>",  -- 実行するコマンド
  { desc = "Find files" }  -- オプション（説明など）
)
```

**モードの種類**:
| モード | 説明 |
|--------|------|
| `n` | ノーマルモード |
| `i` | インサートモード |
| `v` | ビジュアルモード |
| `x` | ビジュアルモード（セレクトモード除く） |
| `s` | セレクトモード |
| `o` | オペレータ待機モード |
| `c` | コマンドラインモード |
| `t` | ターミナルモード |

### autocmds.lua: 自動コマンド

特定のイベントが発生したときに自動で実行される処理を定義します。

```lua
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "HighlightYank",      -- グループ名（管理用）
  pattern = "*",                -- 対象ファイル（*=すべて）
  callback = function()         -- 実行する処理
    vim.highlight.on_yank({ timeout = 200 })
  end,
  desc = "Highlight yanked text",
})
```

**よく使うイベント**:
| イベント | 発生タイミング |
|----------|----------------|
| `BufReadPost` | ファイル読み込み後 |
| `BufWritePre` | ファイル保存前 |
| `FileType` | ファイルタイプ検出時 |
| `VimResized` | ウィンドウリサイズ時 |
| `TextYankPost` | ヤンク（コピー）後 |

---

## 3. plugins/ の理解

### lazy.nvim の spec 構造

プラグインは「spec」と呼ばれるテーブルで定義します。

```lua
{
  "作者名/プラグイン名",  -- GitHubリポジトリ
  dependencies = {},      -- 依存プラグイン
  event = "BufReadPost",  -- 読み込みトリガー
  config = function()     -- 設定処理
    require("プラグイン名").setup({})
  end,
}
```

**設定方法のバリエーション**:

```lua
-- 方法1: config関数
config = function()
  require("plugin").setup({ option = value })
end,

-- 方法2: opts（setup()に渡すオプション）
opts = { option = value },

-- 方法3: シンプルなopts
opts = {},  -- デフォルト設定でsetup()が呼ばれる
```

### 各プラグインファイルの役割

| ファイル | 内容 |
|----------|------|
| `coding.lua` | Treesitter（シンタックス）、LSP、補完 |
| `editor.lua` | Telescope、Neo-tree、編集ユーティリティ |
| `ui.lua` | Gruvbox、Lualine、通知UI |
| `git.lua` | Gitsigns、LazyGit、Diffview |
| `writing.lua` | Markdownプレビュー、Obsidian連携 |

---

## 4. LSP/補完の仕組み

### 構成要素の関係

```
┌─────────────────────────────────────────────────────┐
│ mason.nvim                                          │
│  └─ 言語サーバーのインストール管理                    │
└─────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────┐
│ mason-lspconfig.nvim                                │
│  └─ masonとlspconfigの橋渡し                        │
└─────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────┐
│ nvim-lspconfig                                      │
│  └─ 言語サーバーの設定・起動                         │
└─────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────┐
│ nvim-cmp                                            │
│  └─ 補完メニューの表示・選択                         │
│     └─ cmp-nvim-lsp: LSPからの補完                  │
│     └─ cmp-buffer: バッファからの補完               │
│     └─ cmp-path: ファイルパスの補完                 │
│     └─ cmp_luasnip: スニペットの補完                │
└─────────────────────────────────────────────────────┘
```

### 言語サーバーの追加方法

1. `:Mason` を開く
2. インストールしたいサーバーを選択してインストール
3. `coding.lua` の `servers` テーブルに設定を追加

```lua
local servers = {
  lua_ls = { ... },
  intelephense = { ... },
  -- 新しいサーバーを追加
  rust_analyzer = {},
}
```

### on_attach の役割

`on_attach` は、LSPがバッファに接続したときに実行される関数です。
ここでLSP関連のキーマップを設定します。

```lua
local on_attach = function(client, bufnr)
  -- このバッファでのみ有効なキーマップ
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
end
```

---

## 5. カスタマイズガイド

### キーバインドの変更

`core/keymaps.lua` を編集します。

```lua
-- 例: <leader>e を <leader>t に変更
vim.keymap.set("n", "<leader>t", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
```

### プラグインの追加

対応するカテゴリのファイルに追加します。

```lua
-- plugins/editor.lua に追加する例
{
  "作者/新しいプラグイン",
  event = "VeryLazy",
  config = function()
    require("新しいプラグイン").setup({})
  end,
},
```

追加後、`:Lazy` で Sync を実行します。

### プラグインの無効化

`enabled = false` を追加します。

```lua
{
  "プラグイン名",
  enabled = false,  -- このプラグインを無効化
}
```

### カラースキームの変更

`plugins/ui.lua` で別のカラースキームに変更できます。

```lua
{
  "folke/tokyonight.nvim",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("tokyonight")
  end,
},
```

---

## 6. トラブルシューティング

### 基本的なデバッグコマンド

| コマンド | 説明 |
|----------|------|
| `:checkhealth` | 全体の健全性チェック |
| `:LspInfo` | LSPの状態確認 |
| `:LspLog` | LSPのログ確認 |
| `:Lazy` | プラグイン管理画面 |
| `:Mason` | 言語サーバー管理画面 |
| `:messages` | 直近のメッセージ確認 |

### よくある問題と解決策

**1. プラグインが読み込まれない**
```
:Lazy を開いて Sync を実行
```

**2. LSPが動作しない**
```
:LspInfo で状態確認
:Mason で言語サーバーがインストールされているか確認
```

**3. Treesitterのハイライトがおかしい**
```
:TSUpdate で文法ファイルを更新
:TSInstall {言語} で特定の言語をインストール
```

**4. 補完が表示されない**
```
:LspInfo でLSPが接続しているか確認
InsertモードでCtrl+Spaceを押して手動トリガー
```

### ログの確認

```lua
-- Neovimのログ
:messages

-- LSPのログ
:LspLog

-- lazy.nvimのログ
:Lazy log
```

---

## 7. キーマップ一覧

### 基本操作

| キー | 説明 |
|------|------|
| `jk` | インサートモードからノーマルモードへ |
| `<Esc>` | 検索ハイライトを消す |
| `<C-s>` | 保存 |

### クリップボード

| キー | 説明 |
|------|------|
| `<C-c>` | （ビジュアルモード）クリップボードにコピー |
| `<C-v>` | クリップボードからペースト |

### ウィンドウ操作

| キー | 説明 |
|------|------|
| `<C-h/j/k/l>` | ウィンドウ間移動 |
| `<C-↑/↓/←/→>` | ウィンドウサイズ変更 |

### バッファ操作

| キー | 説明 |
|------|------|
| `<S-h>` | 前のバッファ |
| `<S-l>` | 次のバッファ |
| `<leader>bd` | バッファを閉じる |

### ファイル操作（Telescope）

| キー | 説明 |
|------|------|
| `<leader>ff` | ファイル検索 |
| `<leader>fg` | 文字列検索（grep） |
| `<leader>fb` | バッファ一覧 |
| `<leader>fr` | 最近開いたファイル |
| `<C-p>` | Gitファイル検索 |

### ファイルツリー（Neo-tree）

| キー | 説明 |
|------|------|
| `<leader>e` | ファイルツリーのトグル |
| `<leader>o` | ファイルツリーにフォーカス |

### LSP

| キー | 説明 |
|------|------|
| `gd` | 定義にジャンプ |
| `gr` | 参照一覧 |
| `K` | ホバー（ドキュメント表示） |
| `<leader>rn` | リネーム |
| `<leader>ca` | コードアクション |
| `<leader>f` | フォーマット |
| `[d` / `]d` | 前/次の診断へ |

### Git

| キー | 説明 |
|------|------|
| `<leader>gg` | LazyGitを開く |
| `<leader>gd` | Diffviewを開く |
| `<leader>gh` | ファイル履歴 |
| `[h` / `]h` | 前/次のhunkへ |
| `<leader>hs` | hunkをステージ |
| `<leader>hr` | hunkをリセット |
| `<leader>hp` | hunkをプレビュー |
| `<leader>tb` | 行blameをトグル |

### Obsidian

| キー | 説明 |
|------|------|
| `<leader>on` | 新規ノート |
| `<leader>os` | ノート検索 |
| `<leader>od` | 今日のノート |
| `<leader>ob` | バックリンク |
| `<leader>ot` | タグ一覧 |

### Markdown

| キー | 説明 |
|------|------|
| `<leader>mp` | Markdownプレビュー |

---

## 参考リンク

- [Neovim 公式ドキュメント](https://neovim.io/doc/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
