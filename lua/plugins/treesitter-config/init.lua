return {
	{
		"bbjornstad/pretty-fold.nvim",
		config = function()
			require("pretty-fold").setup()
		end,
	},
	{
		"anuvyklack/fold-preview.nvim",
		dependencies = { "anuvyklack/keymap-amend.nvim" },
		config = function()
			require("fold-preview").setup({
				-- Your configuration goes here.
			})
		end,
	},
	{
		"nvim-treesitter/playground",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"ldelossa/litee.nvim",
		event = "VeryLazy",
		opts = {
			notify = { enabled = false },
			panel = {
				orientation = "bottom",
				panel_size = 10,
			},
		},
		config = function(_, opts)
			require("litee.lib").setup(opts)
		end,
	},

	{
		"ldelossa/litee-calltree.nvim",
		dependencies = "ldelossa/litee.nvim",
		event = "VeryLazy",
		opts = {
			on_open = "panel",
			map_resize_keys = false,
		},
		config = function(_, opts)
			require("litee.calltree").setup(opts)
		end,
	},
	{ "slyces/hierarchy.nvim", requires = "nvim-treesitter/nvim-treesitter" },
	{
		"bassamsdata/namu.nvim",
		config = function()
			require("namu").setup({
				-- Enable the modules you want
				namu_symbols = {
					enable = true,
					options = {}, -- here you can configure namu
				},
				-- Optional: Enable other modules if needed
				colorscheme = {
					enable = false,
					options = {
						-- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
						persist = true, -- very efficient mechanism to Remember selected colorscheme
						write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
					},
				},
				ui_select = { enable = false }, -- vim.ui.select() wrapper
			})
			-- === Suggested Keymaps: ===
			--local namu = require("namu.namu_symbols")
			--local colorscheme = require("namu.colorscheme")
			vim.keymap.set("n", "<leader>ss", ":Namu symbols<cr>", {
				desc = "Jump to LSP symbol",
				silent = true,
			})
			vim.keymap.set("n", "<leader>th", ":Namu colorscheme<cr>", {
				desc = "Colorscheme Picker",
				silent = true,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/nvim-treesitter-refactor",
		},
		config = function()
			require("treesitter-context").setup({
				ensure_installed = {
					"clojure",
					"lua",
					"javascript",
					"typescript",
					"python",
					"go",
					"jsx",
					"tsx",
					"haskell",
					"java",
					"zig",
					"rust",
					"nix",
				},
				enable = false, -- Enable this plugin (Can be enabled/disabled later via commands)
				max_lines = 1, -- How many lines the window should span. Values <= 0 mean no limit.
				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 20, -- Maximum number of lines to show for a single context
				trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
				-- Separator between context and content. Should be a single character string, like '-'.
				-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
				separator = nil,
				zindex = 20, -- The Z-index of the context window
				on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
			})
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
				incremental_selection = {
					enable = false,
					keymaps = {
						init_selection = "<leader>gnn",
						node_incremental = "<leader>gnr",
						scope_incremental = "<leader>gne",
						node_decremental = "<leader>gnt",
					},
				},
				refactor = {
					smart_rename = {
						enable = true,
						keymaps = {
							smart_rename = "<leader>cr",
						},
					},
				},
				textobjects = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["aa"] = "@paramater.outer", -- 'a' for argument
						["ia"] = "@paramater.inner",
						["ac"] = "@comment.outer",
						["ic"] = "@comment.inner",
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]f"] = "@function.outer",
							["]a"] = "@parameter.inner",
							["]c"] = "@comment.outer",
						},
						goto_next_end = {},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[a"] = "@parameter.inner",
							["[c"] = "@comment.outer",
						},
						goto_previous_end = {},
						-- Below will go to either the start or the end, whichever is closer.
						-- Use if you want more granular movements
						-- Make it even more gradual by adding multiple queries and regex.
						goto_next = {},
						goto_previous = {},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>za"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>zA"] = "@parameter.inner",
						},
					},
					lsp_interop = {
						enable = true,
						border = "rounded",
						peek_definition_code = {
							["<leader>zg"] = "@function.outer",
							["<leader>zG"] = "@class.outer",
						},
					},
				},
			})

			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
			-- vim way: ; goes to the direction you were moving.
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
			-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
		end,
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
		"RRethy/nvim-treesitter-endwise",
		dependencies = "nvim-treesitter/nvim-treesitter",
		event = "InsertEnter",
	},

	{
		"tronikelis/ts-autotag.nvim",
		event = "InsertEnter",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = true,
	},

	{
		"Wansmer/treesj",
		cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
		keys = {
			{ "<M-C-K>", desc = "Join current treesitter node" },
			{ "<M-C-Up>", desc = "Join current treesitter node" },
			{ "<M-NL>", desc = "Split current treesitter node" },
			{ "<M-C-Down>", desc = "Split current treesitter node" },
			{ "g<M-NL>", desc = "Split current treesitter node recursively" },
			{ "g<M-C-Down>", desc = "Split current treesitter node recursively" },
		},
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("configs.treesj")
		end,
	},

	{
		"Eandrju/cellular-automaton.nvim",
		cmd = "CellularAutomaton",
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
	{ "PaterJason/nvim-treesitter-sexp" },
	{
		"aaronik/treewalker.nvim",

		-- The following options are the defaults.
		-- Treewalker aims for sane defaults, so these are each individually optional,
		-- and setup() does not need to be called, so the whole opts block is optional as well.
		opts = {
			-- Whether to briefly highlight the node after jumping to it
			highlight = true,

			-- How long should above highlight last (in ms)
			highlight_duration = 250,

			-- The color of the above highlight. Must be a valid vim highlight group.
			-- (see :h highlight-group for options)
			highlight_group = "CursorLine",
		},
	},
	{
		"maxbol/treesorter.nvim",
		cmd = "TSort",
		config = function()
			require("treesorter").setup()
		end,
	},
}
