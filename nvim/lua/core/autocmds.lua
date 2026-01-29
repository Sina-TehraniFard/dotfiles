-- ======================================================================
-- 自動コマンド (Autocmds)
-- ======================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ======================================================================
-- Markdownチェックボックス完了時のハイライト（取り消し線＋薄い色）
-- ======================================================================
augroup("MarkdownCheckboxHighlight", { clear = true })
autocmd("ColorScheme", {
  group = "MarkdownCheckboxHighlight",
  pattern = "*",
  callback = function()
    -- 完了タスクの取り消し線＋グレー表示
    vim.api.nvim_set_hl(0, "@markup.strikethrough", { strikethrough = true, fg = "#6c7086" })
    vim.api.nvim_set_hl(0, "RenderMarkdownChecked", { fg = "#a6e3a1" }) -- 緑チェックマーク
    vim.api.nvim_set_hl(0, "RenderMarkdownUnchecked", { fg = "#f9e2af" }) -- 黄色の未完了
  end,
  desc = "Set checkbox highlight for completed tasks",
})

-- 初回読み込み時にも適用
vim.api.nvim_set_hl(0, "@markup.strikethrough", { strikethrough = true, fg = "#6c7086" })
vim.api.nvim_set_hl(0, "RenderMarkdownChecked", { fg = "#a6e3a1" })
vim.api.nvim_set_hl(0, "RenderMarkdownUnchecked", { fg = "#f9e2af" })

-- ======================================================================
-- 全角スペースのハイライト
-- ======================================================================
vim.api.nvim_set_hl(0, "ZenkakuSpace", { bg = "#f38ba8" })

augroup("ZenkakuSpaceHighlight", { clear = true })
autocmd("ColorScheme", {
  group = "ZenkakuSpaceHighlight",
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "ZenkakuSpace", { bg = "#f38ba8" })
  end,
  desc = "Highlight full-width spaces",
})

autocmd({ "BufWinEnter", "WinEnter" }, {
  group = "ZenkakuSpaceHighlight",
  pattern = "*",
  callback = function()
    if not vim.w.zenkaku_space_match then
      vim.w.zenkaku_space_match = vim.fn.matchadd("ZenkakuSpace", "　")
    end
  end,
  desc = "Match full-width spaces in buffer",
})

-- ======================================================================
-- 一般的な自動コマンド
-- ======================================================================

-- ファイル変更を自動検出
augroup("AutoRead", { clear = true })
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = "AutoRead",
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd.checktime()
    end
  end,
  desc = "Check if file changed outside of Neovim",
})

-- ヤンク時にハイライト
augroup("HighlightYank", { clear = true })
autocmd("TextYankPost", {
  group = "HighlightYank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
  desc = "Highlight yanked text",
})

-- 最後のカーソル位置を復元
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = "RestoreCursor",
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 0 and line <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
  desc = "Restore cursor position",
})

-- 末尾の空白を自動削除
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "TrimWhitespace",
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
  desc = "Remove trailing whitespace on save",
})

-- ======================================================================
-- ファイルタイプ別設定
-- ======================================================================

augroup("FileTypeSettings", { clear = true })

-- Markdown
autocmd("FileType", {
  group = "FileTypeSettings",
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = false  -- スペルチェック無効
    vim.opt_local.conceallevel = 2  -- Obsidian装飾表示用
  end,
  desc = "Markdown specific settings",
})

-- 2スペースインデントのファイルタイプ（JSON, YAML, Lua, Web開発系）
autocmd("FileType", {
  group = "FileTypeSettings",
  pattern = {
    "json", "yaml", "lua",
    "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact",
  },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
  desc = "2-space indent for JSON, YAML, Lua, and web development files",
})

-- ======================================================================
-- ウィンドウ関連
-- ======================================================================

-- リサイズ時にウィンドウサイズを均等化
augroup("EqualizeWindows", { clear = true })
autocmd("VimResized", {
  group = "EqualizeWindows",
  pattern = "*",
  command = "tabdo wincmd =",
  desc = "Equalize window sizes on resize",
})

-- ======================================================================
-- ヘルプ・特殊バッファ
-- ======================================================================

-- ヘルプを右側に開く
augroup("HelpWindow", { clear = true })
autocmd("FileType", {
  group = "HelpWindow",
  pattern = "help",
  command = "wincmd L",
  desc = "Open help in vertical split",
})

-- q で閉じられるバッファ
augroup("CloseWithQ", { clear = true })
autocmd("FileType", {
  group = "CloseWithQ",
  pattern = { "help", "man", "qf", "lspinfo", "checkhealth" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
  end,
  desc = "Close buffer with q",
})

-- ======================================================================
-- 大きなファイルの最適化
-- ======================================================================

augroup("LargeFile", { clear = true })
autocmd("BufReadPre", {
  group = "LargeFile",
  pattern = "*",
  callback = function()
    local file_size = vim.fn.getfsize(vim.fn.expand("%"))
    if file_size > 1024 * 1024 then -- 1MB以上
      vim.opt_local.syntax = "off"
      vim.opt_local.filetype = ""
      vim.opt_local.undofile = false
      vim.opt_local.swapfile = false
      -- NOTE: vim.opt_local.loadplugins はバッファローカルではなくグローバル設定のため、
      -- ここでの設定は既にロード済みのプラグインには影響しません。
      -- 大きなファイルでは syntax と filetype を無効化することで十分な効果が得られます。
      vim.opt_local.loadplugins = false
    end
  end,
  desc = "Optimize for large files",
})
