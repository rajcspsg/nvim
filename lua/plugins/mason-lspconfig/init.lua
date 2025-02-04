return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
		opts = {
			ensure_installed = {
				"eslint-lsp",
				"dhall-lsp",
				"prettierd",
				"tailwindcss-language-server",
				"typescript-language-server",
				"stylua",
				"isort",
				"black",
				"pylint",
				"eslint_d",
				"yaml-language-server",
				"yamlfix",
				"yamllint",
				"yamlfmt",
				"zls",
				"lua-language-server",
				"haskell-debug-adapter",
				"haskell-lnaguage-server",
				"jdtls",
				"java-test",
				"java-debug-adapter",
				"clj-kondo",
				"clojure-lsp",
				"gradle-language-server",
				"gopls",
				"delve",
				"golangci-lint",
				"golangci-lint-langserver",
				"stylua",
				"elixir-ls",
				"nixd",
				"go-debug-adapter",
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
	},
	-- Auto-Install LSPs, linters, formatters, debuggers
	-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			--[[ensure_installed = {
				"java-debug-adapter",
				"java-test",
				"gofumpt",
				"golines",
				"gomodifytags",
				"gotests",
				"impl",
				"json-to-struct",
			},]]
			--
		},
	},
}
