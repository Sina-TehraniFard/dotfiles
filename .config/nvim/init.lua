-- ======================================================================
-- Neovim 設定エントリーポイント
-- ======================================================================

-- lspconfig の非推奨警告を抑制（v3.0.0 で新APIに移行予定）
-- 現行のコードは問題なく動作するため、警告のみを抑制
--
-- TODO: lspconfig v3.0.0 への移行計画
--   1. nvim-lspconfig v3.0.0 リリース後、新APIのドキュメントを確認
--   2. plugins/lsp.lua の設定を新APIに書き換え
--   3. 移行完了後、この deprecate ラッパーを削除
--   参考: https://github.com/neovim/nvim-lspconfig/issues/3494
local original_deprecate = vim.deprecate
vim.deprecate = function(name, alternative, version, plugin, backtrace)
  if plugin == "nvim-lspconfig" then
    return -- lspconfig の警告を無視
  end
  return original_deprecate(name, alternative, version, plugin, backtrace)
end

-- 基本設定を読み込む（プラグインより先に読み込む必要がある）
require("core.options")

-- プラグイン管理（lazy.nvim）
require("plugins")

-- キーマップ設定
require("core.keymaps")

-- 自動コマンド設定
require("core.autocmds")
