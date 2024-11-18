local g = vim.g

g.rustaceanvim = function()
  ---@type rustaceanvim.Opts
  local rustacean_opts = {
    tools = {
      executor = 'toggleterm',
    },
    server = {
      default_settings = {
        ['rust-analyzer'] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            runBuildScripts = true,
          },
          procMacro = {
            enable = true,
            ignored = {
              ['async-trait'] = { 'async_trait' },
              ['napi-derive'] = { 'napi' },
              ['async-recursion'] = { 'async_recursion' },
            },
          },
          inlayHints = {
            lifetimeElisionHints = {
              enable = true,
              useParameterNames = true,
            },
          },
        },
      },
    },
  }
  return rustacean_opts
end

--[[
 local rt = {
  server = {
    settings = {
      on_attach = function(_, bufnr)
        -- Hover actions
        vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
        -- Code action groups
        vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
        require 'illuminate'.on_attach(client)
      end,
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy"
        },
      },
    }
  },
}
require('rust-tools').setup(rt)

]] --
