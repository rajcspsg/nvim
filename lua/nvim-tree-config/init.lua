require('nvim-tree').setup({
  auto_close = 1,
  auto_open = 1,
  update_to_buf_dir   = {
    enable = true,
    auto_open = true,
  },
  view = {
    width = 5,
    height = 10,
    hide_root_folder = true,
    side = 'left',
    auto_resize = true
  }
})

vim.g.nvim_tree_gitignore = 1 
-- vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_indent_markers = 1

vim.cmd('nnoremap <space>e :NvimTreeToggle<CR>')
