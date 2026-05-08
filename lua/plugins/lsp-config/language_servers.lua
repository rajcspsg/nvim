return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "blink.cmp",
  },
  config = function()
    -- Temporarily suppress deprecation warnings from lspconfig
    local original_notify = vim.notify
    local original_deprecate = vim.deprecate

    vim.notify = function(msg, level, opts)
      -- Filter out lspconfig deprecation warnings
      if type(msg) == "string" and msg:match("lspconfig.*deprecated") then
        return
      end
      original_notify(msg, level, opts)
    end

    vim.deprecate = function(name, alternative, version, plugin, backtrace)
      -- Suppress lspconfig deprecation notices
      if plugin == "nvim-lspconfig" or (type(name) == "string" and name:match("lspconfig")) then
        return
      end
      original_deprecate(name, alternative, version, plugin, backtrace)
    end

    -- Setup lspconfig.
    local lspconfig = require("lspconfig")
    local vim_capabilities = vim.lsp.protocol.make_client_capabilities()
    vim_capabilities.textDocument.completion.completionItem = {
      documentationFormat = { "markdown", "plaintext" },
      snippetSupport = true,
      preselectSupport = true,
      insertReplaceSupport = true,
      labelDetailsSupport = true,
      deprecatedSupport = true,
      commitCharactersSupport = true,
      tagSupport = { valueSet = { 1 } },
      resolveSupport = {
        properties = {
          "documentation",
          "detail",
          "additionalTextEdits",
        },
      },
    }
    local capabilities = require("blink.cmp").get_lsp_capabilities(vim_capabilities)

    -- NOTE: All LSP servers are now configured via mason-lspconfig handlers
    -- See: lua/plugins/mason-lspconfig/init.lua
    --
    -- If you need custom settings for specific servers, use mason-lspconfig's
    -- per-server handlers instead of manual setup here.
    --
    -- For reference, servers being managed by mason-lspconfig:
    -- lua_ls, gopls, yamlls, denols, ts_ls, etc.

    -- WORKAROUND: gopls setup before Mason initializes
    -- Mason-lspconfig handlers only run for already-installed servers.
    -- Until Mason installs gopls, we need to set it up manually.
    local global_gopls = vim.fn.expand("~/go/bin/gopls")
    if vim.fn.executable(global_gopls) == 1 then
      -- Access lspconfig properties while notify is suppressed
      local gopls = lspconfig.gopls
      local util = lspconfig.util

      -- Restore notify and deprecate before calling setup (so real errors are shown)
      vim.notify = original_notify
      vim.deprecate = original_deprecate

      gopls.setup({
        capabilities = capabilities,
        cmd = { global_gopls },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })
    else
      -- Restore notify and deprecate even if gopls not found
      vim.notify = original_notify
      vim.deprecate = original_deprecate
    end

    -- Uncomment below if you need to override specific server settings:
    -- require("lspconfig").lua_ls.setup({
    --   capabilities = capabilities,
    --   settings = { ... }
    -- })


    local cmd = vim.cmd
    -- LSP
    cmd([[augroup lsp]])
    cmd([[autocmd!]])
    cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
    -- If you want a :Format command this is useful
    cmd([[command! Format lua vim.lsp.buf.format({ async = true })]])

    -- Ensure notify and deprecate are restored
    vim.notify = original_notify
    vim.deprecate = original_deprecate
  end,
}
