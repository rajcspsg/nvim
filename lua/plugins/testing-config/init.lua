return {
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
			"mikovsky/neotest-scala",
			"thenbe/neotest-playwright",
			"lawrence-laz/neotest-zig",
			"mrcjkb/neotest-haskell",
			"rcasia/neotest-java",
			"mrcjkb/rustaceanvim",
		},
		config = function()
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						local message =
							diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)

			local m = vim.keymap.set

			require("neotest").setup({
				adapters = {
					require("neotest-haskell")({
						build_tools = { "stack", "cabal" },
						frameworks = {
							{ framework = "tasty", modules = { "Test.Tasty", "MyTestModule" } },
							"hspec",
							"sydtest",
						},
					}),
					require("neotest-java")({
						ignore_wrapper = true,
					}),
					require("rustaceanvim.neotest")({}),

					require("neotest-playwright").adapter({}),
					require("neotest-go")({
						recursive_run = true,
						dap_go_enabled = true,
					}),
					-- require("neotest-golang"),
					["neotest-golang"] = {
						-- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
						dap_go_enabled = true,
					},
					require("neotest-jest")({
						jestCommand = "npm test --",
						env = { CI = true },
						jest_test_discovery = true,
						jestConfigFile = "jest.config.js",
						cwd = function()
							return vim.fn.getcwd()
						end,
					}),
					require("neotest-scala"),
					require("neotest-zig")({
						dap = {
							adapter = "lldb",
						},
					}),
				},
				consumers = {
					playwright = require("neotest-playwright.consumers").consumers,
				},
				quickfix = {
					enabled = true,
					open = false,
				},
				output = {
					enabled = true,
					open_on_run = "short",
				},
				cmd = {
					"Neotest",
					"NeotestPlaywrightProject",
					"NeotestPlaywrightPreset",
					"NeotestPlaywrightRefresh",
				},
				config = {
					output_panel = { open = "botright split | resize 15", open_on_run = true },
					summary = {
						open = "botright vsplit | vertical resize 50",
					},
					discovery = {
						concurrent = 2,
					},
					diagnostic = true,
				},
				keys = {
					{
						"<C-c>nt",
						function()
							require("neotest").run.run(vim.fn.expand("%"))
						end,
						desc = "Run File",
					},
					{
						"<C-c>nT",
						function()
							require("neotest").run.run(vim.loop.cwd())
						end,
						desc = "Run All Test Files",
					},
					{
						"<C-c>nr",
						function()
							require("neotest").run.run()
						end,
						desc = "Run Nearest",
					},
					{
						"<C-c>ns",
						function()
							require("neotest").summary.toggle()
						end,
						desc = "Toggle Summary",
					},
					{
						"<C-c>no",
						function()
							require("neotest").output.open({ enter = true, auto_close = true })
						end,
						desc = "Show Output",
					},
					{
						"<C-c>nO",
						function()
							require("neotest").output_panel.toggle()
						end,
						desc = "Toggle Output Panel",
					},
					{
						"<C-c>nS",
						function()
							require("neotest").run.stop()
						end,
						desc = "Stop",
					},
					---@diagnostic disable-next-line: missing-fields
					{
						"<C-c>nd",
						function()
							require("neotest").run.run({ strategy = "dap" })
						end,
						desc = "Debug Nearest",
					},
				},
				diagnostic = {
					enabled = false,
				},
				floating = {
					border = "rounded",
					max_height = 0.6,
					max_width = 0.6,
				},
				highlights = {
					adapter_name = "NeotestAdapterName",
					border = "NeotestBorder",
					dir = "NeotestDir",
					expand_marker = "NeotestExpandMarker",
					failed = "NeotestFailed",
					file = "NeotestFile",
					focused = "NeotestFocused",
					indent = "NeotestIndent",
					namespace = "NeotestNamespace",
					passed = "NeotestPassed",
					running = "NeotestRunning",
					skipped = "NeotestSkipped",
					test = "NeotestTest",
				},
				icons = {
					child_indent = "│",
					child_prefix = "├",
					collapsed = "─",
					expanded = "╮",
					failed = "✖",
					final_child_indent = " ",
					final_child_prefix = "╰",
					non_collapsible = "─",
					passed = "✔",
					running = "",
					skipped = "ﰸ",
					unknown = "?",
				},
				output = {
					enabled = true,
					open_on_run = true,
				},
				run = {
					enabled = true,
				},
				status = {
					enabled = true,
				},
				strategies = {
					integrated = {
						height = 40,
						width = 120,
					},
				},
				summary = {
					enabled = true,
					expand_errors = true,
					follow = true,
					mappings = {
						attach = "a",
						expand = { "<CR>", "<2-LeftMouse>" },
						expand_all = "e",
						jumpto = "i",
						output = "o",
						run = "r",
						short = "O",
						stop = "u",
					},
				},
			})

			vim.cmd([[
command! NeotestSummary lua require("neotest").summary.toggle()
command! NeotestFile lua require("neotest").run.run(vim.fn.expand("%"))
command! Neotest lua require("neotest").run.run(vim.fn.getcwd())
command! NeotestNearest lua require("neotest").run.run()
command! NeotestDebug lua require("neotest").run.run({ strategy = "dap" })
command! NeotestAttach lua require("neotest").run.attach()
command! NeotestOutput lua require("neotest").output.open()
]])
		end,
	},
}
