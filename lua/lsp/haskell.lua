local g = vim.g

local keymap_opts = { noremap = true, silent = true }
local telescope = require("telescope")
local keymap = vim.keymap

g.haskell_tools = function()
	---@type haskell-tools.Opts
	local ht_opts = {
		tools = {
			repl = {
				handler = "toggleterm",
				auto_focus = false,
			},
			codeLens = {
				autoRefresh = false,
			},
			definition = {
				hoogle_signature_fallback = true,
			},
		},
		hls = {
			-- for hls development
			-- cmd = { 'cabal', 'run', 'haskell-language-server' },
			on_attach = function(_, bufnr, ht)
				local desc = function(description)
					return vim.tbl_extend("keep", keymap_opts, { buffer = bufnr, desc = description })
				end
				keymap.set("n", "gh", ht.hoogle.hoogle_signature, desc("haskell: [h]oogle signature search"))
				keymap.set(
					"n",
					"<space>tg",
					telescope.extensions.ht.package_grep,
					desc("haskell: [t]elescope package [g]rep")
				)
				keymap.set(
					"n",
					"<space>th",
					telescope.extensions.ht.package_hsgrep,
					desc("haskell: [t]elescope package grep [h]askell files")
				)
				keymap.set(
					"n",
					"<space>tf",
					telescope.extensions.ht.package_files,
					desc("haskell: [t]elescope package [f]iles")
				)
				keymap.set("n", "<space>ea", ht.lsp.buf_eval_all, desc("haskell: [e]valuate [a]ll"))
			end,
			default_settings = {
				haskell = {
					formattingProvider = "stylish-haskell",
					maxCompletions = 30,
					plugin = {
						semanticTokens = {
							globalOn = true,
						},
					},
				},
			},
		},
	}
	return ht_opts
end
