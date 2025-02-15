return {
	{
		"dnlhc/glance.nvim",
		cmd = { "Glance" },
		event = "LspAttach",
		opts = {
			border = {
				enable = true,
			},
			use_trouble_qf = true,
			hooks = {
				before_open = function(results, open, jump, method)
					local uri = vim.uri_from_bufnr(0)
					if #results == 1 then
						local target_uri = results[1].uri or results[1].targetUri

						if target_uri == uri then
							jump(results[1])
						else
							open(results)
						end
					else
						open(results)
					end
				end,
			},
		},
	},
	{
		"nvim-lua/lsp-status.nvim",
	},
	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	},
	{
		"Bekaboo/dropbar.nvim",
		-- event = { "BufReadPost", "BufNewFile" },
		config = function()
			-- turn off global option for windowline
			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<leader>;", dropbar_api.pick, { desc = "[s]ymbols" })
			vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
			vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
		end,
		enabled = true,
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	{
		"zbirenbaum/neodim",
		event = "LspAttach",
		config = function()
			require("neodim").setup({
				alpha = 0.75,
				blend_color = "#000000",
				hide = {
					underline = true,
					virtual_text = true,
					signs = true,
				},
				regex = {
					"[uU]nused",
					"[nN]ever [rR]ead",
					"[nN]ot [rR]ead",
				},
				priority = 128,
				disable = {},
			})
		end,
	},
	{ "kosayoda/nvim-lightbulb" },
	{
		-- LSP INLAY HINTS
		"lvimuser/lsp-inlayhints.nvim",
		dependencies = "neovim/nvim-lspconfig",
	},
	{
		-- LSP DIAGNOSTICS
		"folke/trouble.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		keys = {
			{
				"<leader><leader>dc",
				"<Cmd>Trouble close<CR>",
				desc = "Close latest Trouble window",
				mode = "n",
				noremap = true,
				silent = true,
			},
			{
				"<leader><leader>da",
				"<Cmd>Trouble diagnostics focus=true<CR>",
				desc = "Open diagnostics for all buffers in Trouble",
				mode = "n",
				noremap = true,
				silent = true,
			},
			{
				"<leader><leader>db",
				"<Cmd>Trouble diagnostics focus=true filter.buf=0<CR>",
				desc = "Open diagnostics for current buffer in Trouble",
				mode = "n",
				noremap = true,
				silent = true,
			},
			{
				"<leader><leader>lr",
				"<Cmd>Trouble lsp_references focus=true<CR>",
				desc = "Open any references to this symbol in Trouble",
				mode = "n",
				noremap = true,
				silent = true,
			},
			{
				"]t",
				function()
					require("trouble").next({ skip_groups = false, jump = true })
				end,
				desc = "Next item",
				mode = "n",
				noremap = true,
				silent = true,
			},
			{
				"[t",
				function()
					require("trouble").prev({ skip_groups = false, jump = true })
				end,
				desc = "Prev item",
				mode = "n",
				noremap = true,
				silent = true,
			},
		},
		config = function()
			require("trouble").setup({
				-- modes = {
				--   diagerrs = {
				--     mode = "diagnostics", -- inherit from diagnostics mode
				--     filter = {
				--       any = {
				--         buf = 0,                                    -- current buffer
				--         {
				--           severity = vim.diagnostic.severity.ERROR, -- errors only
				--           -- limit to files in the current project
				--           function(item)
				--             return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
				--           end,
				--         }
				--       }
				--     }
				--   }
				-- }
			})

			-- Trouble todo toggle filter.buf=0
		end,
	},
	{
		-- LSP VIRTUAL TEXT
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()

			-- disable virtual_text since it's redundant due to lsp_lines.
			vim.diagnostic.config({ virtual_text = false })

			-- TODO: Consider https://github.com/folke/lazy.nvim/discussions/1652
		end,
	},
	{
		-- -- CODE ACTION INDICATOR
		"luckasRanarison/clear-action.nvim",
		opts = {},
	},
	{
		-- CODE ACTIONS POPUP
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		event = "LspAttach",
		config = function()
			require("tiny-code-action").setup()
			vim.keymap.set("n", "<leader><leader>la", function()
				require("tiny-code-action").code_action()
			end, { noremap = true, silent = true, desc = "code action menu" })
		end,
	},
	{
		-- ADD MISSING DIAGNOSTICS HIGHLIGHT GROUPS
		"folke/lsp-colors.nvim",
		config = true,
	},
	"mfussenegger/nvim-jdtls",
	{ "scalameta/nvim-metals", dependenciess = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" } },
	--[[{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},]]--
	{
		"kevinhwang91/nvim-hlslens",
		config = function()
			require("hlslens").setup({})
		end,
	},
	{
		"VidocqH/lsp-lens.nvim",
		config = function()
			require("lsp-lens").setup({})
		end,
	},
	{
		-- LSP INLAY HINTS
		"lvimuser/lsp-inlayhints.nvim",
		dependencies = "neovim/nvim-lspconfig",
	},
	{
		-- LSP DIAGNOSTICS
		"folke/trouble.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		keys = {
			{
				"<leader><leader>dc",
				"<Cmd>Trouble close<CR>",
				desc = "Close latest Trouble window",
				mode = "n",
				noremap = true,
				silent = true,
			},
			{
				"<leader><leader>da",
				"<Cmd>Trouble diagnostics focus=true<CR>",
				desc = "Open diagnostics for all buffers in Trouble",
				mode = "n",
				noremap = true,
				silent = true,
			},
			{
				"<leader><leader>db",
				"<Cmd>Trouble diagnostics focus=true filter.buf=0<CR>",
				desc = "Open diagnostics for current buffer in Trouble",
				mode = "n",
				noremap = true,
				silent = true,
			},
			{
				"<leader><leader>lr",
				"<Cmd>Trouble lsp_references focus=true<CR>",
				desc = "Open any references to this symbol in Trouble",
				mode = "n",
				noremap = true,
				silent = true,
			},
			{
				"]t",
				function()
					require("trouble").next({ skip_groups = false, jump = true })
				end,
				desc = "Next item",
				mode = "n",
				noremap = true,
				silent = true,
			},
			{
				"[t",
				function()
					require("trouble").prev({ skip_groups = false, jump = true })
				end,
				desc = "Prev item",
				mode = "n",
				noremap = true,
				silent = true,
			},
		},
		config = function()
			require("trouble").setup({
				-- modes = {
				--   diagerrs = {
				--     mode = "diagnostics", -- inherit from diagnostics mode
				--     filter = {
				--       any = {
				--         buf = 0,                                    -- current buffer
				--         {
				--           severity = vim.diagnostic.severity.ERROR, -- errors only
				--           -- limit to files in the current project
				--           function(item)
				--             return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
				--           end,
				--         }
				--       }
				--     }
				--   }
				-- }
			})

			-- Trouble todo toggle filter.buf=0
		end,
	},
	{
		-- LSP VIRTUAL TEXT
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()

			-- disable virtual_text since it's redundant due to lsp_lines.
			vim.diagnostic.config({ virtual_text = false })

			-- TODO: Consider https://github.com/folke/lazy.nvim/discussions/1652
		end,
	},
	{
		-- -- CODE ACTION INDICATOR
		"luckasRanarison/clear-action.nvim",
		opts = {},
	},
	{
		-- CODE ACTIONS POPUP
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		event = "LspAttach",
		config = function()
			require("tiny-code-action").setup()
			vim.keymap.set("n", "<leader><leader>la", function()
				require("tiny-code-action").code_action()
			end, { noremap = true, silent = true, desc = "code action menu" })
		end,
	},
	{
		-- ADD MISSING DIAGNOSTICS HIGHLIGHT GROUPS
		"folke/lsp-colors.nvim",
		config = true,
	},
	{ "RRethy/vim-illuminate" },
	{
		"sphamba/smear-cursor.nvim",
		cond = function()
			return not vim.g.neovide
		end,
		event = "VeryLazy",
		opts = {
			cursor_color = "#ff8800",
			stiffness = 0.6,
			trailing_stiffness = 0.1,
			trailing_exponent = 5,
			gamma = 1,
			distance_stop_animating = 0.5,
			hide_target_hack = false,
			windows_zindex = 47,

			-- Smear cursor when switching buffers or windows.
			smear_between_buffers = true,

			-- Smear cursor when moving within line or to neighbor lines.
			smear_between_neighbor_lines = true,

			-- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
			-- Smears will blend better on all backgrounds.
			legacy_computing_symbols_support = false,
		},
	},
	{
		"nvim-lua/lsp-status.nvim",
	},
	{
		"nvimdev/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
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
}
