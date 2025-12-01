return {
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
  {
    "gpanders/nvim-parinfer",
  },
  {
    "PaterJason/cmp-conjure",
  },
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
  { "https://git.treybastian.com/nvim-jack-in", config = true },
  {
    "m00qek/baleia.nvim",
    opts = {
      line_starts_at = 3,
    },
    config = function(_, opts)
      vim.g.conjure_baleia = require("baleia").setup(opts)

      vim.api.nvim_create_user_command("BaleiaColorize", function()
        vim.g.conjure_baleia.once(vim.api.nvim_get_current_buf())
      end, { bang = true })

      vim.api.nvim_create_user_command("BaleiaLogs", vim.g.conjure_baleia.logger.show, { bang = true })
    end,
  },
}
