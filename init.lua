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

require('plugins')
require('options')
require("astro-ui-config")
--require('lualine-config')
--require('bufferline-config')
require('nvim-tree-config')
require('neotree-config')
require('treesitter-config')
require('autopairs-config')
require('whichkey-config')
require('telescope-config')
require('colorizer-config')
require('conjure')
require('lsp')
require('mason-lspconfig')
require('jaq-nvim-config')
require('code-runner-config')
--require('vim-terminator-config')
require('keybindings')
require('devicons')
require('git-config')
vim.cmd('colorscheme astrodark') -- " Dark theme (default)
vim.cmd('set nofoldenable')
-- vim.g.tokyonight_style = "night"
vim.g.sexp_filetypes="clojure,scheme,lisp,fennel,janet,racket"


