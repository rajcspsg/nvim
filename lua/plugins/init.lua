-- vim.opt.rtp:prepend(lazypath)

local plugins = {
  { "AstroNvim/astrotheme" },
  {
    "MunifTanjim/nui.nvim",
    lazy = false,
  },
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup({})
    end,
  },
  {
    "VidocqH/lsp-lens.nvim",
    config = function()
      require("lsp-lens").setup({})
    end,
  },
  {
    "zbirenbaum/neodim",
    event = "LspAttach",
    config = function()
      require("neodim").setup({
        alpha = 0.75,
        blend_color = "#000000",
        hide = {
          underline = true,
          virtual_text = true,
          signs = true,
        },
        regex = {
          "[uU]nused",
          "[nN]ever [rR]ead",
          "[nN]ot [rR]ead",
        },
        priority = 128,
        disable = {},
      })
    end,
  },
  {
    "tadmccorkle/markdown.nvim",
    ft = "markdown", -- or 'event = "VeryLazy"'
    opts = {
      -- configuration here or empty for defaults
    },
  },
  {
    "kosayoda/nvim-lightbulb",
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true },
      })
    end,
  },
  {
    "bbjornstad/pretty-fold.nvim",
    config = function()
      require("pretty-fold").setup()
    end,
  },
  {
    "anuvyklack/fold-preview.nvim",
    dependencies = { "anuvyklack/keymap-amend.nvim" },
    config = function()
      require("fold-preview").setup({
        -- Your configuration goes here.
      })
    end,
  },
  {
    "sidebar-nvim/sidebar.nvim",
    config = function()
      local sidebar = require("sidebar-nvim")
      local opts = { open = false }
      sidebar.setup(opts)
    end,
  },
  {
    "oskarrrrrrr/symbols.nvim",
    config = function()
      local r = require("symbols.recipes")
      require("symbols").setup(r.DefaultFilters, r.AsciiSymbols, {
        -- custom settings here
        -- e.g. hide_cursor = false
      })
      vim.keymap.set("n", ",s", ":Symbols<CR>")
      vim.keymap.set("n", ",S", ":SymbolsClose<CR>")
    end,
  },
  {
    "cuducos/yaml.nvim",
    ft = { "yaml" }, -- optional
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
      require("yaml_nvim").setup({ ft = { "yaml" } })
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
  {
    "onsails/lspkind-nvim",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
  },
  {
    "blanktiger/aqf.nvim",
    config = function()
      require("aqf").setup({})
    end,
  },
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
    opts = {
      autocmd = { enabled = true },
      sign = { enabled = true, text = "" },
      action_kinds = { "quickfix", "refactor" },
      ignore = {
        actions_without_kind = true,
      },
    },
  },
  {
    "dnlhc/glance.nvim",
    cmd = { "Glance" },
    event = "LspAttach",
    opts = {
      border = {
        enable = true,
      },
      use_trouble_qf = true,
      hooks = {
        before_open = function(results, open, jump, method)
          local uri = vim.uri_from_bufnr(0)
          if #results == 1 then
            local target_uri = results[1].uri or results[1].targetUri

            if target_uri == uri then
              jump(results[1])
            else
              open(results)
            end
          else
            open(results)
          end
        end,
      },
    },
  },
  {
    "zbirenbaum/neodim",
    event = "LspAttach",
    opts = {
      alpha = 0.60,
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    -- event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- turn off global option for windowline
      vim.opt.winbar = nil
      vim.keymap.set("n", "<leader>ls", require("dropbar.api").pick, { desc = "[s]ymbols" })
    end,
    enabled = true,
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
  },
  { "kazhala/close-buffers.nvim" },
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      local nvim_tmux_nav = require("nvim-tmux-navigation")

      nvim_tmux_nav.setup({
        disable_when_zoomed = true, -- defaults to false
      })

      vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
      vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
      vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
    end,
  },
  { "nvim-tree/nvim-web-devicons" },
  {
    "gen740/SmoothCursor.nvim",
  },
  { "windwp/nvim-autopairs" },
  {
    "HiPhish/rainbow-delimiters.nvim",
    enabled = true,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
          html = rainbow_delimiters.strategy["local"],
          commonlisp = rainbow_delimiters.strategy["local"],
          fennel = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
          javascript = "rainbow-parens",
          typescript = "rainbow-parens",
          tsx = "rainbow-parens",
          verilog = "rainbow-blocks",
        },
      }
    end,
  },
  { "tiagovla/scope.nvim" },
  { "folke/which-key.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    dependenciess = { { "nvim-lua/plenary.nvim" } },
  },
  "folke/twilight.nvim",
  "folke/zen-mode.nvim",
  "onsails/lspkind-nvim",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-vsnip",
  "hrsh7th/vim-vsnip",
  --{ "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "echasnovski/mini.bufremove",
        version = "*",
        config = function()
          require("mini.bufremove").setup({
            silent = true,
          })
        end,
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {},
  },
  {
    "p00f/cphelper.nvim",
  },
  "voldikss/vim-floaterm",
  {
    "lewis6991/gitsigns.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
      })
    end,
  },
  "erietz/vim-terminator",
  { "is0n/jaq-nvim" },
  { "CRAG666/code_runner.nvim", dependencies = "nvim-lua/plenary.nvim" },
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    config = function()
      require("nvim-ts-autotag").setup({})
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "eslint-lsp",
        "prettierd",
        "tailwindcss-language-server",
        "typescript-language-server",
        "stylua",
        "isort",
        "black",
        "pylint",
        "eslint_d",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  "nanozuki/tabby.nvim",
  "glepnir/dashboard-nvim",
  "mfussenegger/nvim-jdtls",
  { "scalameta/nvim-metals",    dependenciess = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" } },
  "mfussenegger/nvim-dap",
  "gpanders/nvim-parinfer",
  "Olical/conjure",
  "PaterJason/cmp-conjure",
  "Olical/aniseed",
  {
    "guns/vim-sexp",
    dependenciess = {
      "radenling/vim-dispatch-neovim",
      "tpope/vim-sexp-mappings-for-regular-people",
      "tpope/vim-repeat",
    },
  },
  {
    "tpope/vim-dispatch",
    --"clojure-vim/vim-jack-in",
    "radenling/vim-dispatch-neovim",
  },
  { "TreyBastian/nvim-jack-in", config = true },
  "echasnovski/mini.nvim",
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^4", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    "julienvincent/clojure-test.nvim",
    dependencies = {
      "nvim-neotest/nvim-nio",
    },
  },
  {
    "boltlessengineer/bufterm.nvim",
    config = function()
      require("bufterm").setup()
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua",           -- optional
    },
    config = true,
  },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  "ecosse3/galaxyline.nvim",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    dependencies = {
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },
  {
    "nvim-treesitter/playground",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  --[[{
		"SmiteshP/nvim-navic",
		event = { "CursorMoved", "BufWinEnter", "BufFilePost" },
		config = function()
			local caretRight = ""
			vim.api.nvim_set_hl(0, "NavicText", { link = "Winbar" })
			vim.api.nvim_set_hl(0, "NavicSeparator", { link = "Winbar" })

			require("nvim-navic").setup({
				lsp = {
					auto_attach = true,
					preference = nil,
				},
				highlight = true,
				separator = " " .. caretRight .. " ",
				depth_limit = 0,
				depth_limit_indicator = "..",
				safe_output = true,
			})

			require("rajnvim.winbar")
		end,
		dependencies = "neovim/nvim-lspconfig",
	},--]]
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          svelte = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          graphql = { "prettier" },
          lua = { "stylua" },
          python = { "isort", "black" },
        },
        format_on_save = {
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>mp", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = "mrbjarksen/neo-tree-diagnostics.nvim",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, position = "left" })
        end,
        desc = "Explorer (root dir)",
        remap = true,
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            position = "float",
          })
        end,
        desc = "Explorer Float (root dir)",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    opts = require("rajnvim.neo-tree-opts"),
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.uv.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          ---@diagnostic disable-next-line: different-requires
          require("neo-tree")
          vim.cmd([[set showtabline=0]])
        end
      end
    end,
  },
  {
    "isakbm/gitgraph.nvim",
    opts = {
      symbols = {
        merge_commit = "M",
        commit = "*",
      },
      format = {
        timestamp = "%H:%M:%S %d-%m-%Y",
        fields = { "hash", "timestamp", "author", "branch_name", "tag" },
      },
      hooks = {
        on_select_commit = function(commit)
          print("selected commit:", commit.hash)
        end,
        on_select_range_commit = function(from, to)
          print("selected range:", from.hash, to.hash)
        end,
      },
    },
    keys = {
      {
        "<leader>gl",
        function()
          require("gitgraph").draw({}, { all = true, max_count = 5000 })
        end,
        desc = "GitGraph - Draw",
      },
    },
  },
}

local opts = {}
require("lazy").setup(plugins, opts)
