-- ======================================================================
-- ライティング関連プラグイン
-- Markdown + Mermaid + Obsidian
-- ======================================================================

-- 環境変数から設定値を取得（未設定時はデフォルト値を使用）
local obsidian_vault = os.getenv("OBSIDIAN_VAULT") or "~/Documents/ObsidianVault"

return {
  -- ======================================================================
  -- obsidian.nvim: Obsidian連携
  -- ======================================================================
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
      { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
      { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
      { "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "Tags" },
      { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Today's note" },
      { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Yesterday's note" },
      { "<leader>ol", "<cmd>ObsidianLink<cr>", desc = "Link selection", mode = "v" },
      { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link" },
      { "<CR>", "<cmd>ObsidianToggleCheckbox<cr>", desc = "Toggle checkbox", ft = "markdown" },
    },
    config = function()
      require("obsidian").setup({
        -- Vaultのパス（必要に応じて変更してください）
        workspaces = {
          {
            name = "notes",
            path = obsidian_vault,
          },
        },

        -- 新規ノートの保存先
        notes_subdir = "notes",

        -- デイリーノート設定
        daily_notes = {
          folder = "daily",
          date_format = "%Y-%m-%d",
          alias_format = "%B %-d, %Y",
          template = nil,
        },

        -- 補完設定
        completion = {
          nvim_cmp = true,
          min_chars = 2,
        },

        -- Wikiリンクの設定
        wiki_link_func = function(opts)
          if opts.id == opts.label then
            return string.format("[[%s]]", opts.label)
          else
            return string.format("[[%s|%s]]", opts.id, opts.label)
          end
        end,

        -- ノートID生成（ファイル名）
        note_id_func = function(title)
          local suffix = ""
          if title ~= nil then
            -- タイトルがあればそれを使用（スペースをハイフンに変換）
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            -- タイトルがなければタイムスタンプ
            suffix = tostring(os.time())
          end
          return suffix
        end,

        -- フロントマターの設定
        note_frontmatter_func = function(note)
          local out = { id = note.id, aliases = note.aliases, tags = note.tags }
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end
          return out
        end,

        -- テンプレート設定
        templates = {
          subdir = "templates",
          date_format = "%Y-%m-%d",
          time_format = "%H:%M",
        },

        -- UI設定
        -- NOTE: render-markdown.nvimと競合するためUI機能は無効化
        ui = {
          enable = false,
        },

        -- 添付ファイルの設定
        attachments = {
          img_folder = "attachments",
        },

        -- リンクをたどる際の設定
        follow_url_func = function(url)
          vim.fn.jobstart({ "xdg-open", url }) -- Linux
          -- vim.fn.jobstart({ "open", url }) -- macOS
        end,
      })
    end,
  },

  -- ======================================================================
  -- render-markdown.nvim: Markdown装飾表示
  -- ======================================================================
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    config = function()
      -- Tokyo Night カラーのカスタムハイライトグループ
      local hl = vim.api.nvim_set_hl
      hl(0, "RenderMarkdownUnchecked", { fg = "#ff9e64", bold = true })  -- オレンジ
      hl(0, "RenderMarkdownChecked", { fg = "#565f89", bold = true })  -- グレー
      hl(0, "RenderMarkdownCheckedLine", { fg = "#565f89", strikethrough = true, bg = "#1e2030" })  -- 取り消し線 + ハイライト
      hl(0, "RenderMarkdownInProgress", { fg = "#7dcfff", bold = true })  -- シアン
      hl(0, "RenderMarkdownScheduled", { fg = "#e0af68", bold = true })  -- イエロー
      hl(0, "RenderMarkdownCancelled", { fg = "#565f89" })  -- グレー
      hl(0, "RenderMarkdownCancelledLine", { fg = "#565f89", strikethrough = true, bg = "#24283b" })  -- 取り消し線

      require("render-markdown").setup({
        heading = {
          enabled = true,
          sign = true,
          icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        },
        code = {
          enabled = true,
          sign = true,
          style = "full",
          border = "thin",
        },
        bullet = {
          enabled = false,  -- checkboxと競合するため無効化
        },
        checkbox = {
          enabled = false,  -- concealで文字が消えるため無効化、autocmdsでハイライト
        },
        quote = {
          enabled = true,
          icon = "▋",
        },
        pipe_table = {
          enabled = true,
          style = "full",
        },
      })
    end,
  },
}
