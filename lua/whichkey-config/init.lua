local wk = require("which-key")

local mappings = {
    { "<leader>Q", ":wq<cr>", desc = "Save and Quit" },
    { "<leader>q", ":q<cr>", desc = "Quit" },
    { "<leader>x", ":bdelete<cr>", desc = "Close" },
  }

local opts = { prefix = '<leader>'}
wk.register(mappings, opts)
