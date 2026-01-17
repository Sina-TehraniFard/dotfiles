-- ======================================================================
-- 基本設定 (Options)
-- ======================================================================

local opt = vim.opt

-- 行番号表示
opt.relativenumber = true  -- 相対行番号（カーソル位置からの距離）

-- タブ・インデント
opt.expandtab = true       -- タブをスペースに変換
opt.tabstop = 4            -- タブ幅
opt.shiftwidth = 4         -- 自動インデント幅
opt.softtabstop = 4        -- <Tab>キー押下時のスペース数
opt.smartindent = true     -- スマートインデント

-- 検索
opt.ignorecase = true      -- 大文字小文字を区別しない
opt.smartcase = true       -- 大文字が含まれる場合は区別する

-- 外観
opt.termguicolors = true   -- True Color対応
opt.background = "dark"    -- 暗い背景用
opt.cursorline = true      -- カーソル行を強調
opt.signcolumn = "yes"     -- サイン列を常時表示
opt.scrolloff = 8          -- スクロール時の余白
opt.sidescrolloff = 8      -- 横スクロール時の余白
opt.wrap = false           -- 行の折り返しを無効化

-- ファイル
opt.encoding = "utf-8"
opt.fileencodings = { "utf-8", "iso-2022-jp", "euc-jp", "sjis" }
opt.autoread = true        -- ファイル変更の自動再読込
opt.swapfile = false       -- スワップファイルを作成しない
opt.backup = false         -- バックアップファイルを作成しない
opt.undofile = true        -- Undoファイルを有効化

-- 動作
opt.mouse = "a"            -- マウス操作を有効化
opt.clipboard = "unnamedplus"  -- システムクリップボードと連携

-- OSC 52 クリップボード（SSH経由でもローカルPCにコピー可能）
if vim.env.SSH_TTY or vim.env.WEZTERM_PANE then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
opt.updatetime = 100       -- 更新間隔（ミリ秒）
opt.timeoutlen = 300       -- キーシーケンスのタイムアウト
opt.splitbelow = true      -- 水平分割時は下に開く
opt.splitright = true      -- 垂直分割時は右に開く
opt.completeopt = { "menu", "menuone", "noselect" }  -- 補完メニュー設定

-- コマンドライン
opt.history = 1000         -- コマンド履歴
opt.wildmode = "longest:full,full"

-- ステータスライン
opt.laststatus = 3         -- グローバルステータスライン
opt.showmode = false       -- モード表示を無効化（lualineで表示）

-- タイトル
opt.title = true           -- タイトルバーにファイル名を表示

-- 不可視文字の表示
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- リーダーキーの設定（keymaps.luaより前に設定が必要）
vim.g.mapleader = " "
vim.g.maplocalleader = " "
