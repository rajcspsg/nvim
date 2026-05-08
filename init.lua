-- vim.pack native package management
-- Plugins are installed in: ~/.local/share/nvim/site/pack/vendor/start/

-- Disable built-in plugins
vim.g.loaded_gzip = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_zipPlugin = 1

-- Load options and keybindings first
require("keybindings")
require("options")

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
keymap("", " ", "<Nop>", opts)

-- Load bootstrap
for _, source in ipairs({
	"rajnvim.bootstrap",
}) do
	local status_ok, fault = pcall(require, source)
	if not status_ok then
		vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault)
	end
end

-- Load plugin configurations
-- Note: All plugins in ~/.local/share/nvim/site/pack/vendor/start/ are auto-loaded
local plugin_configs = {
	"plugins.completion-config",
	"plugins.lsp-config",
	"plugins.treesitter-config",
	"plugins.telescope-config",
	"plugins.lualine-config",
	"plugins.bufferline-config",
	"plugins.autopairs-config",
	"plugins.git-config",
	"plugins.neotree-config",
	"plugins.dap-config",
	"plugins.conform-config",
	"plugins.testing-config",
	"plugins.iron-config",
	"plugins.repl-config",
	"plugins.mason-lspconfig",
	"plugins.code-runner-config",
	"plugins.jaq-nvim-config",
	"plugins.task-runner-config",
	"plugins.bufterm-config",
	"plugins.close-buffer-config",
	"plugins.astro-ui-config",
	"plugins.devicons",
	"plugins.smooth-cursor-config",
	"plugins.grugfar-config",
	"plugins.snacks-config",
	"plugins.tmux-config",
	"plugins.tinyglimmer-config",
	"plugins.meow-yarn-config",
}

for _, config in ipairs(plugin_configs) do
	local status_ok, mod_or_fault = pcall(require, config)
	if not status_ok then
		vim.api.nvim_err_writeln("Failed to load " .. config .. "\n\n" .. mod_or_fault)
	else
		-- If the module returns a table with a config function, call it
		-- This handles lazy.nvim-style plugin specs
		if type(mod_or_fault) == "table" then
			-- Helper function to evaluate opts and call config
			local function setup_plugin_spec(spec)
				if type(spec.config) == "function" then
					-- Evaluate opts if present
					local opts = nil
					if spec.opts then
						if type(spec.opts) == "function" then
							local opts_ok, opts_result = pcall(spec.opts)
							if opts_ok then
								opts = opts_result
							else
								vim.api.nvim_err_writeln("Failed to evaluate opts for " .. config .. "\n\n" .. tostring(opts_result))
								return
							end
						else
							opts = spec.opts
						end
					end

					-- Call config with the plugin spec and opts
					local config_ok, config_err = pcall(spec.config, spec, opts)
					if not config_ok then
						vim.api.nvim_err_writeln("Failed to run config for " .. config .. "\n\n" .. tostring(config_err))
					end
				end
			end

			-- Handle single spec with config
			if type(mod_or_fault.config) == "function" then
				setup_plugin_spec(mod_or_fault)
			end

			-- Handle array of plugin specs
			for _, spec in ipairs(mod_or_fault) do
				if type(spec) == "table" then
					setup_plugin_spec(spec)
				end
			end
		end
	end
end

-- Setup astrotheme before loading colorscheme
pcall(function()
	require("astrotheme").setup({
		palette = "astrodark",
	})
end)

vim.cmd("colorscheme astrodark") -- " Dark theme (default)
-- vim.g.tokyonight_style = "night"
vim.g.sexp_filetypes = "clojure,scheme,lisp,fennel,janet,racket"
vim.cmd("set nofoldenable")
vim.opt.fillchars = "eob: "
