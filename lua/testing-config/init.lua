local neotest_ns = vim.api.nvim_create_namespace("neotest")
vim.diagnostic.config({
	virtual_text = {
		format = function(diagnostic)
			local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
			return message
		end,
	},
}, neotest_ns)

local m = vim.keymap.set
local m = vim.keymap.set

require("neotest").setup({
	adapters = {
		require("neotest-vitest")({
			filter_dir = function(name)
				return name ~= "node_modules" and name:find("e2e") == nil
			end,
			is_test_file = function(path)
				local test = u.find_path(path, "src/.*/__tests__/.*%.test%.[jt]s$")
				local snapshot = u.find_path(path, "src/.*/__snapshots__")
				return test and not snapshot
			end,
		}),
		require("neotest-playwright").adapter({
			options = {
				persist_project_selection = true,
				enable_dynamic_test_discovery = true,
				is_test_file = function(path)
					local test = u.find_path(path, "e2e/tests/.*%.test%.[jt]s$")
					return test
				end,
				experimental = {
					telescope = {
						enabled = true,
						opts = {
							layout_strategy = "vertical",
							layout_config = {
								width = 0.25,
								height = 0.25,
								vertical = {
									prompt_position = "bottom",
								},
							},
						},
					},
				},
			},
		}),
		require("neotest-go"),
		-- require("neotest-golang"),
		["neotest-golang"] = {
			-- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
			dap_go_enabled = true,
		},
		require("neotest-jest")({
			jestCommand = "npm test --",
			env = { CI = true },
			cwd = function(path)
				return vim.fn.getcwd()
			end,
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
	--[[keys = {
		m("<leader>m", "Neotest summary"),
		m("<leader>M", function()
			vim.cmd("NeotestPlaywrightRefresh")
			vim.cmd.write()
		end),
		m("[n", function()
			require("neotest").jump.prev({ status = "failed" })
		end),
		m("]n", function()
			require("neotest").jump.next({ status = "failed" })
		end),
		m("<leader>n", function()
			vim.g.catgoose_terminal_enable_startinsert = 0
			require("neotest").run.run()
		end),
		m("<leader>N", function()
			vim.g.catgoose_terminal_enable_startinsert = 0
			require("neotest").run.run(vim.fn.expand("%"))
		end),
		m("<leader>1", function()
			---@diagnostic disable-next-line: missing-parameter
			require("neotest").watch.stop()
		end),
		m("<leader>2", function()
			---@diagnostic disable-next-line: missing-parameter
			require("neotest").watch.watch()
		end),
		m("<leader>3", function()
			---@diagnostic disable-next-line: missing-parameter
			require("neotest").watch.watch(vim.fn.expand("%"))
		end),
		m("<leader>4", function()
			require("neotest").output_panel.toggle()
		end),
		m("<leader>8", function()
			vim.g.catgoose_terminal_enable_startinsert = 1
			require("neotest").output.open({
				enter = true,
				auto_close = true,
			})
		end),
		m("<leader>9", function()
			---@diagnostic disable-next-line: undefined-field
			require("neotest").playwright.attachment()
		end),
	},
  ]]
	--
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
