-- ======================================================================
-- キーマップ設定 (Keymaps)
-- ======================================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ======================================================================
-- 基本操作
-- ======================================================================

-- jk でノーマルモードに戻る（Escの代わり）
keymap("i", "jk", "<Esc>", opts)

-- 検索ハイライトを消す
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- 保存
keymap("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
keymap("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save file" })

-- ======================================================================
-- クリップボード操作（Ctrl+C/V）
-- ======================================================================

-- ビジュアルモードでCtrl+Cでコピー
keymap("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })

-- Ctrl+Vでペースト
keymap("n", "<C-v>", '"+p', { desc = "Paste from clipboard" })
keymap("i", "<C-v>", '<C-r>+', { desc = "Paste from clipboard in insert mode" })
keymap("v", "<C-v>", '"+p', { desc = "Paste from clipboard" })

-- ======================================================================
-- ウィンドウ操作
-- ======================================================================

-- ウィンドウ間移動
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- ウィンドウサイズ変更
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- ======================================================================
-- バッファ操作
-- ======================================================================

-- バッファ切り替えは bufferline.nvim で設定（<S-h>, <S-l>）
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- ======================================================================
-- 行操作
-- ======================================================================

-- 行を上下に移動
keymap("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
keymap("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
keymap("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move line down" })
keymap("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move line up" })
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- インデント調整（ビジュアルモードで選択を維持）
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- ======================================================================
-- テキスト操作
-- ======================================================================

-- 選択範囲をペーストしてもレジスタを上書きしない
keymap("v", "p", '"_dP', { desc = "Paste without yanking" })

-- 行全体をヤンク（Y を y$ と同じ動作に）
keymap("n", "Y", "y$", { desc = "Yank to end of line" })

-- ======================================================================
-- 便利なショートカット
-- ======================================================================

-- ファイルエクスプローラ（neo-tree）
-- プラグイン側で設定（plugins/editor.lua）

-- Telescope（ファジーファインダー）
-- プラグイン側で設定（plugins/editor.lua）

-- Git（LazyGit）
-- プラグイン側で設定（plugins/git.lua）

-- 診断（Diagnostics）
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "<leader>xd", vim.diagnostic.open_float, { desc = "Show diagnostic" })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic list" })

-- ======================================================================
-- LSP関連（on_attachで設定するものもあるが、グローバルで使えるものをここに）
-- ======================================================================

-- LSPキーマップは plugins/coding.lua の on_attach で設定

-- ======================================================================
-- Quickfix
-- ======================================================================

keymap("n", "<leader>co", "<cmd>copen<CR>", { desc = "Open quickfix" })
keymap("n", "<leader>cc", "<cmd>cclose<CR>", { desc = "Close quickfix" })
keymap("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix" })
keymap("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix" })

-- ======================================================================
-- フォーマット
-- ======================================================================

-- フォーマットは conform.nvim で設定（plugins/coding.lua）
-- <leader>f でノーマルモード/ビジュアルモード両方に対応
