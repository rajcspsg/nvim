local lspconfig = require("lspconfig")

local servers = { "tailwindcss", "eslint" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({})
end
