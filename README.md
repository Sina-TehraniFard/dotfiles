# dotfiles

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Neovim](https://img.shields.io/badge/Neovim-0.9+-brightgreen.svg)](https://neovim.io/)
[![WezTerm](https://img.shields.io/badge/WezTerm-GPU--accelerated-blue.svg)](https://wezfurlong.org/wezterm/)
[![Theme](https://img.shields.io/badge/Theme-Tokyo%20Night-bb9af7.svg)](https://github.com/folke/tokyonight.nvim)

macOS / Linux 向けの開発環境設定。Neovim + WezTerm を Tokyo Night テーマで統一。

<!-- TODO: スクリーンショットを追加 -->

## 含まれるもの

```
.config/
├── nvim/       Neovim IDE 環境（40+ プラグイン）
└── wezterm/    WezTerm ターミナル設定
```

| カテゴリ | 主なツール |
|:---------|:-----------|
| **補完 & LSP** | nvim-lspconfig, nvim-cmp, Mason (9言語対応) |
| **検索** | Telescope, grug-far (プロジェクト全体置換) |
| **Git** | LazyGit, gitsigns, diffview |
| **DB** | vim-dadbod (MySQL / PostgreSQL / SQLite) |
| **執筆** | Obsidian連携, Markdown装飾表示 |
| **ターミナル** | WezTerm (GPU描画, タブ/ペイン, SSH色分け) |

## セットアップ

```bash
git clone https://github.com/Sina-TehraniFard/dotfiles.git
cd dotfiles
./install.sh
```

`install.sh` が依存ツールのインストール、設定のシンボリックリンク作成、プラグインの初期化を自動で行います。

### 配置方式

```
dotfiles/.config/nvim/     ──ln -sf──>  ~/.config/nvim/
dotfiles/.config/wezterm/  ──ln -sf──>  ~/.config/wezterm/
```

シンボリックリンクなので、dotfiles を編集すれば即座に反映されます。

## キーマップ早見表

`<leader>` = **Space**

```
 検索           Git            コード          ナビゲーション
 ─────────────  ─────────────  ──────────────  ──────────────
 ff ファイル    gg LazyGit     gd 定義ジャンプ  s  Flash
 fg テキスト    hs ステージ    gr 参照一覧      ]m 次の関数
 fb バッファ    hb blame       K  ホバー        ]h 次のhunk
 fr 最近        gd Diffview    rn リネーム      ]t 次のTODO
```

> 全キーマップは [docs/keymaps.md](docs/keymaps.md) を参照

## カスタマイズ

| やりたいこと | ファイル |
|:---|:---|
| Neovim オプション | `.config/nvim/lua/core/options.lua` |
| キーマップ追加 | `.config/nvim/lua/core/keymaps.lua` |
| テーマ・UI | `.config/nvim/lua/plugins/ui.lua` |
| LSP・補完 | `.config/nvim/lua/plugins/coding.lua` |
| プラグイン追加 | `.config/nvim/lua/plugins/` に新規ファイル |
| WezTerm 設定 | `.config/wezterm/wezterm.lua` |
| 機微情報 (SSH等) | `~/.config/wezterm/local.lua` (gitignore) |

## ドキュメント

| ドキュメント | 内容 |
|:---|:---|
| [キーマップ詳細](docs/keymaps.md) | 全キーバインドのリファレンス |
| [プラグイン一覧](docs/plugins.md) | 導入プラグインと設定の解説 |

## License

[MIT License](LICENSE)
