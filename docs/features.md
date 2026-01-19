# dotvim 機能一覧

このドキュメントは、dotvim プロジェクトに含まれる全ての機能をカテゴリ別にまとめたものです。

---

## 目次

1. [プロジェクト概要](#プロジェクト概要)
2. [UI・外観](#ui外観)
3. [エディタ機能](#エディタ機能)
4. [コーディング・LSP](#コーディングlsp)
5. [Git連携](#git連携)
6. [データベース接続](#データベース接続)
7. [ライティング・Markdown](#ライティングmarkdown)
8. [基本設定](#基本設定)
9. [キーマップ一覧](#キーマップ一覧)
10. [自動コマンド](#自動コマンド)
11. [インストール方法](#インストール方法)

---

## プロジェクト概要

dotvim は Neovim をモダンな IDE として使用するための設定集です。

### ファイル構成

```
dotvim/
├── nvim/
│   ├── init.lua              # エントリーポイント
│   └── lua/
│       ├── core/
│       │   ├── options.lua   # 基本設定
│       │   ├── keymaps.lua   # キーマップ
│       │   └── autocmds.lua  # 自動コマンド
│       └── plugins/
│           ├── init.lua      # lazy.nvim設定
│           ├── ui.lua        # UI関連プラグイン
│           ├── editor.lua    # エディタ機能プラグイン
│           ├── coding.lua    # コーディング関連プラグイン
│           ├── git.lua       # Git関連プラグイン
│           └── writing.lua   # ライティング関連プラグイン
└── install.sh                # インストールスクリプト
```

### プラグインマネージャ

**lazy.nvim** を使用しています。以下の機能があります：

- プラグインの遅延読み込み（起動高速化）
- 自動更新チェック
- 設定変更の自動検出

---

## UI・外観

### カラースキーム: gruvbox.nvim

暖かみのあるレトロな色調のカラースキームです。

**特徴:**
- ダークモード対応
- True Color（24bit）対応
- イタリック・ボールド・下線のスタイリング

### ステータスライン: lualine.nvim

画面下部に表示されるステータスバーです。

**表示情報:**
- 現在のモード（Normal, Insert, Visual等）
- Gitブランチ名
- 差分情報（追加/変更/削除行数）
- 診断情報（エラー/警告数）
- ファイルパス（相対パス）
- エンコーディング
- ファイルフォーマット（unix/dos）
- ファイルタイプ
- カーソル位置

**タブライン:**
- 開いているバッファの一覧
- タブの一覧

### ファイルアイコン: nvim-web-devicons

ファイルタイプに応じたアイコンを表示します。

### UI改善: dressing.nvim

入力プロンプトや選択メニューのUIを改善します。

### コマンドライン・通知: noice.nvim + nvim-notify

**noice.nvim の機能:**
- コマンドラインの改善されたUI
- LSPホバー表示の改善
- 検索カウント表示

**nvim-notify の機能:**
- アニメーション付きの通知表示
- エラー/警告/情報のアイコン表示

**キーマップ:**
| キー | 機能 |
|------|------|
| `<leader>nl` | 最後の通知を表示 |
| `<leader>nh` | 通知履歴 |
| `<leader>na` | 全ての通知 |
| `<leader>nd` | 通知を消す |

---

## エディタ機能

### ファジーファインダー: telescope.nvim

ファイルやテキストを高速に検索するためのツールです。

**キーマップ:**
| キー | 機能 |
|------|------|
| `<leader>ff` | ファイル検索 |
| `<leader>fg` | テキスト検索（grep） |
| `<leader>fb` | バッファ一覧 |
| `<leader>fh` | ヘルプタグ検索 |
| `<leader>fr` | 最近開いたファイル |
| `<leader>fs` | ドキュメントシンボル |
| `<leader>fw` | ワークスペースシンボル |
| `<leader>fd` | 診断一覧 |
| `<leader>fc` | コマンド一覧 |
| `<leader>fk` | キーマップ一覧 |
| `<C-p>` | Gitファイル検索 |

**Telescope内のキー操作:**
| キー | 機能 |
|------|------|
| `<C-j>` | 次の項目 |
| `<C-k>` | 前の項目 |
| `<C-q>` | Quickfixに送る |
| `<Esc>` | 閉じる |

### ファイルツリー: neo-tree.nvim

サイドバーにファイル一覧を表示します。

**キーマップ:**
| キー | 機能 |
|------|------|
| `<leader>e` | ファイルツリーの表示/非表示 |
| `<leader>o` | ファイルツリーにフォーカス |

**ファイルツリー内の操作:**
| キー | 機能 |
|------|------|
| `<CR>` / `o` | ファイルを開く |
| `s` | 水平分割で開く |
| `v` | 垂直分割で開く |
| `t` | 新しいタブで開く |
| `a` | 新規ファイル/フォルダ作成 |
| `d` | 削除 |
| `r` | 名前変更 |
| `y` | クリップボードにコピー |
| `x` | カット |
| `p` | ペースト |
| `c` | コピー |
| `m` | 移動 |
| `q` | 閉じる |
| `R` | 更新 |
| `?` | ヘルプ表示 |

### コメント操作: Comment.nvim

コードのコメントアウト/解除を簡単に行えます。

**キーマップ:**
| キー | 機能 |
|------|------|
| `gcc` | 現在行をコメントトグル |
| `gc` + motion | 指定範囲をコメントトグル |
| `gcap` | 段落をコメントトグル |

### 括弧・引用符操作: nvim-surround

テキストを囲む記号の追加・変更・削除ができます。

**操作例:**
| キー | 操作前 | 操作後 |
|------|--------|--------|
| `ysiw"` | `word` | `"word"` |
| `cs"'` | `"word"` | `'word'` |
| `ds"` | `"word"` | `word` |
| `yss)` | `line text` | `(line text)` |

### キーマップヘルプ: which-key.nvim

`<leader>` キーを押すと、利用可能なキーマップが表示されます。

**グループ:**
| プレフィックス | グループ名 |
|----------------|------------|
| `<leader>f` | Find（検索） |
| `<leader>g` | Git |
| `<leader>b` | Buffer |
| `<leader>c` | Code/Quickfix |
| `<leader>w` | Workspace |
| `<leader>r` | Rename |

### TODOコメント: todo-comments.nvim

コード内の TODO, FIXME, HACK などのコメントをハイライトします。

**キーマップ:**
| キー | 機能 |
|------|------|
| `]t` | 次のTODOへ |
| `[t` | 前のTODOへ |
| `<leader>ft` | TODO一覧を検索 |

### インデントガイド: indent-blankline.nvim

インデントレベルを視覚的に表示します。

### 同一単語ハイライト: vim-illuminate

カーソルを置いた単語と同じ単語を自動的にハイライトする機能です。
IntelliJ の Command+E 後のハイライトや、同一単語の自動ハイライトに相当します。

**特徴:**
- カーソル移動後、200ms で同一単語がハイライトされます
- LSP、Treesitter、正規表現の3つの方法で単語を認識
- 変数名や関数名を追跡する際に便利

**キーマップ:**
| キー | 機能 |
|------|------|
| `]]` | 次の参照へ移動 |
| `[[` | 前の参照へ移動 |

---

## コーディング・LSP

### シンタックスハイライト: nvim-treesitter

Treesitter による高精度なシンタックスハイライトを提供します。

**対応言語:**
bash, c, css, dockerfile, go, html, java, javascript, json, kotlin, lua, markdown, php, python, rust, sql, tsx, typescript, vim, yaml

**テキストオブジェクト:**
| キー | 機能 |
|------|------|
| `af` / `if` | 関数（外側/内側） |
| `ac` / `ic` | クラス（外側/内側） |
| `aa` / `ia` | 引数（外側/内側） |

**ナビゲーション:**
| キー | 機能 |
|------|------|
| `]m` | 次の関数の開始位置 |
| `[m` | 前の関数の開始位置 |
| `]]` | 次のクラスの開始位置 |
| `[[` | 前のクラスの開始位置 |

**インクリメンタル選択:**
| キー | 機能 |
|------|------|
| `<C-Space>` | 選択開始/拡大 |
| `<BS>` | 選択縮小 |

### LSPサーバー管理: mason.nvim + mason-lspconfig.nvim

言語サーバーを簡単にインストール・管理できます。

**自動インストールされるLSP:**
| サーバー | 言語 |
|----------|------|
| lua_ls | Lua |
| intelephense | PHP |
| kotlin_language_server | Kotlin |
| pyright | Python |
| ts_ls | TypeScript/JavaScript |
| html | HTML |
| cssls | CSS |
| jsonls | JSON |
| yamlls | YAML |

**使い方:**
- `:Mason` でLSPサーバー管理画面を開く

### LSP機能: nvim-lspconfig

**キーマップ（LSP接続時）:**
| キー | 機能 |
|------|------|
| `gd` | 定義へジャンプ |
| `gD` | 宣言へジャンプ |
| `gi` | 実装へジャンプ |
| `gr` | 参照一覧 |
| `gy` | 型定義へジャンプ |
| `K` | ホバー情報（ドキュメント）表示 |
| `<C-k>`（挿入モード） | シグネチャヘルプ |
| `<leader>rn` | リネーム |
| `<leader>ca` | コードアクション |
| `<leader>f` | フォーマット |
| `<leader>wa` | ワークスペースフォルダ追加 |
| `<leader>wr` | ワークスペースフォルダ削除 |
| `<leader>wl` | ワークスペースフォルダ一覧 |

**診断表示:**
| キー | 機能 |
|------|------|
| `[d` | 前の診断へ |
| `]d` | 次の診断へ |
| `<leader>d` | 診断をフロート表示 |
| `<leader>q` | 診断をロケーションリストに表示 |

### 補完エンジン: nvim-cmp

インテリジェントなコード補完を提供します。

**補完ソース:**
1. LSP（最優先）
2. スニペット
3. バッファ内の単語
4. ファイルパス

**キーマップ:**
| キー | 機能 |
|------|------|
| `<Tab>` | 次の候補 / スニペット展開 |
| `<S-Tab>` | 前の候補 |
| `<CR>` | 選択確定 |
| `<C-Space>` | 補完メニュー表示 |
| `<C-e>` | 補完キャンセル |
| `<C-b>` | ドキュメント上スクロール |
| `<C-f>` | ドキュメント下スクロール |

### スニペット: LuaSnip + friendly-snippets

多言語対応のスニペット集が利用可能です。

### 括弧自動補完: nvim-autopairs

`(` を入力すると `)` が自動挿入されます。

---

## Git連携

### Git差分表示: gitsigns.nvim

エディタのサイン列にGitの変更状況を表示します。

**サイン:**
| 記号 | 意味 |
|------|------|
| `│` | 追加行 |
| `│` | 変更行 |
| `_` | 削除行 |
| `~` | 変更削除行 |
| `┆` | 未追跡行 |

**キーマップ:**
| キー | 機能 |
|------|------|
| `]h` | 次の変更箇所 |
| `[h` | 前の変更箇所 |
| `<leader>hs` | 変更をステージ |
| `<leader>hr` | 変更をリセット |
| `<leader>hS` | バッファ全体をステージ |
| `<leader>hu` | ステージを取り消し |
| `<leader>hR` | バッファ全体をリセット |
| `<leader>hp` | 変更のプレビュー |
| `<leader>hb` | 行のblame表示 |
| `<leader>tb` | 行blameのトグル |
| `<leader>hd` | diff表示 |
| `<leader>hD` | diff表示（HEAD~） |
| `<leader>td` | 削除行表示のトグル |

**テキストオブジェクト:**
- `ih` - 変更箇所（hunk）を選択

### LazyGit統合: lazygit.nvim

ターミナルベースのGit UIをNeovim内で使用できます。

**キーマップ:**
| キー | 機能 |
|------|------|
| `<leader>gg` | LazyGitを開く |
| `<leader>gf` | 現在のファイルの履歴 |

### 高度なDiff表示: diffview.nvim

**キーマップ:**
| キー | 機能 |
|------|------|
| `<leader>gd` | Diffviewを開く |
| `<leader>gc` | Diffviewを閉じる |
| `<leader>gh` | ファイル履歴 |

---

## データベース接続

vim-dadbod を使用して、Neovim 内から直接データベースに接続してクエリを実行できます。

### 対応データベース

- PostgreSQL
- MySQL / MariaDB
- SQLite
- SQL Server
- MongoDB
- Redis

### 接続方法

1. `<leader>du` で DBUI を開く
2. `<leader>da` で新しい接続を追加
3. 接続URL形式で入力（例: `postgresql://user:pass@localhost/dbname`）

**接続URL例:**
```
# PostgreSQL
postgresql://username:password@localhost:5432/database_name

# MySQL
mysql://username:password@localhost:3306/database_name

# SQLite
sqlite:///path/to/database.db
```

### キーマップ

| キー | 機能 |
|------|------|
| `<leader>du` | DBUIを開く/閉じる |
| `<leader>da` | DB接続を追加 |
| `<leader>df` | DBバッファを検索 |
| `<leader>dr` | DBバッファをリネーム |
| `<leader>dl` | 最後のクエリ情報 |

### DBUI内の操作

- `<CR>` - テーブル選択 / クエリ実行
- `R` - 更新
- `d` - 接続を削除
- `A` - 接続を追加

### SQL補完

SQLファイル編集時、接続先データベースのテーブル名やカラム名が自動補完されます。

---

## ライティング・Markdown

### Markdownプレビュー: markdown-preview.nvim

ブラウザでMarkdownのリアルタイムプレビューができます。

**特徴:**
- Mermaid図のサポート
- 数式（KaTeX）のサポート
- ダークテーマ

**キーマップ:**
| キー | 機能 |
|------|------|
| `<leader>mp` | プレビューのトグル |

**設定:**
- ポート: 8888
- リモートアクセス: 有効

### Obsidian連携: obsidian.nvim

Obsidianのノート管理機能をNeovimで使用できます。

**Vault場所:** `~/Documents/ObsidianVault`

**キーマップ:**
| キー | 機能 |
|------|------|
| `<leader>on` | 新規ノート作成 |
| `<leader>oo` | Obsidianアプリで開く |
| `<leader>os` | ノート検索 |
| `<leader>oq` | クイック切り替え |
| `<leader>ob` | バックリンク |
| `<leader>ot` | タグ検索 |
| `<leader>od` | 今日のデイリーノート |
| `<leader>oy` | 昨日のデイリーノート |
| `<leader>ol` | 選択範囲をリンク化（Visual） |
| `<leader>of` | リンク先へ移動 |

**機能:**
- デイリーノート（daily/フォルダ）
- Wikiリンク（`[[リンク]]`形式）
- フロントマター自動生成
- チェックボックスのUIカスタマイズ

### Markdown装飾表示: render-markdown.nvim

Markdown文書をエディタ内で装飾表示します。

**表示機能:**
- 見出しのアイコン表示
- コードブロックのボーダー表示
- 箇条書きのアイコン変換
- チェックボックスのアイコン変換
- 引用符の装飾
- テーブルの装飾

---

## 基本設定

### エディタオプション

| 設定 | 値 | 説明 |
|------|-----|------|
| `number` | true | 行番号表示 |
| `relativenumber` | true | 相対行番号 |
| `expandtab` | true | タブをスペースに変換 |
| `tabstop` | 4 | タブ幅 |
| `shiftwidth` | 4 | インデント幅 |
| `smartindent` | true | スマートインデント |
| `hlsearch` | true | 検索結果ハイライト |
| `ignorecase` | true | 大文字小文字を区別しない |
| `smartcase` | true | 大文字含む場合は区別 |
| `termguicolors` | true | True Color対応 |
| `cursorline` | true | カーソル行強調 |
| `wrap` | false | 行の折り返し無効 |
| `scrolloff` | 8 | スクロール時の余白 |
| `mouse` | "a" | マウス操作有効 |
| `clipboard` | "unnamedplus" | システムクリップボード連携 |
| `updatetime` | 100ms | 更新間隔 |
| `undofile` | true | Undo履歴の永続化 |

### リーダーキー

`<Space>` がリーダーキーとして設定されています。

---

## キーマップ一覧

全てのキーマップの詳細は [keymaps.md](keymaps.md) を参照してください。

---

## 自動コマンド

### 一般的な自動コマンド

| イベント | 動作 |
|----------|------|
| ファイル変更検出 | 外部で変更されたファイルを自動再読込 |
| ヤンク時 | ヤンクした範囲を一時的にハイライト |
| ファイルを開く | 最後のカーソル位置を復元 |
| 保存時 | 末尾の空白を自動削除 |

### ファイルタイプ別設定

| ファイルタイプ | 設定 |
|----------------|------|
| Markdown | 行の折り返し有効、スペルチェック有効 |
| JSON | タブ幅2 |
| YAML | タブ幅2 |
| Lua | タブ幅2 |
| HTML/CSS/JS/TS | タブ幅2 |

### その他

| 動作 |
|------|
| ウィンドウリサイズ時にサイズを均等化 |
| ヘルプを右側に開く |
| help/man/qf/lspinfo/checkhealth で `q` で閉じる |
| 1MB以上のファイルでシンタックス無効化（パフォーマンス最適化） |

---

## インストール方法

### 自動インストール

```bash
git clone https://github.com/Sina-TehraniFard/dotvim.git
cd dotvim
chmod +x install.sh
./install.sh
```

### install.shの動作

1. **依存ツールのインストール**
   - Neovim
   - fd（ファイル検索）
   - ripgrep（テキスト検索）
   - lazygit（Git UI）
   - Node.js

2. **Neovim設定のコピー**
   - 既存設定をバックアップ
   - `nvim/` を `~/.config/nvim/` にコピー

3. **Obsidian Vaultの作成**
   - `~/Documents/ObsidianVault` を作成
   - デイリーノートテンプレートを配置

4. **プラグインのインストール**
   - lazy.nvim によるプラグイン自動インストール

### 初回起動後

1. Neovimを起動: `nvim`
2. プラグインが自動インストールされます
3. `:Mason` でLSPサーバーをインストール
4. `:checkhealth` で設定を確認

