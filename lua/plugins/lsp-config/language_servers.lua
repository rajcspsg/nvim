return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "blink.cmp",
  },
  config = function()
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
  end,
}
