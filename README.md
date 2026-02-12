# dotvim

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Neovim](https://img.shields.io/badge/Neovim-0.9+-brightgreen.svg)](https://neovim.io/)
[![Plugin Manager](https://img.shields.io/badge/Plugin%20Manager-lazy.nvim-blue.svg)](https://github.com/folke/lazy.nvim)
[![Colorscheme](https://img.shields.io/badge/Theme-Tokyo%20Night-bb9af7.svg)](https://github.com/folke/tokyonight.nvim)

Neovim を IDE 化するための設定です。macOS / Linux に対応しています。

<!-- TODO: スクリーンショットを追加
![dotvim screenshot](./docs/images/screenshot.png)
-->

## 特徴

- **LSP & 補完** — [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) による定義ジャンプ、リファクタリング、インテリジェント補完
- **多言語対応** — Lua, Python, TypeScript, PHP, Kotlin, Scala, Go, Rust, HTML, CSS, JSON, YAML
- **高速検索** — [Telescope](https://github.com/nvim-telescope/telescope.nvim) ファジーファインダー + [grug-far](https://github.com/MagicDuck/grug-far.nvim) プロジェクト全体置換
- **Git 統合** — [LazyGit](https://github.com/kdheepak/lazygit.nvim) + [gitsigns](https://github.com/lewis6991/gitsigns.nvim) + [diffview](https://github.com/sindrets/diffview.nvim)
- **DB クライアント** — [vim-dadbod](https://github.com/tpope/vim-dadbod) で MySQL / PostgreSQL / SQLite をエディタ内操作
- **執筆環境** — [Obsidian](https://github.com/epwalsh/obsidian.nvim) 連携 + [Markdown 装飾表示](https://github.com/MeanderingProgrammer/render-markdown.nvim)
- **快適な UI** — [noice.nvim](https://github.com/folke/noice.nvim) コマンドパレット + [smear-cursor](https://github.com/sphamba/smear-cursor.nvim) アニメーション + 自動保存

## クイックスタート

### 必要要件

- **Neovim** 0.9 以上
- **Node.js** 16 以上
- **Git**
- [**Nerd Font**](https://www.nerdfonts.com/) — アイコン表示に必要（推奨: [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases)）

### インストール

```bash
git clone https://github.com/Sina-TehraniFard/dotfiles.git
cd dotfiles
./install.sh
```

`install.sh` が以下を自動で行います:

- Neovim のインストール（未インストールの場合）
- 依存ツール（fd, ripgrep, lazygit, node）のインストール
- `~/.config/nvim` への設定ファイル配置
- Obsidian Vault ディレクトリの作成
- プラグインの初期インストール

### 初回起動

```bash
nvim
```

1. プラグインが自動インストールされます（初回のみ）
2. `:Mason` で LSP サーバーを確認・追加インストール
3. `:checkhealth` で環境チェック

<details>
<summary>Nerd Font のインストール手順</summary>

```bash
# macOS (Homebrew)
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font

# Linux (手動)
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "JetBrainsMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip JetBrainsMono.zip
fc-cache -fv
```

インストール後、ターミナルのフォント設定を Nerd Font に変更してください。

</details>

## ディレクトリ構成

```
nvim/
├── init.lua                # エントリーポイント
├── lazy-lock.json          # プラグインバージョン固定
└── lua/
    ├── core/
    │   ├── options.lua     # Neovim オプション
    │   ├── keymaps.lua     # グローバルキーマップ
    │   └── autocmds.lua    # 自動コマンド
    └── plugins/
        ├── init.lua        # lazy.nvim 初期化
        ├── ui.lua          # テーマ・ステータスライン・通知
        ├── editor.lua      # 検索・ファイルツリー・編集効率化
        ├── coding.lua      # LSP・補完・フォーマッター
        ├── git.lua         # Git 連携
        ├── database.lua    # データベース操作
        ├── writing.lua     # Markdown・Obsidian
        └── scala.lua       # Scala 開発 (Metals)
```

## プラグイン一覧

### UI & テーマ

| プラグイン | 説明 |
|:---|:---|
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | カラースキーム（night スタイル、カスタム暗背景） |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | バッファタブライン |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | ステータスライン |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | ファイルタイプアイコン |
| [dressing.nvim](https://github.com/stevearc/dressing.nvim) | 入力・選択 UI の改善 |
| [noice.nvim](https://github.com/folke/noice.nvim) | コマンドパレット・メッセージ UI |
| [nvim-notify](https://github.com/rcarriga/nvim-notify) | 通知ポップアップ |
| [neoscroll.nvim](https://github.com/karb94/neoscroll.nvim) | スムーズスクロール |
| [mini.animate](https://github.com/echasnovski/mini.animate) | ウィンドウリサイズ・開閉アニメーション |
| [smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim) | カーソルアニメーション |

### エディタ

| プラグイン | 説明 |
|:---|:---|
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | ファジーファインダー（FZF ネイティブバックエンド） |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | ファイルツリー（Git ステータス表示） |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | コメントトグル（Treesitter 連携） |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | 括弧・引用符の追加・変更・削除 |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | キーマップヘルプ表示 |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | TODO/FIXME コメントハイライト |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | インデントガイド |
| [vim-illuminate](https://github.com/RRethy/vim-illuminate) | カーソル下の単語ハイライト |
| [flash.nvim](https://github.com/folke/flash.nvim) | 画面内高速ジャンプ |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | 診断・TODO リスト |
| [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) | プロジェクト全体の検索＆置換 |
| [auto-save.nvim](https://github.com/okuuva/auto-save.nvim) | 自動保存（1 秒デバウンス） |

### コーディング

| プラグイン | 説明 |
|:---|:---|
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | シンタックスハイライト・テキストオブジェクト |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP 設定（9 言語サーバー） |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP / フォーマッター管理 |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | 補完エンジン（LSP / バッファ / パス / スニペット） |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | スニペットエンジン + VSCode スニペット集 |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | 括弧・引用符の自動補完 |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | 保存時フォーマット（stylua, black, prettier 等） |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Neovim Lua API の補完強化 |
| [nvim-metals](https://github.com/scalameta/nvim-metals) | Scala LSP (Metals) |

### Git

| プラグイン | 説明 |
|:---|:---|
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git 差分表示・hunk 操作・blame |
| [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) | LazyGit TUI 統合 |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | 高度な Diff 表示・ファイル履歴 |

### データベース

| プラグイン | 説明 |
|:---|:---|
| [vim-dadbod](https://github.com/tpope/vim-dadbod) | データベースクエリ実行 |
| [vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui) | DB ブラウザ UI |
| [vim-dadbod-completion](https://github.com/kristijanhusak/vim-dadbod-completion) | SQL 補完（テーブル名・カラム名） |

### 執筆

| プラグイン | 説明 |
|:---|:---|
| [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim) | Obsidian Vault 連携（ノート作成・リンク・デイリーノート） |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Markdown 装飾表示（見出し・チェックボックス・テーブル） |

## キーマップ

`<leader>` = **Space**

```
<leader> キーマップ
┌──────────┬──────────┬──────────┬──────────┐
│ f: 検索  │ g: Git   │ b: バッファ│ x: 診断  │
│ h: Hunk  │ d: DB    │ o: Obsidian│ n: 通知  │
│ r: 名前  │ c: コード│ s: 置換   │ w: WS    │
│ t: トグル│ e: ツリー│ 1-5: タブ │          │
└──────────┴──────────┴──────────┴──────────┘
```

<details open>
<summary><strong>基本操作</strong> — <code>jk</code> Escape / <code>Ctrl+S</code> 保存 / <code>Ctrl+C</code> コピー</summary>

| キー | モード | 機能 |
|:---|:---|:---|
| `jk` | Insert | ノーマルモードに戻る |
| `Esc` | Normal | 検索ハイライトを消す |
| `Ctrl+S` | Normal / Insert | 保存 |
| `Ctrl+C` | Visual | クリップボードにコピー |
| `Ctrl+V` | Normal / Insert / Visual | クリップボードからペースト |
| `Ctrl+A` | Normal | 全選択 |
| `dd` | Normal | 行削除（レジスタ汚さない） |
| `x` | Normal | 文字削除（レジスタ汚さない） |
| `p` | Visual | ペースト（レジスタ維持） |
| `Y` | Normal | 行末までヤンク |

</details>

<details>
<summary><strong>ウィンドウ & バッファ</strong> — <code>Ctrl+H/J/K/L</code> 移動 / <code>S-h</code><code>S-l</code> タブ切替</summary>

| キー | モード | 機能 |
|:---|:---|:---|
| `Ctrl+H/J/K/L` | Normal | ウィンドウ間移動 |
| `Ctrl+↑/↓/←/→` | Normal | ウィンドウサイズ変更 |
| `S-h` | Normal | 前のバッファ |
| `S-l` | Normal | 次のバッファ |
| `<leader>bd` | Normal | バッファ削除 |
| `<leader>bp` | Normal | ピン留めトグル |
| `<leader>bP` | Normal | ピン留め以外を閉じる |
| `<leader>bo` | Normal | 他のバッファを閉じる |
| `<leader>br` | Normal | 右のバッファを閉じる |
| `<leader>bl` | Normal | 左のバッファを閉じる |
| `<leader>1` - `5` | Normal | バッファ 1〜5 に移動 |

</details>

<details>
<summary><strong>検索</strong> (Telescope) — <code>ff</code> ファイル / <code>fg</code> テキスト / <code>fb</code> バッファ</summary>

| キー | 機能 |
|:---|:---|
| `<leader>ff` | ファイル検索 |
| `<leader>fg` | テキスト検索（live grep） |
| `<leader>fb` | バッファ一覧 |
| `<leader>fr` | 最近開いたファイル |
| `<leader>fh` | ヘルプタグ検索 |
| `<leader>fs` | ドキュメントシンボル |
| `<leader>fw` | ワークスペースシンボル |
| `<leader>fd` | 診断一覧 |
| `<leader>fc` | コマンド一覧 |
| `<leader>fk` | キーマップ検索 |
| `<leader>ft` | TODO 検索 |
| `Ctrl+P` | Git ファイル検索 |

</details>

<details>
<summary><strong>コード編集</strong> — <code>gcc</code> コメント / <code>ys</code> 囲み追加 / <code>Alt+J/K</code> 行移動</summary>

| キー | モード | 機能 |
|:---|:---|:---|
| `gcc` | Normal | 行コメントトグル |
| `gc{motion}` | Normal / Visual | 範囲コメントトグル |
| `ys{motion}{char}` | Normal | 囲みを追加 |
| `cs{old}{new}` | Normal | 囲みを変更 |
| `ds{char}` | Normal | 囲みを削除 |
| `Alt+J` / `Alt+K` | Normal / Insert / Visual | 行を上下に移動 |
| `<` / `>` | Visual | インデント（選択維持） |
| `<leader>f` | Normal / Visual | フォーマット |
| `<leader>sr` | Normal / Visual | 検索＆置換 (grug-far) |
| `<leader>ta` | Normal | 自動保存トグル |

</details>

<details>
<summary><strong>LSP</strong> — <code>gd</code> 定義 / <code>gr</code> 参照 / <code>K</code> ホバー</summary>

| キー | モード | 機能 |
|:---|:---|:---|
| `gd` | Normal | 定義へジャンプ |
| `gD` | Normal | 宣言へジャンプ |
| `gi` | Normal | 実装へジャンプ |
| `gr` | Normal | 参照一覧 |
| `gy` | Normal | 型定義へジャンプ |
| `K` | Normal | ホバードキュメント |
| `Ctrl+K` | Insert | シグネチャヘルプ |
| `<leader>rn` | Normal | リネーム |
| `<leader>ca` | Normal / Visual | コードアクション |
| `[d` / `]d` | Normal | 前後の診断へ移動 |
| `<leader>xd` | Normal | 診断フロート表示 |
| `<leader>wa` | Normal | ワークスペースフォルダ追加 |
| `<leader>wr` | Normal | ワークスペースフォルダ削除 |

</details>

<details>
<summary><strong>ジャンプ & ナビゲーション</strong> — <code>s</code> Flash / <code>]m</code> 関数 / <code>]]</code> 参照</summary>

| キー | モード | 機能 |
|:---|:---|:---|
| `s` | Normal / Visual / Operator | Flash ジャンプ |
| `S` | Normal / Operator | Flash Treesitter |
| `r` | Operator | リモート Flash |
| `R` | Operator / Visual | Treesitter Search |
| `]m` / `[m` | Normal | 次/前の関数 |
| `]M` / `[M` | Normal | 関数の終端 |
| `]]` / `[[` | Normal | 次/前の参照 |
| `]t` / `[t` | Normal | 次/前の TODO |
| `af` / `if` | Visual / Operator | 関数（外側/内側）選択 |
| `ac` / `ic` | Visual / Operator | クラス（外側/内側）選択 |
| `aa` / `ia` | Visual / Operator | 引数（外側/内側）選択 |
| `Ctrl+Space` | Normal / Visual | 選択範囲の拡大 |
| `Backspace` | Visual | 選択範囲の縮小 |

</details>

<details>
<summary><strong>Git</strong> — <code>gg</code> LazyGit / <code>hs</code> ステージ / <code>hb</code> blame</summary>

| キー | 機能 |
|:---|:---|
| `<leader>gg` | LazyGit を開く |
| `<leader>gf` | LazyGit（現在のファイル） |
| `<leader>gd` | Diffview を開く |
| `<leader>gc` | Diffview を閉じる |
| `<leader>gh` | ファイル履歴 |
| `]h` / `[h` | 次/前の hunk へ移動 |
| `<leader>hs` | hunk をステージ |
| `<leader>hr` | hunk をリセット |
| `<leader>hS` | バッファ全体をステージ |
| `<leader>hu` | ステージ取り消し |
| `<leader>hR` | バッファ全体をリセット |
| `<leader>hp` | hunk プレビュー |
| `<leader>hb` | blame 表示 |
| `<leader>hd` | diff 表示 |
| `<leader>tb` | インライン blame トグル |
| `<leader>td` | 削除行表示トグル |
| `ih` | hunk テキストオブジェクト |

</details>

<details>
<summary><strong>診断 & Trouble</strong> — <code>xx</code> 全診断 / <code>xt</code> TODO / <code>co</code> quickfix</summary>

| キー | 機能 |
|:---|:---|
| `<leader>xx` | 全診断 (Trouble) |
| `<leader>xX` | バッファ内診断 (Trouble) |
| `<leader>xt` | TODO 一覧 (Trouble) |
| `<leader>xL` | Location List (Trouble) |
| `<leader>xQ` | Quickfix List (Trouble) |
| `<leader>co` | Quickfix を開く |
| `<leader>cc` | Quickfix を閉じる |
| `[q` / `]q` | 前後の quickfix |

</details>

<details>
<summary><strong>データベース</strong> — <code>du</code> DBUI / <code>da</code> 接続追加 / <code>df</code> バッファ検索</summary>

| キー | 機能 |
|:---|:---|
| `<leader>du` | DBUI を開く/閉じる |
| `<leader>da` | DB 接続を追加 |
| `<leader>df` | DB バッファを検索 |
| `<leader>dr` | DB バッファをリネーム |
| `<leader>dl` | 最後のクエリ情報 |

</details>

<details>
<summary><strong>Obsidian</strong> — <code>on</code> 新規ノート / <code>od</code> 今日 / <code>os</code> 検索</summary>

| キー | 機能 |
|:---|:---|
| `<leader>on` | 新規ノート |
| `<leader>oo` | Obsidian で開く |
| `<leader>os` | ノート検索 |
| `<leader>oq` | クイックスイッチ |
| `<leader>ob` | バックリンク |
| `<leader>ot` | タグ検索 |
| `<leader>od` | 今日のデイリーノート |
| `<leader>oy` | 昨日のデイリーノート |
| `<leader>ol` | リンク作成（Visual） |
| `<leader>of` | リンクをたどる |
| `Enter` | チェックボックストグル（Markdown） |

</details>

<details>
<summary><strong>通知 & UI</strong> — <code>nl</code> 最新メッセージ / <code>nd</code> 通知消去</summary>

| キー | 機能 |
|:---|:---|
| `<leader>nl` | 最新のメッセージ |
| `<leader>nh` | メッセージ履歴 |
| `<leader>na` | 全メッセージ |
| `<leader>nd` | 通知を全て消す |

</details>

<details>
<summary><strong>補完</strong> (nvim-cmp) — <code>Tab</code> 次候補 / <code>CR</code> 確定 / <code>Ctrl+Space</code> 手動補完</summary>

| キー | モード | 機能 |
|:---|:---|:---|
| `Tab` | Insert | 次の補完候補 / スニペット展開 |
| `S-Tab` | Insert | 前の補完候補 |
| `Enter` | Insert | 補完確定 |
| `Ctrl+Space` | Insert | 補完を手動トリガー |
| `Ctrl+E` | Insert | 補完キャンセル |
| `Ctrl+B` / `Ctrl+F` | Insert | ドキュメントスクロール |

</details>

<details>
<summary><strong>Scala (Metals)</strong> — <code>mc</code> コマンド / <code>ws</code> ワークシート</summary>

| キー | 機能 |
|:---|:---|
| `<leader>mc` | Metals コマンド一覧 |
| `<leader>ws` | ワークシートホバー |

</details>

## カスタマイズ

設定ファイルは `~/.config/nvim/lua/` にあります:

| やりたいこと | ファイル |
|:---|:---|
| Neovim オプション変更 | `core/options.lua` |
| キーマップ追加 | `core/keymaps.lua` |
| テーマ・UI 変更 | `plugins/ui.lua` |
| LSP / 補完設定 | `plugins/coding.lua` |
| プラグイン追加 | `plugins/` に新規ファイル |

## トラブルシューティング

| 症状 | 対処 |
|:---|:---|
| 表示が崩れる | ターミナルのフォントを Nerd Font に変更 |
| プラグインエラー | `:Lazy sync` でプラグイン更新 |
| LSP が動かない | `:Mason` で該当サーバーを再インストール |
| 全般的な問題 | `:checkhealth` で環境チェック |

## ドキュメント

- [クイックスタート](docs/quickstart.md)
- [機能一覧](docs/features.md)
- [キーマップ詳細](docs/keymaps.md)
- [プラグイン詳細](docs/plugins.md)
- [Neovim チュートリアル](docs/neovim-tutorial.md)

## License

[MIT License](LICENSE)
