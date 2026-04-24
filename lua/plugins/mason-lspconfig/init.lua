return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clojure_lsp",
          "gopls",
          "dhall_lsp_server",
          "denols",
          "yamlls",
          "lua_ls",
          "jdtls",
          "zls",
          "vtsls",
          "ts_ls",
          "gradle_ls",
        },
        handlers = {
          function(server_name)
            -- nvim-jdtls / ftplugin/java.lua owns Java; do not register lspconfig.jdtls
            if server_name == "jdtls" then
              return
            end
            local lspconfig = require("lspconfig")
            local opts = { capabilities = capabilities }
            if server_name == "gradle_ls" then
              -- Gradle LS NPEs if initializationOptions is omitted (null)
              opts.initializationOptions = {
                settings = {
                  gradleWrapperEnabled = true,
                },
              }
            end
            -- Use pcall to safely access lspconfig servers
            pcall(function()
              lspconfig[server_name].setup(opts)
            end)
          end,
        },
      })
    end,
  },
}
