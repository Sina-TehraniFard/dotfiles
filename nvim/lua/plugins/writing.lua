-- ======================================================================
-- ライティング関連プラグイン
-- Markdown + Mermaid + Obsidian
-- ======================================================================

-- 環境変数から設定値を取得（未設定時はデフォルト値を使用）
local obsidian_vault = os.getenv("OBSIDIAN_VAULT") or "~/Documents/ObsidianVault"
local mkdp_host = os.getenv("MKDP_HOST") or "REDACTED"
local mkdp_port = os.getenv("MKDP_PORT") or "8888"

return {
  -- ======================================================================
  -- nvim-osc52: SSH経由でもMacのクリップボードにコピー
  -- ======================================================================
  {
    "ojroques/nvim-osc52",
    config = function()
      require("osc52").setup({
        max_length = 0,
        silent = false,
        trim = false,
      })
    end,
  },

  -- ======================================================================
  -- markdown-preview.nvim: Markdownプレビュー（Mermaid対応）
  -- ======================================================================
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown preview toggle" },
      { "<leader>mu", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local url = "http://" .. mkdp_host .. ":" .. mkdp_port .. "/page/" .. bufnr
        require("osc52").copy(url)
        vim.notify("Copied: " .. url, vim.log.levels.INFO)
      end, desc = "Copy preview URL to Mac", ft = "markdown" },
    },
    config = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 1  -- リモートアクセス許可
      vim.g.mkdp_open_ip = mkdp_host  -- LinuxサーバーのIP（Macからアクセス用）
      vim.g.mkdp_port = mkdp_port  -- 固定ポート
      vim.g.mkdp_browser = "none"  -- ブラウザを自動で開かない
      vim.g.mkdp_echo_preview_url = 1  -- URLを表示
      vim.g.mkdp_page_title = "${name}"
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_theme = "dark"
      -- Mermaid対応
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {}, -- Mermaid
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
      }
    end,
  },

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
        ui = {
          enable = true,
          update_debounce = 200,
          checkboxes = {
            [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
            ["x"] = { char = "", hl_group = "ObsidianDone" },
            [">"] = { char = "", hl_group = "ObsidianRightArrow" },
            ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
          },
          bullets = { char = "•", hl_group = "ObsidianBullet" },
          external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
          reference_text = { hl_group = "ObsidianRefText" },
          highlight_text = { hl_group = "ObsidianHighlightText" },
          tags = { hl_group = "ObsidianTag" },
          hl_groups = {
            ObsidianTodo = { bold = true, fg = "#f78c6c" },
            ObsidianDone = { bold = true, fg = "#89ddff" },
            ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
            ObsidianTilde = { bold = true, fg = "#ff5370" },
            ObsidianBullet = { bold = true, fg = "#89ddff" },
            ObsidianRefText = { underline = true, fg = "#c792ea" },
            ObsidianExtLinkIcon = { fg = "#c792ea" },
            ObsidianTag = { italic = true, fg = "#89ddff" },
            ObsidianHighlightText = { bg = "#75662e" },
          },
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
          enabled = true,
          icons = { "●", "○", "◆", "◇" },
        },
        checkbox = {
          enabled = true,
          unchecked = { icon = "󰄱 " },
          checked = { icon = " " },
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
