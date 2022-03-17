require('nvim-tree').setup({
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = true,
  ignore_ft_on_setup = {'dashboard'},
  auto_close = 1,
  auto_open = 1,
  update_to_buf_dir   = {
    enable = true,
    auto_open = true,
  },
  open_on_tab = false,
    hijack_cursor = true,
    update_cwd = true,
    update_focused_file = {enable = true, update_cwd = true, ignore_list = {}},
    system_open = {
        -- the command to run this, leaving nil should work in most cases
        cmd = nil,
        -- the command arguments as a list
        args = {}
    },
  view = {
    width = 25,
--    hide_root_folder = true,
    side = 'left',
    auto_resize = true,
    mappings = { custom_only = false, list = {}}
  },
  git = {
    ignore = 1
  }
})
-- vim.g.nvim_tree_ignore = {'*.tmp', '.git'}
--vim.g.nvim_tree_gitignore = 1 
-- vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_indent_markers = 1

vim.cmd('nnoremap <space>e :NvimTreeToggle<CR>')
