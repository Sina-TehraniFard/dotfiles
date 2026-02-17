# キーマップ詳細

`<leader>` = **Space**

## 基本操作

| キー | モード | 機能 |
|:---|:---|:---|
| `jk` | Insert | ノーマルモードに戻る |
| `Esc` | Normal | 検索ハイライトを消す |
| `Ctrl+A` | Normal | 全選択 |
| `dd` | Normal | 行削除（レジスタ汚さない） |
| `x` | Normal | 文字削除（レジスタ汚さない） |
| `p` | Visual | ペースト（レジスタ維持） |
| `Y` | Normal | 行末までヤンク |

## ウィンドウ & バッファ

| キー | 機能 |
|:---|:---|
| `Ctrl+H/J/K/L` | ウィンドウ間移動 |
| `Ctrl+↑/↓/←/→` | ウィンドウサイズ変更 |
| `S-h` / `S-l` | 前後のバッファ |
| `<leader>bd` | バッファ削除 |
| `<leader>bp` | ピン留めトグル |
| `<leader>bP` | ピン留め以外を閉じる |
| `<leader>bo` | 他のバッファを閉じる |
| `<leader>1` - `5` | バッファ 1〜5 に移動 |

## 検索 (Telescope)

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
| `<leader>ft` | TODO 検索 |
| `Ctrl+P` | Git ファイル検索 |

## コード編集

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

## LSP

| キー | 機能 |
|:---|:---|
| `gd` | 定義へジャンプ |
| `gD` | 宣言へジャンプ |
| `gi` | 実装へジャンプ |
| `gr` | 参照一覧 |
| `gy` | 型定義へジャンプ |
| `K` | ホバードキュメント |
| `Ctrl+K` (Insert) | シグネチャヘルプ |
| `<leader>rn` | リネーム |
| `<leader>ca` | コードアクション |
| `[d` / `]d` | 前後の診断へ移動 |
| `<leader>xd` | 診断フロート表示 |

## ジャンプ & ナビゲーション

| キー | モード | 機能 |
|:---|:---|:---|
| `s` | Normal / Visual / Operator | Flash ジャンプ |
| `S` | Normal / Operator | Flash Treesitter |
| `]m` / `[m` | Normal | 次/前の関数 |
| `]]` / `[[` | Normal | 次/前の参照 |
| `]t` / `[t` | Normal | 次/前の TODO |
| `af` / `if` | Visual / Operator | 関数選択 |
| `ac` / `ic` | Visual / Operator | クラス選択 |
| `Ctrl+Space` | Normal / Visual | 選択範囲の拡大 |

## Git

| キー | 機能 |
|:---|:---|
| `<leader>gg` | LazyGit を開く |
| `<leader>gf` | LazyGit（現在のファイル） |
| `<leader>gd` | Diffview を開く |
| `<leader>gc` | Diffview を閉じる |
| `<leader>gh` | ファイル履歴 |
| `]h` / `[h` | 次/前の hunk |
| `<leader>hs` | hunk をステージ |
| `<leader>hr` | hunk をリセット |
| `<leader>hb` | blame 表示 |
| `<leader>tb` | インライン blame トグル |

## 診断 & Trouble

| キー | 機能 |
|:---|:---|
| `<leader>xx` | 全診断 (Trouble) |
| `<leader>xX` | バッファ内診断 |
| `<leader>xt` | TODO 一覧 |
| `<leader>co` | Quickfix を開く |
| `<leader>cc` | Quickfix を閉じる |
| `[q` / `]q` | 前後の quickfix |

## データベース

| キー | 機能 |
|:---|:---|
| `<leader>du` | DBUI を開く/閉じる |
| `<leader>da` | DB 接続を追加 |
| `<leader>df` | DB バッファを検索 |
| `<leader>dr` | DB バッファをリネーム |

## Obsidian

| キー | 機能 |
|:---|:---|
| `<leader>on` | 新規ノート |
| `<leader>oo` | Obsidian で開く |
| `<leader>os` | ノート検索 |
| `<leader>od` | 今日のデイリーノート |
| `<leader>oy` | 昨日のデイリーノート |
| `<leader>ol` | リンク作成（Visual） |
| `Enter` | チェックボックストグル（Markdown） |

## 補完 (nvim-cmp)

| キー | 機能 |
|:---|:---|
| `Tab` | 次の補完候補 / スニペット展開 |
| `S-Tab` | 前の補完候補 |
| `Enter` | 補完確定 |
| `Ctrl+Space` | 補完を手動トリガー |
| `Ctrl+E` | 補完キャンセル |

## Scala (Metals)

| キー | 機能 |
|:---|:---|
| `<leader>mc` | Metals コマンド一覧 |
| `<leader>ws` | ワークシートホバー |
