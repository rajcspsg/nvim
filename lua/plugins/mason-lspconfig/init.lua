return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = {
			ensure_installed = {
				"clojure_lsp",
				"gopls",
				"dhall_lsp_server",
				"denols",
				"yamlls",
				"fennel_ls",
				"lua_ls",
				"jdtls",
				"zls",
				"vtsls",
				"yamlls",
				"ts_ls",
				"gradle_ls",
			},
		},
	},
}
