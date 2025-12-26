-- ======================================================================
-- UI関連プラグイン
-- Lualine + Gruvbox + アイコン
-- ======================================================================

return {
  -- ======================================================================
  -- gruvbox.nvim: カラースキーム
  -- ======================================================================
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000, -- 最初に読み込む
    lazy = false,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = "", -- "hard", "soft", ""
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- ======================================================================
  -- lualine.nvim: ステータスライン
  -- ======================================================================
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme = "gruvbox",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "neo-tree", "lazy", "mason" },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            {
              "filename",
              path = 1, -- 相対パス表示
              symbols = {
                modified = " ●",
                readonly = " ",
                unnamed = "[No Name]",
              },
            },
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {
          lualine_a = {
            {
              "buffers",
              show_filename_only = true,
              hide_filename_extension = false,
              show_modified_status = true,
              mode = 2, -- 0: Shows buffer name, 1: Shows buffer index, 2: Shows buffer name + buffer index
              max_length = vim.o.columns * 2 / 3,
              filetype_names = {
                TelescopePrompt = "Telescope",
                ["neo-tree"] = "Neo-tree",
                lazy = "Lazy",
                mason = "Mason",
              },
              symbols = {
                modified = " ●",
                alternate_file = "",
                directory = "",
              },
            },
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { "tabs" },
        },
        extensions = { "neo-tree", "lazy" },
      })
    end,
  },

  -- ======================================================================
  -- nvim-web-devicons: ファイルアイコン
  -- ======================================================================
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup({
        override = {},
        color_icons = true,
        default = true,
      })
    end,
  },

  -- ======================================================================
  -- dressing.nvim: UIの改善
  -- ======================================================================
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          default_prompt = "Input:",
          border = "rounded",
          relative = "cursor",
        },
        select = {
          enabled = true,
          backend = { "telescope", "builtin" },
          telescope = nil,
        },
      })
    end,
  },

  -- ======================================================================
  -- noice.nvim: コマンドライン・通知UI
  -- ======================================================================
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = true,
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "written",
            },
            opts = { skip = true },
          },
        },
      })
    end,
    keys = {
      { "<leader>nl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>nh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>na", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
    },
  },

  -- ======================================================================
  -- nvim-notify: 通知
  -- ======================================================================
  {
    "rcarriga/nvim-notify",
    lazy = true,
    config = function()
      require("notify").setup({
        background_colour = "#000000",
        fps = 30,
        icons = {
          DEBUG = "",
          ERROR = "",
          INFO = "",
          TRACE = "✎",
          WARN = "",
        },
        level = 2,
        minimum_width = 50,
        render = "default",
        stages = "fade_in_slide_out",
        timeout = 3000,
        top_down = true,
      })
      vim.notify = require("notify")
    end,
  },
}
