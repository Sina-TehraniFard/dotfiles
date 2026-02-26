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
    init = function()
      -- Homebrew mysql-clientのパスを追加
      vim.env.PATH = "/opt/homebrew/opt/mysql-client/bin:" .. vim.env.PATH
    end,
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

          -- DB接続情報はローカルファイルから読み込み（lua/local/database.lua）
          local ok, local_db = pcall(require, "local.database")
          if ok and local_db.dbs then
            vim.g.dbs = local_db.dbs
          end

          -- レイアウト設定
          vim.g.db_ui_winwidth = 40
          vim.g.db_ui_win_position = "left"
          vim.g.db_ui_show_help = 0 -- ヘルプテキストを非表示にしてスッキリ

          -- クエリ結果を下部に水平分割で表示（バッファタブを汚さない）
          vim.g.db_ui_use_nvim_notify = 1
          vim.g.db_ui_auto_execute_table_helpers = 1

          -- DBUIカスタムハイライト
          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "dbui" },
            callback = function()
              -- サイドバーの見た目をneo-treeに寄せる
              vim.opt_local.number = false
              vim.opt_local.relativenumber = false
              vim.opt_local.signcolumn = "no"
              vim.opt_local.statuscolumn = ""
              vim.opt_local.cursorline = true
            end,
          })

          -- クエリ結果（dbout）の見た目改善
          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "dbout" },
            callback = function()
              vim.opt_local.number = false
              vim.opt_local.relativenumber = false
              vim.opt_local.signcolumn = "no"
              vim.opt_local.foldenable = false
              vim.opt_local.wrap = false
            end,
          })

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
      -- SQLバッファ内でのクエリ実行（ビジュアル選択 or バッファ全体）
      { "<leader>de", "<Plug>(DBUI_ExecuteQuery)", mode = { "n", "v" }, desc = "Execute query", ft = { "sql", "mysql", "plsql" } },
      -- クエリ結果ウィンドウを閉じる
      { "<leader>dq", function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "dbout" then
            vim.api.nvim_win_close(win, true)
          end
        end
      end, desc = "Close query results" },
    },
  },
}
