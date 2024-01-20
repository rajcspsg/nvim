-- vim.opt.rtp:prepend(lazypath)
local plugins = {
  -- Packer can manage itself
  'wbthomason/packer.nvim',
  'nvim-tree/nvim-web-devicons',
  'shaunsingh/nord.nvim',
  { "AstroNvim/astrotheme" },
 --[=====[ {
    "AstroNvim/astroui",
    lazy = false, -- disable lazy loading
    priority = 10000, -- load AstroUI first
    opts = {
      -- set configuration options  as described below
    }
  },--]=====]

  'nvim-tree/nvim-web-devicons',
  --[=====[{
    'kyazdani42/nvim-tree.lua',
    dependenciess = 'kyazdani42/nvim-web-devicons',
    config = function()require'nvim-tree'.setup {} end
  }]=====]--,
{
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
}, 
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
}

local opts = {}
require('lazy').setup(plugins, opts)
