return {
  "dumidusw/python-type-hints.nvim",
  ft = "python",
  opts = {
    enable_snippets = true, -- Load LuaSnip snippets (default: true)
    enable_logger = false, -- Enable debug logs (default: false)
  },
  dependencies = {
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "nvim-treesitter/nvim-treesitter", -- for context parsing
  },
}
