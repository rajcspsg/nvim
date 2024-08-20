-- vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- Packer can manage itself
  'wbthomason/packer.nvim',
  --'nvim-tree/nvim-web-devicons',
  'shaunsingh/nord.nvim',
  { "AstroNvim/astrotheme" },
 {
   "MunifTanjim/nui.nvim",
   lazy = false,
  },
  'nvim-tree/nvim-web-devicons',
 {'windwp/nvim-autopairs'},

  {'folke/which-key.nvim'},

  {
    'nvim-telescope/telescope.nvim',
    dependenciess = { {'nvim-lua/plenary.nvim'} }
  },

  'onsails/lspkind-nvim',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',

  'norcalli/nvim-colorizer.lua',
  {
      'p00f/cphelper.nvim'
   },
  'voldikss/vim-floaterm',
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup{
          current_line_blame = true,
      }
    end
  },
  'erietz/vim-terminator',
  {"is0n/jaq-nvim"},
  { 'CRAG666/code_runner.nvim', dependencies = 'nvim-lua/plenary.nvim' },
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy"
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact"
    },
    config = function()
      require("nvim-ts-autotag").setup({})
    end
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "eslint-lsp",
        "prettierd",
        "tailwindcss-language-server",
        "typescript-language-server"
      }
    }
  },
  {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "simrat39/rust-tools.nvim"
  },

  'glepnir/dashboard-nvim',
  'mfussenegger/nvim-jdtls',
  {'scalameta/nvim-metals', dependenciess = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap", }},
  'mfussenegger/nvim-dap',
  'gpanders/nvim-parinfer',
  'Olical/conjure',
  'PaterJason/cmp-conjure',
  'Olical/aniseed',
  {
    'guns/vim-sexp',
    dependenciess = {
      "radenling/vim-dispatch-neovim",
      "tpope/vim-sexp-mappings-for-regular-people",
      "tpope/vim-repeat"
    },
  },
  {
    'tpope/vim-dispatch',
    'clojure-vim/vim-jack-in',
    'radenling/vim-dispatch-neovim'
  },
  'echasnovski/mini.nvim',
  {
    'mrcjkb/haskell-tools.nvim'
  },

  {
  'boltlessengineer/bufterm.nvim',
  config = function()
    require('bufterm').setup()
  end,
 },
  {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration

    -- Only one of these is needed, not both.
    "nvim-telescope/telescope.nvim", -- optional
    "ibhagwan/fzf-lua",              -- optional
  },
  config = true
},
{'akinsho/git-conflict.nvim', version = "*", config = true},
{"nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = {'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo'},
    dependencies = {
      'nvim-treesitter/playground',
      'nvim-treesitter/nvim-treesitter-context',
      'nvim-treesitter/nvim-treesitter-textobjects',
    }
},
{
    'nvim-treesitter/playground',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
},
{
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = "mrbjarksen/neo-tree-diagnostics.nvim",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, position = "left",})
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
  }

}

local opts = {}
require('lazy').setup(plugins, opts)
