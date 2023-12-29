local lspconfig = require("lspconfig")

local servers = { "tsserver", "tailwindcss", "eslint" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({

  })
end

