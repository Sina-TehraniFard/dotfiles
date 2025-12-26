-- ======================================================================
-- lazy.nvim ブートストラップ
-- ======================================================================

-- lazy.nvim の自動インストール
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ======================================================================
-- プラグイン読み込み
-- ======================================================================

require("lazy").setup({
  -- 各プラグイン設定ファイルをインポート
  { import = "plugins.ui" },
  { import = "plugins.coding" },
  { import = "plugins.editor" },
  { import = "plugins.git" },
  { import = "plugins.writing" },
  { import = "plugins.database" },
}, {
  -- lazy.nvim の設定
  install = {
    -- 初回インストール時に使用するカラースキーム
    colorscheme = { "gruvbox", "habamax" },
  },
  checker = {
    -- プラグインの更新を自動チェック
    enabled = true,
    notify = false,
  },
  change_detection = {
    -- 設定ファイルの変更を検出して自動リロード
    enabled = true,
    notify = false,
  },
  ui = {
    -- UIのカスタマイズ
    border = "rounded",
    icons = {
      cmd = " ",
      config = "",
      event = "",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      source = " ",
      start = "",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
  performance = {
    rtp = {
      -- 無効化するビルトインプラグイン（起動高速化のため）
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
