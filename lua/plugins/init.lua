-- vim.opt.rtp:prepend(lazypath)
local plugins = {
  -- Packer can manage itself
  'wbthomason/packer.nvim',
  'nvim-tree/nvim-web-devicons',
  'shaunsingh/nord.nvim',
  'folke/tokyonight.nvim',
  'tiagovla/tokyodark.nvim',
  'rebelot/kanagawa.nvim',
  {
  	"catppuccin/nvim",
	  as = "catppuccin"
  },

  'nvim-tree/nvim-web-devicons',
  -- use {'nvim-treesitter/nvim-treesitter', run = ":TSUpdate"}
  {
    'nvim-lualine/lualine.nvim',
    dependenciess = {'kyazdani42/nvim-web-devicons', opt = true}
  },
  {'akinsho/bufferline.nvim', tag = "*", dependenciess = 'nvim-tree/nvim-web-devicons'},

  {
    'kyazdani42/nvim-tree.lua',
    dependenciess = 'kyazdani42/nvim-web-devicons',
    config = function()require'nvim-tree'.setup {} end
  },

  --use {'windwp/nvim-ts-autotag'}
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
  --use 'hrsh7th/cmp-nvim-lsp-signature-help'
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',

  'norcalli/nvim-colorizer.lua',
  {
      'p00f/cphelper.nvim'
   },
--  use 'puremourning/vimspector'
  'voldikss/vim-floaterm',
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
   -- tag = 'release' -- To use the latest release
    config = function()
      require('gitsigns').setup{
          current_line_blame = true,
      }
    end
  },
  'erietz/vim-terminator',
  {"is0n/jaq-nvim"},
  { 'CRAG666/code_runner.nvim', dependenciess = 'nvim-lua/plenary.nvim' },
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "simrat39/rust-tools.nvim"
  },

  'glepnir/dashboard-nvim',
  'mfussenegger/nvim-jdtls',
  -- use 'ray-x/go.nvim'
  -- use 'ray-x/guihua.lua' -- recommanded if need floating window support
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

  -- Using packer
  ({
    "LeonHeidelbach/trailblazer.nvim",
    config = function()
        requires("trailblazer").setup({
            -- your custom config goes here
        })
    end,
  }),

  -- Using packer
  ({
    "LeonHeidelbach/trailblazer.nvim",
    config = function()
        require("trailblazer").setup({
            -- your custom config goes here
        })
    end,
  }),

  {
  'boltlessengineer/bufterm.nvim',
  config = function()
    require('bufterm').setup()
  end,
 }
}

local opts = {}
require('lazy').setup(plugins, opts)
