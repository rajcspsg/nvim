return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'nvim-tree/nvim-web-devicons'
  use 'shaunsingh/nord.nvim'
  use 'folke/tokyonight.nvim'
  use 'tiagovla/tokyodark.nvim'
  use "rebelot/kanagawa.nvim"
  use({
  	"catppuccin/nvim",
	  as = "catppuccin"
  })

  use 'nvim-tree/nvim-web-devicons'
  -- use {'nvim-treesitter/nvim-treesitter', run = ":TSUpdate"}
  use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }
  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}

  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function() require'nvim-tree'.setup {} end
  }

  --use {'windwp/nvim-ts-autotag'}
  use {'windwp/nvim-autopairs'}

  use {'folke/which-key.nvim'}

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'onsails/lspkind-nvim'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  --use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

  use 'norcalli/nvim-colorizer.lua'
  use {
      'p00f/cphelper.nvim'
   }
--  use 'puremourning/vimspector'
  use 'voldikss/vim-floaterm'
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
   -- tag = 'release' -- To use the latest release
    config = function()
      require('gitsigns').setup{
          current_line_blame = true,
      }
    end
  }
  use 'erietz/vim-terminator'
  use {"is0n/jaq-nvim"}
  use { 'CRAG666/code_runner.nvim', requires = 'nvim-lua/plenary.nvim' }
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "simrat39/rust-tools.nvim"
  }

  use 'glepnir/dashboard-nvim'
  use 'mfussenegger/nvim-jdtls'
  -- use 'ray-x/go.nvim'
  -- use 'ray-x/guihua.lua' -- recommanded if need floating window support
  use({'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap", }})
  use 'gpanders/nvim-parinfer'
  use 'Olical/conjure'
  use 'PaterJason/cmp-conjure'
  use 'Olical/aniseed'
  use {
    'guns/vim-sexp',
    requires = {
      "radenling/vim-dispatch-neovim",
      "tpope/vim-sexp-mappings-for-regular-people",
      "tpope/vim-repeat"
    },

  }

  use {
    'tpope/vim-dispatch',
    'clojure-vim/vim-jack-in',
    'radenling/vim-dispatch-neovim'
  }

  use 'echasnovski/mini.nvim'
  use {
    'mrcjkb/haskell-tools.nvim'
  }

  -- Using packer
  use({
    "LeonHeidelbach/trailblazer.nvim",
    config = function()
        require("trailblazer").setup({
            -- your custom config goes here
        })
    end,
  })

  -- Using packer
  use({
    "LeonHeidelbach/trailblazer.nvim",
    config = function()
        require("trailblazer").setup({
            -- your custom config goes here
        })
    end,
  })

  use {
  'boltlessengineer/bufterm.nvim',
  config = function()
    require('bufterm').setup()
  end,
 }

end)
