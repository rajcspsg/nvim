local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
keymap("", " ", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.localleader = ","

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

for _, source in ipairs({
	"rajnvim.bootstrap",
}) do
	local status_ok, fault = pcall(require, source)
	if not status_ok then
		vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault)
	end
end

require("keybindings")
require("options")

require("lazy").setup("plugins", {
	defaults = { lazy = false },
	install = { colorscheme = { "tokyonight" } },
	checker = { enabled = true },
	concurrency = 10,
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"tarPlugin",
				"tutor",
				"zipPlugin",
			},
		},
	},
	debug = false,
})
--require("astro-ui-config")
--require("bufferline-config")
--require("galaxyline-config")
--require("conform-config")
--require("dap-config")
--require("treesitter-config")
--require("autopairs-config")
--require("whichkey-config")
--require("telescope-config")
--require("lsp")
--require("testing-config")
--require("mason-lspconfig")
--require("jaq-nvim-config")
--require("code-runner-config")
--require("devicons")
--require("git-config")
--require("smooth-cursor-config")
--require("close-buffer-config")
vim.cmd("colorscheme astrodark") -- " Dark theme (default)
-- vim.g.tokyonight_style = "night"
vim.g.sexp_filetypes = "clojure,scheme,lisp,fennel,janet,racket"
vim.cmd("set nofoldenable")
vim.opt.fillchars = "eob: "
