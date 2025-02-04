return {
	{
		"sidebar-nvim/sidebar.nvim",
		config = function()
			local sidebar = require("sidebar-nvim")
			local opts = { open = false }
			sidebar.setup(opts)
		end,
	},
	{
		"oskarrrrrrr/symbols.nvim",
		config = function()
			local r = require("symbols.recipes")
			require("symbols").setup(r.DefaultFilters, r.AsciiSymbols, {
				-- custom settings here
				-- e.g. hide_cursor = false
			})
			vim.keymap.set("n", ",s", ":Symbols<CR>")
			vim.keymap.set("n", ",S", ":SymbolsClose<CR>")
		end,
	},
	{
		"3rd/image.nvim",
		build = false, -- do not build with hererocks
		dependencies = {
			"kiyoon/magick.nvim",
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		dependencies = {
			"mrbjarksen/neo-tree-diagnostics.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			{ "3rd/image.nvim", opts = {} },
		},
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
}
