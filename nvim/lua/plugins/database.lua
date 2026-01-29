-- ======================================================================
-- データベース操作プラグイン
-- vim-dadbod + vim-dadbod-ui + vim-dadbod-completion
-- ======================================================================

return {
  -- ======================================================================
  -- vim-dadbod: データベース操作の中核
  -- ======================================================================
  {
    "tpope/vim-dadbod",
    cmd = { "DB", "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = {
      -- UI拡張
      {
        "kristijanhusak/vim-dadbod-ui",
        cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
        init = function()
          -- DBUI設定
          vim.g.db_ui_use_nerd_fonts = 1
          vim.g.db_ui_show_database_icon = 1
          vim.g.db_ui_force_echo_notifications = 1

          -- 保存時の自動クエリ実行を無効化（auto-saveとの競合を防止）
          -- クエリを実行したい場合は <leader>S を使用
          vim.g.db_ui_execute_on_save = false

          -- 保存先ディレクトリ（接続情報はここに保存される）
          vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"

          -- クエリ結果の表示設定
          vim.g.db_ui_winwidth = 35
          vim.g.db_ui_win_position = "left"

          -- テーブル表示時のデフォルトクエリ
          vim.g.db_ui_table_helpers = {
            mysql = {
              Count = "SELECT COUNT(*) FROM {table}",
              Explain = "EXPLAIN SELECT * FROM {table}",
            },
            postgresql = {
              Count = "SELECT COUNT(*) FROM {table}",
              Explain = "EXPLAIN ANALYZE SELECT * FROM {table}",
              Size = "SELECT pg_size_pretty(pg_total_relation_size('{table}'))",
            },
            sqlite = {
              Count = "SELECT COUNT(*) FROM {table}",
              Schema = ".schema {table}",
            },
          }
        end,
      },
      -- nvim-cmp用の補完ソース
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
        lazy = true,
      },
    },
    keys = {
      { "<leader>du", "<cmd>DBUIToggle<cr>", desc = "Toggle DBUI" },
      { "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "Find DB buffer" },
      { "<leader>da", "<cmd>DBUIAddConnection<cr>", desc = "Add DB connection" },
      { "<leader>dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename DB buffer" },
      { "<leader>dl", "<cmd>DBUILastQueryInfo<cr>", desc = "Last query info" },
    },
  },
}
