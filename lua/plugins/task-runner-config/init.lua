OpenTaskBufnr = {}

return {
	-- {
	--   "kndndrj/nvim-projector",
	--   dependencies = {
	--     -- Any extra extensions that you want:
	--     "kndndrj/projector-loader-vscode",
	--   },
	--   opts = {},
	--   keys = { { "<leader>p!", "<cmd>lua require('projector').continue()<cr>", desc = "Projector continue" } },
	-- },
	{
		"stevearc/overseer.nvim",
		dependencies = { "declancm/windex.nvim", "akinsho/toggleterm.nvim" },
		-- event = "VeryLazy",
		cmd = { "OverseerInfo", "OverseerOpen", "OverseerRun", "OverseerBuild", "OverseerRunCmd", "OverseerToggle" },
		keys = {
			{ "<leader>p!", "<cmd>OverseerRunCmd<cr>", desc = "Run cmd in project root" },
			{ "<leader>pc", "<cmd>OverseerBuild<cr>", desc = "Compile in project" },
			{ "<leader>pr", "<cmd>OverseerRun<cr>", desc = "Run project" },
			{ "<leader>pl", "<cmd>OverseerRestartLast<cr>", desc = "Run last task" },
			{ "<leader>pp", "<cmd>OverseerToggle<cr>", desc = "Toggle task list" },
			{ "<leader>pa", "<cmd>OverseerTaskAction<cr>", desc = "Task action list" },
			{ "<leader>pC", "<cmd>OverseerClearCache<cr>", desc = "Clear overseer cache" },
		},
		opts = function()
			local util = require("overseer.util")
			local STATUS = require("overseer.constants").STATUS

			local function close_task(bufnr)
				for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
					if vim.api.nvim_win_is_valid(winnr) then
						local winbufnr = vim.api.nvim_win_get_buf(winnr)
						if vim.bo[winbufnr].filetype == "OverseerPanelTask" then
							local oldwin = vim.tbl_filter(function(t)
								return (t.strategy.bufnr == bufnr)
							end, require("overseer").list_tasks())[1]
							if oldwin then
								vim.api.nvim_win_close(winnr, true)
							end
						end
					end
				end
			end

			return {
				templates = { "builtin", "rewriter", "user" },
				-- strategy = { "jobstart", preserve_output = true, use_terminal = true },
				-- strategy = "terminal",
				-- strategy = "toggleterm",
				-- strategy = {
				--   "toggleterm",
				--   use_shell = false,
				--   auto_scroll = false,
				--   close_on_exit = false,
				--   quit_on_exit = "never",
				--   open_on_start = true,
				--   hidden = true,
				--   on_create = function() end,
				-- },
				log = {
					{ type = "echo", level = vim.log.levels.WARN },
					{ type = "file", filename = "overseer.log", level = vim.log.levels.DEBUG },
				},
				-- task_launcher = { bindings = { n = { ["<leader>pq"] = "Cancel" } } },
				task_list = {
					direction = "left",
					min_height = 20,
					height = math.floor(vim.o.lines * 0.3),
					max_height = 40,
					bindings = {
						["?"] = "ShowHelp",
						["<CR>"] = "RunAction",
						["<c-e>"] = "Edit",
						["q"] = function()
							require("overseer").close()
						end,
						["o"] = "Open vsplit",
						["O"] = "Open",
						["<c-;>"] = "<cmd>lua require('windex').switch_window('right')<cr>",
						["<c-h>"] = "<cmd>lua require('windex').switch_window('right')<cr>",
						["<c-l>"] = "<cmd>lua require('windex').switch_window('left')<cr>",
						["gl"] = "IncreaseAllDetail",
						["g;"] = "DecreaseAllDetail",
						["{"] = "DecreaseWidth",
						["}"] = "IncreaseWidth",
						["["] = "PrevTask",
						["]"] = "NextTask",
					},
				},
				component_aliases = {
					default = {
						{ "display_duration", detail_level = 2 },
						"on_output_summarize",
						"on_exit_set_status",
						{ "on_complete_notify", system = "unfocused" },
						"on_complete_dispose",
					},
					default_neotest = {
						"on_output_summarize",
						"on_exit_set_status",
						{ "on_complete_notify", system = "unfocused" },
						"on_complete_dispose",
						"unique",
						"display_duration",
					},
					always_restart = { "on_complete_restart", statuses = { STATUS.FAILURE, STATUS.SUCCESS } },
				},
				template_timeout = 5000,
				template_cache_threshold = 0,
				actions = {
					["set loclist diagnostics"] = false,
					["set as recive terminal"] = {
						desc = "set this task as the terminal to recive sent text and commands",
						run = function(task)
							SendID = task.strategy.chan_id
						end,
					},
					["keep runnning"] = {
						desc = "restart the task even if it succeeds",
						run = function(task)
							task:add_components({
								{ "on_complete_restart", statuses = { STATUS.FAILURE, STATUS.SUCCESS } },
							})
							if task.status == STATUS.FAILURE or task.status == STATUS.SUCCESS then
								task:restart()
							end
						end,
					},
					["unwatch"] = {
						desc = "stop from running on finish or file watch",
						run = function(task)
							for _, component in pairs({ "on_complete_restart", "on_complete_restart" }) do
								if task:has_component(component) then
									task:remove_components({ component })
								end
							end
						end,
						condition = function(task)
							return task:has_component("on_complete_restart") or task:has_component("restart_on_save")
						end,
					},
					["dump task"] = {
						desc = "save task table to DumpTask (for debugging)",
						run = function(task)
							DumpTask = task
						end,
					},
					["open here"] = {
						desc = "open as bottom pannel",
						condition = function(task)
							local bufnr = task:get_bufnr()
							return bufnr and vim.api.nvim_buf_is_valid(bufnr)
						end,
						run = function(task)
							vim.cmd([[normal! m']])
							close_task(task.strategy.bufnr)
							vim.bo[task.strategy.bufnr].filetype = "OverseerTask"
							vim.api.nvim_win_set_buf(0, task:get_bufnr())
							vim.wo.statuscolumn = "%s"
							util.scroll_to_end(0)
						end,
					},
					["open"] = {
						desc = "open as bottom pannel",
						condition = function(task)
							local bufnr = task:get_bufnr()
							return bufnr and vim.api.nvim_buf_is_valid(bufnr)
						end,
						run = function(task)
							vim.notify("Runner: opening task")
							vim.cmd([[normal! m']])
							close_task(task.strategy.bufnr)
							vim.bo[task.strategy.bufnr].filetype = "OverseerPanelTask"
							vim.cmd.vsplit()
							vim.api.nvim_win_set_buf(0, task:get_bufnr())
							util.scroll_to_end(0)
						end,
					},
				},
			}
		end,
		init = function()
			-- This command restarts the most recent Overseer task
			vim.api.nvim_create_user_command("OverseerRestartLast", function()
				local overseer = require("overseer")
				local tasks = overseer.list_tasks({ recent_first = true })
				if vim.tbl_isempty(tasks) then
					vim.notify("No tasks found", vim.log.levels.WARN)
				else
					overseer.run_action(tasks[1], "restart")
				end
			end, {})

			-- The main :Make command from vim-dispatch can be mimicked fairly easily
			-- vim.api.nvim_create_user_command("Make", function(params)
			--   local task = require("overseer").new_task({
			--     cmd = vim.split(vim.o.makeprg, "%s+"),
			--     args = params.fargs,
			--     components = {
			--       { "on_output_quickfix", open = not params.bang, open_height = 8 },
			--       "default",
			--     },
			--   })
			--   task:start()
			-- end, { desc = "", nargs = "*", bang = true })
		end,
		-- config = function(_, opts)
		--   require("overseer").setup(opts)
		--   local has_dap = pcall(require, "dap")
		--   if has_dap then
		--     require("dap.ext.vscode").json_decode = require("overseer.util").decode_json
		--   end
		-- end,
	},
}
