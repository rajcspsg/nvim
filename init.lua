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
}

for _, config in ipairs(plugin_configs) do
	local status_ok, fault = pcall(require, config)
	if not status_ok then
		vim.api.nvim_err_writeln("Failed to load " .. config .. "\n\n" .. fault)
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
