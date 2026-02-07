-- ======================================================================
-- エディタ機能プラグイン
-- Telescope + Neo-tree + 編集効率化
-- ======================================================================

return {
  -- ======================================================================
  -- telescope.nvim: ファジーファインダー
  -- ======================================================================
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<C-p>", "<cmd>Telescope git_files<cr>", desc = "Git files" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
            n = {
              ["q"] = actions.close,
            },
          },
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "vendor/",
            "%.lock",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
          },
          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      -- fzf拡張の読み込み
      pcall(telescope.load_extension, "fzf")
    end,
  },

  -- ======================================================================
  -- neo-tree.nvim: ファイルツリー
  -- ======================================================================
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
      { "<leader>o", "<cmd>Neotree focus<cr>", desc = "Focus file explorer" },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      -- netrwを無効化
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        sort_case_insensitive = true,
        default_component_configs = {
          indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            with_expanders = true,
            expander_collapsed = "",
            expander_expanded = "",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
          },
          modified = {
            symbol = "●",
          },
          git_status = {
            symbols = {
              added = "✚",
              modified = "✹",
              deleted = "✖",
              renamed = "➜",
              untracked = "✭",
              ignored = "☒",
              unstaged = "✗",
              staged = "✓",
              conflict = "",
            },
          },
        },
        window = {
          position = "left",
          width = 35,
          mappings = {
            ["<space>"] = "none",
            ["<cr>"] = "open",
            ["o"] = "open",
            ["s"] = "open_split",
            ["v"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["a"] = {
              "add",
              config = {
                show_path = "relative",
              },
            },
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
            -- パスをクリップボードにコピー
            ["Y"] = {
              function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                vim.fn.setreg("+", path)
                vim.notify("Copied: " .. path, vim.log.levels.INFO)
              end,
              desc = "Copy path to clipboard",
            },
          },
        },
        filesystem = {
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
              ".DS_Store",
              "thumbs.db",
              "node_modules",
              "__pycache__",
            },
          },
          follow_current_file = {
            enabled = true,
          },
          use_libuv_file_watcher = true,
        },
        buffers = {
          follow_current_file = {
            enabled = true,
          },
        },
      })
    end,
  },

  -- ======================================================================
  -- Comment.nvim: コメント操作
  -- ======================================================================
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },

  -- ======================================================================
  -- nvim-surround: 括弧・引用符操作
  -- ======================================================================
  {
    "kylechui/nvim-surround",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- ======================================================================
  -- which-key.nvim: キーマップヘルプ
  -- ======================================================================
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
        },
        win = {
          border = "rounded",
        },
      })
      wk.add({
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code/Quickfix" },
        { "<leader>d", group = "Database" },
        { "<leader>s", group = "Search/Replace" },
        { "<leader>w", group = "Workspace" },
        { "<leader>x", group = "Diagnostics/Trouble" },
        { "<leader>r", group = "Rename" },
      })
    end,
  },

  -- ======================================================================
  -- todo-comments.nvim: TODOコメントハイライト
  -- ======================================================================
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("todo-comments").setup({})
    end,
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
    },
  },

  -- ======================================================================
  -- indent-blankline.nvim: インデントガイド
  -- ======================================================================
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = false,
        },
        exclude = {
          filetypes = {
            "help",
            "dashboard",
            "neo-tree",
            "Trouble",
            "lazy",
            "mason",
          },
        },
      })
    end,
  },

  -- ======================================================================
  -- nvim-ts-context-commentstring: Treesitterベースコメント
  -- ======================================================================
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })
    end,
  },

  -- ======================================================================
  -- vim-illuminate: カーソル下の単語をハイライト
  -- ======================================================================
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("illuminate").configure({
        -- ハイライトまでの遅延時間（ミリ秒）
        delay = 200,
        -- 大きなファイルでは無効化（行数）
        large_file_cutoff = 2000,
        -- 大きなファイルで無効化する機能
        large_file_overrides = nil,
        -- ハイライトのプロバイダー（優先度順）
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        -- 除外するファイルタイプ
        filetypes_denylist = {
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "help",
          "dashboard",
          "TelescopePrompt",
        },
        -- 除外するモード
        modes_denylist = {},
        -- アンダーカーソルのみハイライト（他の出現箇所もハイライト）
        under_cursor = true,
        -- 最小文字数（短い単語は無視）
        min_count_to_highlight = 1,
      })

      -- ハイライトグループの設定
      vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
    end,
    keys = {
      { "]]", function() require("illuminate").goto_next_reference(true) end, desc = "Next reference" },
      { "[[", function() require("illuminate").goto_prev_reference(true) end, desc = "Previous reference" },
    },
  },

  -- ======================================================================
  -- flash.nvim: 画面内ジャンプ
  -- ======================================================================
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        char = {
          jump_labels = true,
        },
      },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },

  -- ======================================================================
  -- trouble.nvim: 診断・TODO一覧
  -- ======================================================================
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "TODOs (Trouble)" },
    },
    opts = {},
  },

  -- ======================================================================
  -- grug-far.nvim: プロジェクト全体の検索＆置換
  -- ======================================================================
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      { "<leader>sr", function() require("grug-far").open() end, desc = "Search and Replace" },
      { "<leader>sr", function()
        require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
      end, mode = "v", desc = "Search and Replace (selection)" },
    },
    opts = {},
  },

  -- ======================================================================
  -- auto-save.nvim: 自動保存
  -- ======================================================================
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      -- 自動保存のトリガーイベント
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
        defer_save = { "InsertLeave", "TextChanged" },
        cancel_deferred_save = { "InsertEnter" },
      },
      -- 保存までの遅延時間（ミリ秒）
      debounce_delay = 1000,
      -- 保存条件
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")
        -- 変更可能なバッファのみ保存
        if fn.getbufvar(buf, "&modifiable") ~= 1 then
          return false
        end
        -- 特定のファイルタイプは除外
        if utils.not_in(fn.getbufvar(buf, "&filetype"), {
          "neo-tree",
          "lazy",
          "mason",
          "harpoon",
          "dbui",
          "dbout",
          "db",
        }) then
          return true
        end
        return false
      end,
      -- 保存時のメッセージを非表示
      noautocmd = false,
      -- 保存前後のコールバック
      callbacks = {
        before_saving = function()
          -- 保存前に末尾の空白を削除（オプション）
          -- vim.cmd([[%s/\s\+$//e]])
        end,
        after_saving = function()
          vim.notify("AutoSaved", vim.log.levels.INFO)
        end,
      },
    },
    keys = {
      { "<leader>ta", "<cmd>ASToggle<cr>", desc = "Toggle auto-save" },
    },
  },
}
