return {
  {
    "retran/meow.yarn.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("meow.yarn").setup({
        -- Default configuration
        -- You can customize these options as needed
        -- keymaps = {
        --   close = "q",
        --   expand = "<CR>",
        --   jump = "o",
        --   vsplit = "v",
        --   split = "s",
        -- },
      })

      -- Keybindings for quick access
      vim.keymap.set("n", "<leader>yt", "<cmd>MeowYarn type super<CR>", { desc = "Type hierarchy (supertypes)" })
      vim.keymap.set("n", "<leader>yT", "<cmd>MeowYarn type sub<CR>", { desc = "Type hierarchy (subtypes)" })
      vim.keymap.set("n", "<leader>yc", "<cmd>MeowYarn call callers<CR>", { desc = "Call hierarchy (callers)" })
      vim.keymap.set("n", "<leader>yC", "<cmd>MeowYarn call callees<CR>", { desc = "Call hierarchy (callees)" })
    end,
  },
}
