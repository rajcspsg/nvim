local wk = require("which-key")

local mappings = {
  q = {":q<cr>", "Quit"},
  Q = {":wq<cr>", "Save and Quit"},
--  w = {":w<cr>", "Save"},
  x = {":bdelete<cr>", "Close"},
--  E = {":e ~/.config/nvim/init.lua<cr>", "Edit Config"},
--  f = {":Telescope find_files<cr>", "Telescope Find Files"},
--  r = {":Telescope live_grep<cr>", "Telescope Live Grep"}
}

local opts = { prefix = '<leader>'}
wk.register(mappings, opts)
