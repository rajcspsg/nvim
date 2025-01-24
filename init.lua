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
require("dap-config")
require("treesitter-config")
require("autopairs-config")
--require("whichkey-config")
require("telescope-config")
require("lsp")
require("testing-config")
require("mason-lspconfig")
require("jaq-nvim-config")
require("code-runner-config")
require("devicons")
require("git-config")
require("smooth-cursor-config")
require("close-buffer-config")
vim.cmd("colorscheme astrodark") -- " Dark theme (default)
-- vim.g.tokyonight_style = "night"
vim.g.sexp_filetypes = "clojure,scheme,lisp,fennel,janet,racket"
vim.cmd("set nofoldenable")
vim.opt.fillchars = "eob: "

---@return haskell-tools.Opts
vim.g.haskell_tools = function()
  ---@type haskell-tools.Opts
  local ht_opts = {
    tools = {
      repl = {
        handler = 'toggleterm',
        auto_focus = false,
      },
      codeLens = {
        autoRefresh = false,
      },
      definition = {
        hoogle_signature_fallback = true,
      },
    },
    hls = {
      -- for hls development
      -- cmd = { 'cabal', 'run', 'haskell-language-server' },
      on_attach = function(_, bufnr, ht)
        local desc = function(description)
          local keymap_opts = { noremap = true, silent = true }
          return vim.tbl_extend('keep', keymap_opts, { buffer = bufnr, desc = description })
        end
        vim.keymap.set('n', 'gh', ht.hoogle.hoogle_signature, desc('haskell: [h]oogle signature search'))
        vim.keymap.set('n', '<space>tg', require("telescope").extensions.ht.package_grep,
          desc('haskell: [t]elescope package [g]rep'))
        vim.keymap.set(
          'n',
          '<space>th',
          require('telescope').extensions.ht.package_hsgrep,
          desc('haskell: [t]elescope package grep [h]askell files')
        )
        vim.keymap.set(
          'n',
          '<space>tf',
          require("telescope").extensions.ht.package_files,
          desc('haskell: [t]elescope package [f]iles')
        )
        vim.keymap.set('n', '<space>ea', ht.lsp.buf_eval_all, desc('haskell: [e]valuate [a]ll'))
      end,
      default_settings = {
        haskell = {
          checkProject = false, -- PERF: don't check the entire project on initial load
          formattingProvider = 'stylish-haskell',
          maxCompletions = 30,
          plugin = {
            semanticTokens = {
              globalOn = true,
            },
            rename = {
              config = {
                diff = true, -- (experimental) rename across modules
              },
            },
          },
        },
      },
    },
  }
  return ht_opts
end


require("treesitter-sexp").setup {
  -- Enable/disable
  enabled = true,
  -- Move cursor when applying commands
  set_cursor = true,
  -- Set to false to disable all keymaps
  keymaps = {
    -- Set to false to disable keymap type
    commands = {
      -- Set to false to disable individual keymaps
      swap_prev_elem = "<e",
      swap_next_elem = ">e",
      swap_prev_form = "<f",
      swap_next_form = ">f",
      promote_elem = "<LocalLeader>O",
      promote_form = "<LocalLeader>o",
      splice = "<LocalLeader>@",
      slurp_left = "<(",
      slurp_right = ">)",
      barf_left = ">(",
      barf_right = "<)",
      insert_head = "<I",
      insert_tail = ">I",
    },
    motions = {
      form_start = "(",
      form_end = ")",
      prev_elem = "[e",
      next_elem = "]e",
      prev_elem_end = "[E",
      next_elem_end = "]E",
      prev_top_level = "[[",
      next_top_level = "]]",
    },
    textobjects = {
      inner_elem = "ie",
      outer_elem = "ae",
      inner_form = "if",
      outer_form = "af",
      inner_top_level = "iF",
      outer_top_level = "aF",
    },
  },
}
