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
            -- Special handling for gopls to use global installation if Mason version not available
            if server_name == "gopls" then
              local mason_gopls = vim.fn.stdpath("data") .. "/mason/bin/gopls"
              if vim.fn.executable(mason_gopls) == 0 then
                -- Mason's gopls not available, use global
                local global_gopls = vim.fn.expand("~/go/bin/gopls")
                if vim.fn.executable(global_gopls) == 1 then
                  opts.cmd = { global_gopls }
                else
                  -- No gopls available, skip setup
                  return
                end
              end
              opts.settings = {
                gopls = {
                  analyses = {
                    unusedparams = true,
                  },
                  staticcheck = true,
                  gofumpt = true,
                },
              }
            end
            -- Use pcall to safely access lspconfig servers
            local ok, err = pcall(function()
              lspconfig[server_name].setup(opts)
            end)
            if not ok and server_name == "gopls" then
              vim.notify("Failed to setup gopls: " .. tostring(err), vim.log.levels.ERROR)
            end
          end,
        },
      })
    end,
  },
}
