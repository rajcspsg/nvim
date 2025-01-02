-- vim.opt.rtp:prepend(lazypath)

local plugins = {
	{ "AstroNvim/astrotheme" },
	{
		"MunifTanjim/nui.nvim",
		lazy = false,
	},
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
	"crispgm/nvim-go",
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
	{
		"tadmccorkle/markdown.nvim",
		ft = "markdown", -- or 'event = "VeryLazy"'
		opts = {
			-- configuration here or empty for defaults
		},
	},
	{
		"kosayoda/nvim-lightbulb",
		config = function()
			require("nvim-lightbulb").setup({
				autocmd = { enabled = true },
			})
		end,
	},
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
		"cuducos/yaml.nvim",
		ft = { "yaml" }, -- optional
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = function()
			require("yaml_nvim").setup({ ft = { "yaml" } })
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},
	{
		"onsails/lspkind-nvim",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"blanktiger/aqf.nvim",
		config = function()
			require("aqf").setup({})
		end,
	},
	{
		"kosayoda/nvim-lightbulb",
		event = "LspAttach",
		opts = {
			autocmd = { enabled = true },
			sign = { enabled = true, text = "" },
			action_kinds = { "quickfix", "refactor" },
			ignore = {
				actions_without_kind = true,
			},
		},
	},
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
		"zbirenbaum/neodim",
		event = "LspAttach",
		opts = {
			alpha = 0.60,
		},
	},
	{
		"Bekaboo/dropbar.nvim",
		-- event = { "BufReadPost", "BufNewFile" },
		config = function()
			-- turn off global option for windowline
			vim.opt.winbar = nil
			vim.keymap.set("n", "<leader>ls", require("dropbar.api").pick, { desc = "[s]ymbols" })
		end,
		enabled = true,
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
		},
	},
	{ "kazhala/close-buffers.nvim" },
	{
		"alexghergh/nvim-tmux-navigation",
		config = function()
			local nvim_tmux_nav = require("nvim-tmux-navigation")

			nvim_tmux_nav.setup({
				disable_when_zoomed = true, -- defaults to false
			})

			vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
			vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
			vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
			vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
			vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
			vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
		end,
	},
	{ "nvim-tree/nvim-web-devicons" },
	{
		"gen740/SmoothCursor.nvim",
	},
	{ "windwp/nvim-autopairs" },
	{
		"HiPhish/rainbow-delimiters.nvim",
		enabled = true,
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")
			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					vim = rainbow_delimiters.strategy["local"],
					html = rainbow_delimiters.strategy["local"],
					commonlisp = rainbow_delimiters.strategy["local"],
					fennel = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
					javascript = "rainbow-parens",
					typescript = "rainbow-parens",
					tsx = "rainbow-parens",
					verilog = "rainbow-blocks",
				},
			}
		end,
	},
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
		"neovim/nvim-lspconfig",
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
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
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-lua/plenary.nvim",
		},
		ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
		opts = {
			tools = {
				codeLens = { autoRefresh = true },
				hoogle = { mode = "auto" },
				hover = { enable = true },
				definition = { hoogle_signature_fallback = true },
				repl = { handler = "toggleterm" },
			},
			dap = {
				cmd = { "haskell-debug-adapter --hackage-version=0.0.33.0" },
				auto_discover = true,
			},
		},
		config = function(_, opts)
			vim.g.haskell_tools = opts

			-- Set bindings only when the plugin is loaded
			local group = vim.api.nvim_create_augroup("HaskellTools", { clear = true })
			vim.api.nvim_create_autocmd("Filetype", {
				pattern = { "haskell", "lhaskell", "cabal", "cabalproject" },
				group = group,
				callback = function(args)
					local wk = require("which-key")
					local ht = require("haskell-tools")
					wk.add({
						{
							buffer = args.buf,
							{ "<leader>ch", group = "haskell" },
							{ "<leader>chc", vim.lsp.codelens.run, desc = "Run Codelens" },
							{ "<leader>chs", ht.hoogle.hoogle_signature, desc = "Hoogle Signature" },
							{ "<leader>chR", ht.repl.toggle, desc = "Toggle REPL" },
							{
								"<leader>chr",
								function()
									ht.repl.toggle(vim.api.nvim_buf_get_name(0))
								end,
								desc = "Toggle REPL for current buffer",
							},
							{ "<leader>chq", ht.repl.quit, desc = "Quit REPL" },
							{ "<leader>che", ht.lsp.buf_eval_all, desc = "Evaluate all" },
						},
					})
				end,
			})
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
			},
		},
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
	--[[{
		"SmiteshP/nvim-navic",
		event = { "CursorMoved", "BufWinEnter", "BufFilePost" },
		config = function()
			local caretRight = ""
			vim.api.nvim_set_hl(0, "NavicText", { link = "Winbar" })
			vim.api.nvim_set_hl(0, "NavicSeparator", { link = "Winbar" })

			require("nvim-navic").setup({
				lsp = {
					auto_attach = true,
					preference = nil,
				},
				highlight = true,
				separator = " " .. caretRight .. " ",
				depth_limit = 0,
				depth_limit_indicator = "..",
				safe_output = true,
			})

			require("rajnvim.winbar")
		end,
		dependencies = "neovim/nvim-lspconfig",
	},--]]
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
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-jest",
			"marilari88/neotest-vitest",
			"nvim-neotest/neotest-go",
			"stevanmilic/neotest-scala",
			"thenbe/neotest-playwright",
			"lawrence-laz/neotest-zig",
			"mrcjkb/neotest-haskell",
		},
	},
	{
		"saghen/blink.cmp",
		-- lazy = false,
		event = { "InsertEnter *", "CmdlineEnter *" },
		enabled = true,
		version = "*",
		-- build = "cargo build --release",
		cond = vim.g.completer == "blink",
		dependencies = {
			"rafamadriz/friendly-snippets",
			{ "saghen/blink.compat", version = "*", opts = { impersonate_nvim_cmp = true } },
			{ "chrisgrieser/cmp-nerdfont", lazy = true },
			{ "hrsh7th/cmp-emoji", lazy = true },
		},
		opts = {
			-- enabled = function()
			--   -- prevent useless suggestions when typing `--` in lua, but keep the
			--   -- `---@param;@return` suggestion
			--   if vim.bo.ft == "lua" then
			--     local col = vim.api.nvim_win_get_cursor(0)[2]
			--     local charsBefore = vim.api.nvim_get_current_line():sub(col - 2, col)
			--     local commentButNotLuadocs = charsBefore:find("^%-%-?$") or charsBefore:find("%s%-%-?")
			--     if commentButNotLuadocs then return false end
			--   end

			--   if vim.bo.buftype == "prompt" then return false end
			--   local ignoredFts = { "DressingInput", "snacks_input", "rip-substitute", "gitcommit" }
			--   return not vim.tbl_contains(ignoredFts, vim.bo.filetype)
			-- end,
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "lazydev" },
				-- default = function(ctx)
				--   -- local node = vim.treesitter.get_node()
				--   -- if vim.bo.filetype == "lua" then
				--   --   return { "lsp", "path" }
				--   -- elseif node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
				--   --   return { "buffer" }
				--   -- else
				--   return { "lsp", "path", "snippets", "buffer", "codecompanion", "lazydev", "copilot" }
				--   -- end
				-- end,
				-- compat = { "supermaven" },
				-- min_keyword_length = function()
				--   --   return vim.bo.filetype == 'markdown' and 2 or 0
				--   return 2
				-- end,
				-- cmdline = function()
				--   local type = vim.fn.getcmdtype()
				--   -- Search forward and backward
				--   if type == "/" or type == "?" then return { "buffer" } end
				--   -- Commands
				--   if type == ":" then return { "cmdline" } end
				--   return {}
				-- end,
				providers = {
					lsp = {
						name = "[lsp]",
					},
					snippets = {
						name = "[snips]",
						-- don't show when triggered manually (= length 0), useful
						-- when manually showing completions to see available JSON keys
						min_keyword_length = 2,
						score_offset = -1,
					},
					path = { name = "[path]", opts = { get_cwd = vim.uv.cwd } },
					-- copilot = {
					--   name = "[copilot]",
					--   module = "blink-cmp-copilot",
					--   score_offset = 100,
					--   async = true,
					-- },
					lazydev = {
						name = "[lazy]",
						module = "lazydev.integrations.blink",
						score_offset = 100, -- show at a higher priority than lsp
					},
					markdown = { name = "[md]", module = "render-markdown.integ.blink" },
					-- supermaven = { name = "[super]", kind = "Supermaven", module = "supermaven.cmp", score_offset = 100, async = true },
					-- codecompanion = {
					--   name = "codecompanion",
					--   module = "codecompanion.providers.completion.blink",
					--   enabled = true,
					-- },
					buffer = {
						name = "[buf]",
						-- disable being fallback for LSP, but limit its display via
						-- the other settings
						-- fallbacks = {},
						max_items = 4,
						min_keyword_length = 4,
						score_offset = -3,

						-- show completions from all buffers used within the last x minutes
						opts = {
							get_bufnrs = function()
								local mins = 15
								local allOpenBuffers = vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 })
								local recentBufs = vim.iter(allOpenBuffers)
									:filter(function(buf)
										local recentlyUsed = os.time() - buf.lastused < (60 * mins)
										local nonSpecial = vim.bo[buf.bufnr].buftype == ""
										return recentlyUsed and nonSpecial
									end)
									:map(function(buf)
										return buf.bufnr
									end)
									:totable()
								return recentBufs
							end,
						},
					},
				},
			},
			keymap = {
				["<C-c>"] = { "cancel" },
				["<C-y>"] = { "select_and_accept", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<PageDown>"] = { "scroll_documentation_down" },
				["<PageUp>"] = { "scroll_documentation_up" },
			},
			signature = { enabled = true },
			completion = {
				-- ghost_text = {
				--   enabled = true,
				-- },
				-- enabled_providers = function(_)
				--   -- if vim.bo.filetype == "codecompanion" then return { "codecompanion" } end

				--   return { "lsp", "path", "snippets", "buffer", "markdown", "supermaven", "codecompanion" }
				-- end,
				list = {
					cycle = { from_top = false }, -- cycle at bottom, but not at the top
					selection = "manual", -- alts: auto_insert, preselect
				},
				accept = {
					auto_brackets = {
						-- Whether to auto-insert brackets for functions
						enabled = true,
						-- Default brackets to use for unknown languages
						default_brackets = { "(", ")" },
						-- Overrides the default blocked filetypes
						override_brackets_for_filetypes = { "rust", "elixir", "heex", "lua" },
						-- Synchronously use the kind of the item to determine if brackets should be added
						kind_resolution = {
							enabled = true,
							blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
						},
						-- Asynchronously use semantic token to determine if brackets should be added
						semantic_token_resolution = {
							enabled = true,
							blocked_filetypes = {},
							-- How long to wait for semantic tokens to return before assuming no brackets should be added
							timeout_ms = 400,
						},
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
					window = {
						border = { " ", " ", " ", " ", " ", " ", " ", " " },
						max_width = 50,
						max_height = 15,
					},
				},
				menu = {
					border = { " ", " ", " ", " ", " ", " ", " ", " " },
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind", gap = 1 },
							{ "source_name" },
						},
						components = {
							label = { width = { max = 30, fill = true } }, -- more space for doc-win
							label_description = { width = { max = 20 } },
							kind_icon = {
								text = function(ctx)
									-- detect emmet-ls
									local source, client = ctx.item.source_id, ctx.item.client_id
									local lspName = client and vim.lsp.get_client_by_id(client).name
									if lspName == "emmet_language_server" then
										source = "emmet"
									end

									-- use source-specific icons, and `kind_icon` only for items from LSPs
									local sourceIcons =
										{ snippets = "󰩫", buffer = "󰦨", emmet = "", path = "" }
									return sourceIcons[source] or ctx.kind_icon
								end,
							},
							source_name = {
								width = { max = 30, fill = true },
								text = function(ctx)
									if ctx.item.source_id == "lsp" then
										local client = vim.lsp.get_client_by_id(ctx.item.client_id)
										if client ~= nil then
											return string.format("[%s]", client.name)
										end
										return ctx.source_name
									end

									return ctx.source_name
								end,
								highlight = "BlinkCmpSource",
							},
						},
					},
				},
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
				kind_icons = {
					-- different icons of the corresponding source
					Text = "󰦨", -- `buffer`
					Snippet = "󰞘", -- `snippets`
					File = "", -- `path`
					Folder = "󰉋",
					Method = "󰊕",
					Function = "󰡱",
					Constructor = "",
					Field = "󰇽",
					Variable = "󰀫",
					Class = "󰜁",
					Interface = "",
					Module = "",
					Property = "󰜢",
					Unit = "",
					Value = "󰎠",
					Enum = "",
					Keyword = "󰌋",
					Color = "󰏘",
					Reference = "",
					EnumMember = "",
					Constant = "󰏿",
					Struct = "󰙅",
					Event = "",
					Operator = "󰆕",
					TypeParameter = "󰅲",
				},
			},
		},
	},
}

local opts = {}
require("lazy").setup(plugins, opts)
