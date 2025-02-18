return {
	{
		"Vigemus/iron.nvim",
		keys = {
			{
				"<leader>ii",
				vim.cmd.IronRepl,
				desc = "󱠤 Toggle REPL",
			},
			{
				"<leader>ir",
				vim.cmd.IronRestart,
				desc = "󱠤 Restart REPL",
			},
			-- right hand side defined below
			{
				"<leader>iv",
				desc = "󱠤 Send Visual Selection to REPL",
			},
			{
				"<leader>if",
				desc = "󱠤 Send File to REPL",
			},
			{
				"<leader>il",
				desc = "󱠤 Send Line to REPL",
			},
		},

		-- tell lazy.nvim to `require("iron.core").setup`
		-- instead of `require("iron").setup`
		main = "iron.core",

		config = function(_, opts)
			local ironCore = require("iron.core")
			ironCore.setup(opts)

			local group = vim.api.nvim_create_augroup("IronRepl", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				pattern = supported_filetypes,
				group = group,
				callback = function(args)
					local wk = require("which-key")

          -- stylua: ignore
          wk.add({
            { buffer = args.buf, noremap = false, mode = { "n" },
              { "<C-c>r", group = "repl" },
              { "<C-c>rf", "<CMD>IronFocus<CR>", desc = "Focus REPL" },
              { "<C-c>rh", "<CMD>IronHide<CR>", desc = "Hide REPL" },
              { "<C-c>r<CR>", function() require("iron.core").send(nil, string.char(13)) end, desc = "Send <CR> to REPL" },
              { "<C-c>r<space>", function() require("iron.core").send(nil, string.char(03)) end, desc = "Send Interrupt to REPL" },
              { "<C-c>rq", function() require("iron.core").close_repl() end, desc = "Close REPL" },
              { "<C-c>rl", function() require("iron.core").send(nil, string.char(12)) end, desc = "Clear REPL" },
              { "<C-c>rF", function() require("iron.core").send_file() end, desc = "Send current file to REPL" },
              { "<C-c>re", function() require("iron.core").send_line() end, desc = "Send line to REPL" },
            },
            { mode = "v", buffer = args.buf,
              { "<C-c>r", group = "repl" },
              { "<C-c>re", function() require("iron.core").visual_send() end, desc = "Send line to REPL" },
            }
          })
				end,
			})
		end,
		opts = {
			keymaps = {
				visual_send = "<leader>iv",
				send_file = "<leader>if",
				send_line = "<leader>il",
			},
			config = {
				scratch_repl = false,
				repl_open_cmd = "horizontal bot 20 split",
				repl_definition = {
					sh = { command = { "fish" } },
					typescript = { command = { "./node_modules/.bin/ts-node" } },
					javascript = { command = { "node" } },
					nix = { command = { "nix", "repl", "--allow-dirty", "--impure" } },
					racket = { command = { "racket" } },
					purescript = { command = { "spago", "repl" } },
					elvish = { command = { "elvish" } },
					haskell = {
						command = function(meta)
							local file = vim.api.nvim_buf_get_name(meta.current_bufnr)
							return require("haskell-tools").repl.mk_repl_cmd(file)
						end,
					},
				},
				highlight = {
					italic = true,
				},

				ignore_blank_lines = true,
			},
		},
	},
}
