return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"nvim-telescope/telescope.nvim", -- optional
		"sindrets/diffview.nvim", -- optional
		-- "ibhagwan/fzf-lua", -- optional
	},
	config = function()
		require("gitsigns").setup()
	end,
	opts = {
		disable_context_highlighting = true,
		disable_line_numbers = false,
		integrations = {
			-- If enabled, use telescope for menu selection rather than vim.ui.select.
			-- Allows multi-select and some things that vim.ui.select doesn't.
			telescope = true,
			-- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `diffview`.
			-- The diffview integration enables the diff popup.
			--
			-- Requires you to have `sindrets/diffview.nvim` installed.
			diffview = true,

			-- If enabled, uses fzf-lua for menu selection. If the telescope integration
			-- is also selected then telescope is used instead
			-- Requires you to have `ibhagwan/fzf-lua` installed.
			fzf_lua = nil,
		},
	},
	-- branch = "nightly",
	keys = {
		{ "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
		--    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
	},
}
