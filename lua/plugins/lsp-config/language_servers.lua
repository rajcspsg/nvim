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

    -- Servers not covered by mason-lspconfig (or installed outside Mason).
    -- clojure_lsp, dhall_lsp_server, zls are set up via mason-lspconfig.
    local langservers = {
      "clangd",
      "cmake",
      "hls",
      "pylsp",
    }

    for _, server in ipairs(langservers) do
      if lspconfig[server] then
        lspconfig[server].setup({ capabilities = capabilities })
      else
        vim.notify("LSP server not found: " .. server, vim.log.levels.WARN)
      end
    end

    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      cmd = { "typescript-language-server", "--stdio" },
      root_markers = { "package.json" },
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
    })

    lspconfig.denols.setup({
      capabilities = capabilities,
      cmd = { "deno", "lsp" },
      cmd_env = { NO_COLOR = true },
      root_markers = { "deno.json" },
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
    })

    lspconfig.lua_ls.setup({

      on_init = function(client, _)
        if client.supports_method("textDocument/semanticTokens") then
          client.server_capabilities.semanticTokensProvider = nil
        end
      end,

      capabilities = capabilities,

      settings = {

        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
              [vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types"] = true,
              [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
          },
        },
      },
    })

    lspconfig.pylsp.setup({
      settings = {
        pylsp = {
          plugins = {
            pyflakes = { enabled = false },
            pycodestyle = { enabled = false },
            autopep8 = { enabled = false },
            yapf = { enabled = false },
            mccabe = { enabled = false },
            pylsp_mypy = { enabled = false },
            pylsp_black = { enabled = false },
            pylsp_isort = { enabled = false },
          },
        },
      },
    })

    lspconfig.ruff.setup({
      commands = {
        RuffAutofix = {
          function()
            vim.lsp.buf.execute_command({
              command = "ruff.applyAutofix",
              arguments = {
                { uri = vim.uri_from_bufnr(0) },
              },
            })
          end,
          description = "Ruff: Fix all auto-fixable problems",
        },
        RuffOrganizeImports = {
          function()
            vim.lsp.buf.execute_command({
              command = "ruff.applyOrganizeImports",
              arguments = {
                { uri = vim.uri_from_bufnr(0) },
              },
            })
          end,
          description = "Ruff: Format imports",
        },
      },
    })

    lspconfig.yamlls.setup({
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 200,
      },
      settings = {
        yaml = {
          format = {
            enable = true,
          },
          schemaStore = {
            enable = true,
          },
        },
      },
    })

    lspconfig.gopls.setup({
      capabilities = vim.tbl_deep_extend("force", {}, capabilities, lspconfig.gopls.capabilities or {}),
      settings = {
        gopls = {
          analyses = {
            fieldalignment = false, -- find structs that would use less memory if their fields were sorted
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          experimentalPostfixCompletions = true,
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          gofumpt = true,
          semanticTokens = true,
          -- DISABLED: staticcheck
          --
          -- gopls doesn't invoke the staticcheck binary.
          -- Instead it imports the analyzers directly.
          -- This means it can report on issues the binary can't.
          -- But it's not a good thing (like it initially sounds).
          -- You can't then use line directives to ignore issues.
          --
          -- Instead of using staticcheck via gopls.
          -- We have golangci-lint execute it instead.
          --
          -- For more details:
          -- https://github.com/golang/go/issues/36373#issuecomment-570643870
          -- https://github.com/golangci/golangci-lint/issues/741#issuecomment-1488116634
          --
          -- staticcheck = true,
          usePlaceholders = true,
        },
      },
      on_attach = function(client, bufnr)
        require("lsp-inlayhints").setup({
          inlay_hints = {
            parameter_hints = { prefix = "in: " },
            type_hints = { prefix = "out: " }, --
          },
        })
        require("lsp-inlayhints").on_attach(client, bufnr)
        require("illuminate").on_attach(client)
        if not client.server_capabilities.semanticTokensProvider then
          local semantic = client.config.capabilities.textDocument.semanticTokens
          client.server_capabilities.semanticTokensProvider = {
            full = true,
            legend = {
              tokenTypes = semantic.tokenTypes,
              tokenModifiers = semantic.tokenModifiers,
            },
            range = true,
          }
        end
      end,
    })


    local cmd = vim.cmd
    -- LSP
    cmd([[augroup lsp]])
    cmd([[autocmd!]])
    cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
    -- If you want a :Format command this is useful
    cmd([[command! Format lua vim.lsp.buf.format({ async = true })]])
  end,
}
