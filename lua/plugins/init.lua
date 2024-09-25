-- vim.opt.rtp:prepend(lazypath)

local plugins = {
	{ "AstroNvim/astrotheme" },
	{
		"MunifTanjim/nui.nvim",
		lazy = false,
	},
	"nvim-tree/nvim-web-devicons",
	{ "windwp/nvim-autopairs" },
	{ "tiagovla/scope.nvim" },
	{ "folke/which-key.nvim" },
	{
		"nvim-telescope/telescope.nvim",
		dependenciess = { { "nvim-lua/plenary.nvim" } },
	},
	"folke/twilight.nvim",
	"folke/zen-mode.nvim",
	"onsails/lspkind-nvim",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-vsnip",
	"hrsh7th/vim-vsnip",
	--{ "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			{
				"echasnovski/mini.bufremove",
				version = "*",
				config = function()
					require("mini.bufremove").setup({
						silent = true,
					})
				end,
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"folke/trouble.nvim",
		cmd = { "Trouble" },
		opts = {},
	},
	{
		"p00f/cphelper.nvim",
	},
	"voldikss/vim-floaterm",
	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
			})
		end,
	},
	"erietz/vim-terminator",
	{ "is0n/jaq-nvim" },
	{ "CRAG666/code_runner.nvim", dependencies = "nvim-lua/plenary.nvim" },
	{
		"nvimtools/none-ls.nvim",
		event = "VeryLazy",
	},
	{
		"windwp/nvim-ts-autotag",
		ft = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
		config = function()
			require("nvim-ts-autotag").setup({})
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"eslint-lsp",
				"prettierd",
				"tailwindcss-language-server",
				"typescript-language-server",
				"stylua",
				"isort",
				"black",
				"pylint",
				"eslint_d",
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		"simrat39/rust-tools.nvim",
	},
	"nanozuki/tabby.nvim",
	"glepnir/dashboard-nvim",
	"mfussenegger/nvim-jdtls",
	{ "scalameta/nvim-metals", dependenciess = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" } },
	"mfussenegger/nvim-dap",
	"gpanders/nvim-parinfer",
	"Olical/conjure",
	"PaterJason/cmp-conjure",
	"Olical/aniseed",
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
	{ "TreyBastian/nvim-jack-in", config = true },
	"echasnovski/mini.nvim",
	{
		"mrcjkb/haskell-tools.nvim",
		version = "^4", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
	{
		"julienvincent/clojure-test.nvim",
		dependencies = {
			"nvim-neotest/nvim-nio",
		},
	},
	{
		"boltlessengineer/bufterm.nvim",
		config = function()
			require("bufterm").setup()
		end,
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed, not both.
			"nvim-telescope/telescope.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
		},
		config = true,
	},
	{ "akinsho/git-conflict.nvim", version = "*", config = true },
	"ecosse3/galaxyline.nvim",
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		dependencies = {
			"nvim-treesitter/playground",
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	},
	{
		"nvim-treesitter/playground",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					svelte = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					graphql = { "prettier" },
					lua = { "stylua" },
					python = { "isort", "black" },
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>mp", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				})
			end, { desc = "Format file or range (in visual mode)" })
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		dependencies = "mrbjarksen/neo-tree-diagnostics.nvim",
		keys = {
			{
				"<leader>e",
				function()
					require("neo-tree.command").execute({ toggle = true, position = "left" })
				end,
				desc = "Explorer (root dir)",
				remap = true,
			},
			{
				"<leader>E",
				function()
					require("neo-tree.command").execute({
						toggle = true,
						position = "float",
					})
				end,
				desc = "Explorer Float (root dir)",
			},
		},
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		opts = require("rajnvim.neo-tree-opts"),
		init = function()
			vim.g.neo_tree_remove_legacy_commands = 1
			if vim.fn.argc() == 1 then
				local stat = vim.uv.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					---@diagnostic disable-next-line: different-requires
					require("neo-tree")
					vim.cmd([[set showtabline=0]])
				end
			end
		end,
	},
	{
		"isakbm/gitgraph.nvim",
		opts = {
			symbols = {
				merge_commit = "M",
				commit = "*",
			},
			format = {
				timestamp = "%H:%M:%S %d-%m-%Y",
				fields = { "hash", "timestamp", "author", "branch_name", "tag" },
			},
			hooks = {
				on_select_commit = function(commit)
					print("selected commit:", commit.hash)
				end,
				on_select_range_commit = function(from, to)
					print("selected range:", from.hash, to.hash)
				end,
			},
		},
		keys = {
			{
				"<leader>gl",
				function()
					require("gitgraph").draw({}, { all = true, max_count = 5000 })
				end,
				desc = "GitGraph - Draw",
			},
		},
	},
}

local opts = {}
require("lazy").setup(plugins, opts)
