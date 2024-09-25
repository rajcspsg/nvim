local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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
require("plugins")
require("options")
require("astro-ui-config")
require("bufferline-config")
require("galaxyline-config")
require("conform-config")
require("treesitter-config")
require("autopairs-config")
--require("whichkey-config")
require("telescope-config")
require("colorizer-config")
require("lsp")
require("mason-lspconfig")
require("jaq-nvim-config")
require("code-runner-config")
require("devicons")
require("git-config")
vim.cmd("colorscheme astrodark") -- " Dark theme (default)
-- vim.g.tokyonight_style = "night"
vim.g.sexp_filetypes = "clojure,scheme,lisp,fennel,janet,racket"
vim.cmd("set nofoldenable")
vim.opt.fillchars = "eob: "
