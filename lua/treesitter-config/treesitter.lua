require("lazy").setup({{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = {'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo'},
    dependencies = {
      'nvim-treesitter/playground',
      'nvim-treesitter/nvim-treesitter-context',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "cpp", "lua", "rust", "go", "typescript", "elixir", "java", "javascript", "html", "graphql", "prisma", "tsx", "jsx" },
          incremental_selection = {
          enable = true,
          keymaps = {
              init_selection = '<M-n>',
              node_incremental = '<M-n>',
              scope_incremental = false,
              node_decremental = '<M-p>',
            },
          },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },  
        })
    end
 }})
