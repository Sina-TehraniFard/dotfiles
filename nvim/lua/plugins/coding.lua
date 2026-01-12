-- ======================================================================
-- コーディング関連プラグイン
-- Treesitter + LSP + 補完
-- ======================================================================

return {
  -- ======================================================================
  -- nvim-treesitter: 高精度シンタックスハイライト
  -- ======================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "c", "css", "dockerfile", "go", "html", "java",
          "javascript", "json", "kotlin", "lua", "markdown",
          "markdown_inline", "php", "python", "rust", "sql",
          "tsx", "typescript", "vim", "vimdoc", "yaml",
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      })
    end,
  },

  -- ======================================================================
  -- nvim-treesitter-textobjects: テキストオブジェクト
  -- ======================================================================
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "master",
    lazy = true,
  },

  -- ======================================================================
  -- mason.nvim: LSPサーバー管理
  -- ======================================================================
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- ======================================================================
  -- mason-lspconfig.nvim: MasonとLSPの連携
  -- ======================================================================
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",        -- Lua
          "intelephense",  -- PHP
          "kotlin_language_server", -- Kotlin
          "pyright",       -- Python
          "ts_ls",         -- TypeScript/JavaScript
          "html",          -- HTML
          "cssls",         -- CSS
          "jsonls",        -- JSON
          "yamlls",        -- YAML
        },
        automatic_installation = true,
      })
    end,
  },

  -- ======================================================================
  -- nvim-lspconfig: LSP設定
  -- ======================================================================
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = {} }, -- Neovim Lua API補完
    },
    config = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- LSP接続時のキーマップ設定
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }

        -- 定義ジャンプ
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)

        -- ホバー・シグネチャ
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)

        -- リネーム・コードアクション
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        -- フォーマット
        vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, opts)

        -- ワークスペース
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
      end

      -- 補完機能の有効化
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- 診断表示の設定
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰌵 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })

      -- 各言語サーバーの設定
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        intelephense = {
          settings = {
            intelephense = {
              files = { maxSize = 5000000 },
              completion = {
                triggerParameterHints = true,
                insertUseDeclaration = true,
              },
              format = { enable = true },
            },
          },
        },
        kotlin_language_server = {},
        pyright = {},
        ts_ls = {},
        html = {},
        cssls = {},
        jsonls = {},
        yamlls = {},
      }

      for server, config in pairs(servers) do
        config.on_attach = on_attach
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end
    end,
  },

  -- ======================================================================
  -- nvim-cmp: 補完エンジン
  -- ======================================================================
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- LSP補完ソース
      "hrsh7th/cmp-buffer",       -- バッファ補完ソース
      "hrsh7th/cmp-path",         -- パス補完ソース
      "hrsh7th/cmp-cmdline",      -- コマンドライン補完
      "saadparwaiz1/cmp_luasnip", -- スニペット補完ソース
      "L3MON4D3/LuaSnip",         -- スニペットエンジン
      "rafamadriz/friendly-snippets", -- スニペット集
      "onsails/lspkind.nvim",     -- 補完メニューアイコン
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- friendly-snippets の読み込み
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            menu = {
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
            },
          }),
        },
        experimental = {
          ghost_text = true,
        },
      })

      -- コマンドライン補完
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      -- 検索補完
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- SQL/DBファイル用補完（vim-dadbod-completion）
      cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = cmp.config.sources({
          { name = "vim-dadbod-completion" },
          { name = "buffer" },
        }),
      })
    end,
  },

  -- ======================================================================
  -- nvim-autopairs: 括弧自動補完
  -- ======================================================================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true, -- Treesitter連携
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
        },
      })

      -- nvim-cmpとの連携
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}
