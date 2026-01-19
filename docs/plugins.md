# プラグイン一覧

dotvim で使用している全プラグインの詳細です。

---

## 目次

1. [UI関連](#ui関連)
2. [エディタ機能](#エディタ機能)
3. [コーディング](#コーディング)
4. [Git連携](#git連携)
5. [データベース](#データベース)
6. [ライティング](#ライティング)

---

## UI関連

### gruvbox.nvim
- **リポジトリ**: ellisonleao/gruvbox.nvim
- **用途**: カラースキーム
- **読み込み**: 即時（priority: 1000）

暖かみのあるレトロなカラースキームです。

**設定オプション:**
- ターミナルカラー対応
- イタリック（文字列、コメント等）
- ボールド
- 下線・取り消し線

---

### bufferline.nvim
- **リポジトリ**: akinsho/bufferline.nvim
- **用途**: バッファタブライン
- **読み込み**: VeryLazy
- **依存**: nvim-web-devicons

画面上部にバッファをタブ形式で表示するプラグインです。

**機能:**
- バッファを番号付きで表示（ordinal）
- LSP診断情報の表示
- Neo-tree との連携（オフセット表示）
- バッファのピン留め
- ホバー時に閉じるボタン表示

**設定:**
- 区切りスタイル: slant
- バッファ名最大長: 30文字
- タブサイズ: 21
- 常時表示: 有効

**キーマップ:**
| キー | 機能 |
|------|------|
| `<S-h>` | 前のバッファ |
| `<S-l>` | 次のバッファ |
| `<leader>bp` | バッファをピン留め |
| `<leader>bP` | ピン留めされていないバッファを閉じる |
| `<leader>bo` | 他のバッファを閉じる |
| `<leader>br` | 右側のバッファを閉じる |
| `<leader>bl` | 左側のバッファを閉じる |
| `<leader>1` - `<leader>5` | バッファ1〜5に直接移動 |

---

### lualine.nvim
- **リポジトリ**: nvim-lualine/lualine.nvim
- **用途**: ステータスライン
- **読み込み**: VeryLazy
- **依存**: nvim-web-devicons

高機能なステータスラインです。

**セクション構成:**

| セクション | 表示内容 |
|------------|----------|
| A | モード |
| B | ブランチ、差分、診断 |
| C | ファイル名（相対パス） |
| X | エンコーディング、フォーマット、ファイルタイプ |
| Y | 進捗（%） |
| Z | 行:列 |

---

### nvim-web-devicons
- **リポジトリ**: nvim-tree/nvim-web-devicons
- **用途**: ファイルアイコン
- **読み込み**: 遅延

ファイルタイプに応じたアイコンを提供します。

---

### dressing.nvim
- **リポジトリ**: stevearc/dressing.nvim
- **用途**: UI改善
- **読み込み**: VeryLazy

`vim.ui.input()` と `vim.ui.select()` のUIを改善します。

**特徴:**
- 丸角ボーダーの入力ウィンドウ
- Telescope統合の選択メニュー

---

### noice.nvim
- **リポジトリ**: folke/noice.nvim
- **用途**: コマンドライン・メッセージUI
- **読み込み**: VeryLazy
- **依存**: nui.nvim, nvim-notify

コマンドラインとメッセージ表示を改善します。

**機能:**
- 下部に検索UI表示
- コマンドパレット風のUI
- LSPドキュメントのボーダー表示
- 「written」メッセージの非表示

**キーマップ:**
| キー | 機能 |
|------|------|
| `<leader>nl` | 最後のメッセージ |
| `<leader>nh` | メッセージ履歴 |
| `<leader>na` | 全メッセージ |
| `<leader>nd` | メッセージを消す |

---

### nvim-notify
- **リポジトリ**: rcarriga/nvim-notify
- **用途**: 通知表示
- **読み込み**: 遅延

アニメーション付きの通知を表示します。

**設定:**
- FPS: 30
- 最小幅: 50
- タイムアウト: 3秒
- 表示位置: 上部
- アニメーション: フェードイン・スライドアウト

---

## エディタ機能

### telescope.nvim
- **リポジトリ**: nvim-telescope/telescope.nvim
- **用途**: ファジーファインダー
- **読み込み**: コマンド実行時
- **依存**: plenary.nvim, telescope-fzf-native.nvim, nvim-web-devicons

高機能なファジーファインダーです。

**設定:**
- プロンプト位置: 上部
- プレビュー幅: 55%
- ソート順: 昇順
- 無視パターン: node_modules, .git/, vendor/, *.lock

**キーマップ:**
| キー | 機能 |
|------|------|
| `<leader>ff` | ファイル検索 |
| `<leader>fg` | テキスト検索 |
| `<leader>fb` | バッファ一覧 |
| `<leader>fh` | ヘルプタグ |
| `<leader>fr` | 最近のファイル |
| `<leader>fs` | ドキュメントシンボル |
| `<leader>fw` | ワークスペースシンボル |
| `<leader>fd` | 診断 |
| `<leader>fc` | コマンド |
| `<leader>fk` | キーマップ |
| `<C-p>` | Gitファイル |

---

### neo-tree.nvim
- **リポジトリ**: nvim-neo-tree/neo-tree.nvim
- **用途**: ファイルツリー
- **読み込み**: コマンド実行時
- **依存**: plenary.nvim, nvim-web-devicons, nui.nvim

サイドバー型のファイルエクスプローラーです。

**設定:**
- 位置: 左
- 幅: 35
- 最後のウィンドウなら自動で閉じる
- Gitステータス表示
- 診断情報表示
- 現在のファイルを自動追跡

**キーマップ:**
| キー | 機能 |
|------|------|
| `<leader>e` | 表示/非表示 |
| `<leader>o` | フォーカス |

---

### Comment.nvim
- **リポジトリ**: numToStr/Comment.nvim
- **用途**: コメント操作
- **読み込み**: BufReadPost, BufNewFile
- **依存**: nvim-ts-context-commentstring

Treesitter対応のコメントトグルプラグインです。

**使い方:**
- `gcc` - 行コメントトグル
- `gc{motion}` - 範囲コメントトグル

---

### nvim-surround
- **リポジトリ**: kylechui/nvim-surround
- **用途**: 括弧・引用符操作
- **読み込み**: BufReadPost, BufNewFile

テキストを囲む記号の操作を行います。

**使い方:**
- `ys{motion}{char}` - 囲みを追加
- `cs{char1}{char2}` - 囲みを変更
- `ds{char}` - 囲みを削除

---

### which-key.nvim
- **リポジトリ**: folke/which-key.nvim
- **用途**: キーマップヘルプ
- **読み込み**: VeryLazy

キーを押すと利用可能なキーマップを表示します。

**登録グループ:**
| プレフィックス | グループ名 |
|----------------|------------|
| `<leader>f` | Find |
| `<leader>g` | Git |
| `<leader>b` | Buffer |
| `<leader>c` | Code/Quickfix |
| `<leader>w` | Workspace |
| `<leader>r` | Rename |

---

### todo-comments.nvim
- **リポジトリ**: folke/todo-comments.nvim
- **用途**: TODOコメントハイライト
- **読み込み**: BufReadPost, BufNewFile
- **依存**: plenary.nvim

TODO, FIXME, HACK などのコメントをハイライトします。

**キーマップ:**
| キー | 機能 |
|------|------|
| `]t` | 次のTODO |
| `[t` | 前のTODO |
| `<leader>ft` | TODO検索 |

---

### indent-blankline.nvim
- **リポジトリ**: lukas-reineke/indent-blankline.nvim
- **用途**: インデントガイド
- **読み込み**: BufReadPost, BufNewFile

インデントレベルを縦線で可視化します。

**設定:**
- インデント文字: `│`
- スコープ表示: 有効
- 除外ファイルタイプ: help, dashboard, neo-tree, Trouble, lazy, mason

---

### nvim-ts-context-commentstring
- **リポジトリ**: JoosepAlviste/nvim-ts-context-commentstring
- **用途**: コンテキスト対応コメント
- **読み込み**: 遅延

Treesitterでコンテキストに応じたコメント形式を使用します。
（JSX内ではJSXコメント等）

---

### vim-illuminate
- **リポジトリ**: RRethy/vim-illuminate
- **用途**: カーソル下の単語をハイライト
- **読み込み**: BufReadPost, BufNewFile

カーソルを置いた単語と同じ単語を自動的にハイライトします。
IntelliJ の同一単語ハイライトに相当する機能です。

**特徴:**
- LSP、Treesitter、正規表現の3つのプロバイダーを優先度順に使用
- 大きなファイル（2000行以上）では自動無効化
- 特定のファイルタイプ（neo-tree, help等）では無効

**設定:**
- ハイライト遅延: 200ms
- 最小出現回数: 1

**キーマップ:**
| キー | 機能 |
|------|------|
| `]]` | 次の参照へ移動 |
| `[[` | 前の参照へ移動 |

---

## コーディング

### nvim-treesitter
- **リポジトリ**: nvim-treesitter/nvim-treesitter
- **用途**: シンタックスハイライト・テキストオブジェクト
- **読み込み**: BufReadPost, BufNewFile
- **依存**: nvim-treesitter-textobjects

Treesitterによる高精度なシンタックスハイライトです。

**自動インストール言語:**
bash, c, css, dockerfile, go, html, java, javascript, json, kotlin, lua, markdown, markdown_inline, php, python, rust, sql, tsx, typescript, vim, vimdoc, yaml

**機能:**
- シンタックスハイライト
- インデント
- インクリメンタル選択
- テキストオブジェクト（関数、クラス、引数）
- ナビゲーション

---

### nvim-treesitter-textobjects
- **リポジトリ**: nvim-treesitter/nvim-treesitter-textobjects
- **用途**: Treesitterテキストオブジェクト
- **読み込み**: 遅延

関数やクラスをテキストオブジェクトとして操作できます。

**テキストオブジェクト:**
| キー | 対象 |
|------|------|
| `af` / `if` | 関数 |
| `ac` / `ic` | クラス |
| `aa` / `ia` | 引数 |

**ナビゲーション:**
| キー | 移動先 |
|------|--------|
| `]m` | 次の関数開始 |
| `]M` | 次の関数終了 |
| `[m` | 前の関数開始 |
| `[M` | 前の関数終了 |
| `]]` | 次のクラス開始 |
| `][` | 次のクラス終了 |
| `[[` | 前のクラス開始 |
| `[]` | 前のクラス終了 |

---

### mason.nvim
- **リポジトリ**: williamboman/mason.nvim
- **用途**: LSPサーバー管理
- **読み込み**: コマンド実行時

LSPサーバー、DAP、Linter、Formatterを管理します。

**使い方:**
`:Mason` でUI起動

---

### mason-lspconfig.nvim
- **リポジトリ**: williamboman/mason-lspconfig.nvim
- **用途**: MasonとLSPの連携
- **依存**: mason.nvim, nvim-lspconfig

**自動インストールサーバー:**
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

---

### nvim-lspconfig
- **リポジトリ**: neovim/nvim-lspconfig
- **用途**: LSP設定
- **読み込み**: BufReadPre, BufNewFile
- **依存**: mason.nvim, mason-lspconfig.nvim, cmp-nvim-lsp, neodev.nvim

言語サーバーとの接続を設定します。

**診断設定:**
- 仮想テキスト: 有効（プレフィックス: ●）
- サイン: 有効
- 下線: 有効
- 挿入モード中の更新: 無効

**診断アイコン:**
| 種類 | アイコン |
|------|----------|
| Error | ` ` |
| Warn | ` ` |
| Hint | `󰌵 ` |
| Info | ` ` |

---

### nvim-cmp
- **リポジトリ**: hrsh7th/nvim-cmp
- **用途**: 補完エンジン
- **読み込み**: InsertEnter
- **依存**: cmp-nvim-lsp, cmp-buffer, cmp-path, cmp-cmdline, cmp_luasnip, LuaSnip, friendly-snippets, lspkind.nvim

高機能な補完エンジンです。

**補完ソース（優先度順）:**
1. LSP (1000)
2. スニペット (750)
3. バッファ (500)
4. パス (250)

**設定:**
- ウィンドウ: ボーダー付き
- ゴーストテキスト: 有効
- コマンドライン補完: 有効
- 検索補完: 有効

---

### LuaSnip
- **リポジトリ**: L3MON4D3/LuaSnip
- **用途**: スニペットエンジン
- **読み込み**: InsertEnter（cmp依存）

高速なスニペットエンジンです。

---

### friendly-snippets
- **リポジトリ**: rafamadriz/friendly-snippets
- **用途**: スニペット集
- **読み込み**: InsertEnter（cmp依存）

多言語対応のスニペット集です。

---

### lspkind.nvim
- **リポジトリ**: onsails/lspkind.nvim
- **用途**: 補完メニューアイコン
- **読み込み**: InsertEnter（cmp依存）

補完メニューにアイコンを追加します。

**表示形式:**
- モード: シンボル + テキスト
- 最大幅: 50文字
- ソース表示: [LSP], [Snip], [Buf], [Path]

---

### nvim-autopairs
- **リポジトリ**: windwp/nvim-autopairs
- **用途**: 括弧自動補完
- **読み込み**: InsertEnter
- **依存**: nvim-cmp

括弧や引用符を自動で閉じます。

**設定:**
- Treesitter連携: 有効
- 文字列内での動作カスタマイズ

---

### neodev.nvim
- **リポジトリ**: folke/neodev.nvim
- **用途**: Neovim Lua API補完
- **読み込み**: lspconfig依存

Neovim設定ファイル編集時に vim.* API の補完を提供します。

---

## Git連携

### gitsigns.nvim
- **リポジトリ**: lewis6991/gitsigns.nvim
- **用途**: Git差分表示
- **読み込み**: BufReadPre, BufNewFile

エディタ内でGitの変更状況を表示します。

**サイン:**
| 記号 | 状態 |
|------|------|
| `│` | 追加 |
| `│` | 変更 |
| `_` | 削除 |
| `‾` | 先頭削除 |
| `~` | 変更削除 |
| `┆` | 未追跡 |

**設定:**
- Git監視間隔: 1秒
- 行blame: デフォルト無効（トグル可能）
- プレビュー: 丸角ボーダー

---

### lazygit.nvim
- **リポジトリ**: kdheepak/lazygit.nvim
- **用途**: LazyGit統合
- **読み込み**: コマンド実行時
- **依存**: plenary.nvim

ターミナルUIのGitクライアントをNeovim内で使用します。

**設定:**
- ウィンドウ透過度: 0
- スケール: 0.9
- ボーダー: 丸角

**キーマップ:**
| キー | 機能 |
|------|------|
| `<leader>gg` | LazyGit |
| `<leader>gf` | 現在ファイルの履歴 |

---

### diffview.nvim
- **リポジトリ**: sindrets/diffview.nvim
- **用途**: 高度なDiff表示
- **読み込み**: コマンド実行時
- **依存**: plenary.nvim

Git diffを高度に可視化します。

**設定:**
- ファイルパネル位置: 左（幅35）
- 履歴パネル位置: 下（高さ16）
- レイアウト: 水平2分割

**キーマップ:**
| キー | 機能 |
|------|------|
| `<leader>gd` | Diffview開く |
| `<leader>gc` | Diffview閉じる |
| `<leader>gh` | ファイル履歴 |

---

## データベース

### vim-dadbod
- **リポジトリ**: tpope/vim-dadbod
- **用途**: データベース操作
- **読み込み**: コマンド実行時

様々なデータベースに接続してクエリを実行できるプラグインです。

**対応データベース:**
- PostgreSQL
- MySQL / MariaDB
- SQLite
- SQL Server
- MongoDB
- Redis
- その他多数

---

### vim-dadbod-ui
- **リポジトリ**: kristijanhusak/vim-dadbod-ui
- **用途**: データベースUI
- **読み込み**: コマンド実行時
- **依存**: vim-dadbod

データベース操作のためのグラフィカルなUIを提供します。

**機能:**
- 接続管理
- テーブル一覧表示
- クエリ実行・結果表示
- クエリ履歴

**キーマップ:**
| キー | 機能 |
|------|------|
| `<leader>du` | DBUIを開く/閉じる |
| `<leader>da` | DB接続を追加 |
| `<leader>df` | DBバッファを検索 |
| `<leader>dr` | DBバッファをリネーム |
| `<leader>dl` | 最後のクエリ情報 |

---

### vim-dadbod-completion
- **リポジトリ**: kristijanhusak/vim-dadbod-completion
- **用途**: SQL補完
- **読み込み**: sql, mysql, plsql, psql ファイルタイプ
- **依存**: vim-dadbod, nvim-cmp

SQLファイル編集時にテーブル名、カラム名などの補完を提供します。

---

## ライティング

### markdown-preview.nvim
- **リポジトリ**: iamcco/markdown-preview.nvim
- **用途**: Markdownプレビュー
- **読み込み**: コマンド実行時、markdown

ブラウザでMarkdownをプレビューします。

**設定:**
- 自動開始: 無効
- 自動クローズ: 有効
- ポート: 8888
- リモートアクセス: 有効
- ブラウザ自動起動: 無効
- テーマ: ダーク

**対応機能:**
- Mermaid図
- KaTeX数式
- シーケンス図
- フローチャート

**キーマップ:**
| キー | 機能 |
|------|------|
| `<leader>mp` | プレビュートグル |

---

### obsidian.nvim
- **リポジトリ**: epwalsh/obsidian.nvim
- **用途**: Obsidian連携
- **読み込み**: markdown
- **依存**: plenary.nvim, nvim-cmp, telescope.nvim

Obsidianのノート機能をNeovimで使用します。

**設定:**
- Vault: `~/Documents/ObsidianVault`
- ノートフォルダ: notes/
- デイリーノートフォルダ: daily/
- テンプレートフォルダ: templates/
- 添付ファイルフォルダ: attachments/
- 日付形式: YYYY-MM-DD

**キーマップ:**
| キー | 機能 |
|------|------|
| `<leader>on` | 新規ノート |
| `<leader>oo` | Obsidianで開く |
| `<leader>os` | ノート検索 |
| `<leader>oq` | クイック切り替え |
| `<leader>ob` | バックリンク |
| `<leader>ot` | タグ検索 |
| `<leader>od` | 今日のノート |
| `<leader>oy` | 昨日のノート |
| `<leader>ol` | リンク化（Visual） |
| `<leader>of` | リンク先へ |

---

### render-markdown.nvim
- **リポジトリ**: MeanderingProgrammer/render-markdown.nvim
- **用途**: Markdown装飾表示
- **読み込み**: markdown
- **依存**: nvim-treesitter, nvim-web-devicons

エディタ内でMarkdownを装飾表示します。

**装飾機能:**
| 要素 | 装飾 |
|------|------|
| 見出し | アイコン付き（h1-h6） |
| コードブロック | ボーダー付き |
| 箇条書き | ●○◆◇ |
| チェックボックス | 󰄱   |
| 引用 | ▋ |
| テーブル | 罫線装飾 |
