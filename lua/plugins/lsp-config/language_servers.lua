return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "blink.cmp",
  },
  config = function()
    -- Setup lspconfig.
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

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local lspconfig = require("lspconfig")

    lspconfig.ls_emmet = {
      default_config = {
        cmd = { "ls_emmet", "--stdio" },
        filetypes = { "html", "css", "scss" }, -- Add the languages you use, see language support
        root_dir = function(_)
          return vim.loop.cwd()
        end,
        settings = {},
      },
    }

    local langservers = {
      "clangd",
      "clojure_lsp",
      "cmake",
      "cssls",
      "dhall_lsp_server",
      "elixirls",
      "emmet_ls",
      "gopls",
      "gradle_ls",
      "hls",
      "html",
      "nixd",
      "ocamlls",
      "pylsp",
      "ts_ls",
      "vls",
      "zls",
    }

    for _, server in ipairs(langservers) do
      lspconfig[server].setup({ capabilities = capabilities })
    end

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

    -- Configure ElixirLS as the LSP server for Elixir.
    lspconfig.elixirls.setup({
      -- cmd = { "/opt/homebrew/Cellar/elixir-ls/0.13.0/bin/elixir-ls" },
      cmd = { "elixir-ls" },
      -- on_attach = custom_attach, -- this may be required for extended functionalities of the LSP
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
      elixirLS = {
        dialyzerEnabled = false,
        fetchDeps = false,
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
            vim.lsp.buf.execute_command {
              command = 'ruff.applyAutofix',
              arguments = {
                { uri = vim.uri_from_bufnr(0) },
              },
            }
          end,
          description = 'Ruff: Fix all auto-fixable problems',
        },
        RuffOrganizeImports = {
          function()
            vim.lsp.buf.execute_command {
              command = 'ruff.applyOrganizeImports',
              arguments = {
                { uri = vim.uri_from_bufnr(0) },
              },
            }
          end,
          description = 'Ruff: Format imports',
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

    --[[require("lspconfig").rust_analyzer.setup({
	capabilities = capabilities,
	-- on_attach is a callback called when the language server attachs to the buffer
	-- on_attach = on_attach,
	settings = {
		-- to enable rust-analyzer settings visit:
		-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
		["rust-analyzer"] = {
			-- enable clippy diagnostics on save
			checkOnSave = {
				command = "clippy",
			},
		},
	},
})]]
    --

    local custom_attach = function(client)
      print("LSP Started")
      -- require('completion').on_attach(client)
      -- require('diagnostic').on_attach(client)

      print("attched")
      local ht = require("haskell-tools")
      local bufnr = vim.api.nvim_get_current_buf()
      local opts = { noremap = true, silent = true, buffer = bufnr }
      print("haskell tools keymaps setup")
      -- haskell-language-server relies heavily on codeLenses,
      -- so auto-refresh (see advanced configuration) is enabled by default
      vim.keymap.set("n", "<space>cl", vim.lsp.codelens.run, opts)
      -- Hoogle search for the type signature of the definition under the cursor
      vim.keymap.set("n", "<space>hs", ht.hoogle.hoogle_signature, opts)
      -- Evaluate all code snippets
      vim.keymap.set("n", "<space>ea", ht.lsp.buf_eval_all, opts)
      -- Toggle a GHCi repl for the current package
      vim.keymap.set("n", "<leader>hr", ht.repl.toggle, opts)
      -- Toggle a GHCi repl for the current buffer
      vim.keymap.set("n", "<leader>hf", function()
        ht.repl.toggle(vim.api.nvim_buf_get_name(0))
      end, opts)
      vim.keymap.set("n", "<leader>hq", ht.repl.quit, opts)
    end

    --require("lspconfig").hls.setup({ on_attach = custom_attach })
    --[[ require("lspconfig").hls.setup({
	default_config = {
		cmd = { "haskell-language-server-wrapper", "--lsp" },
		filetypes = { "haskell", "lhaskell" },
		root_dir = function(filepath)
			return (
				require("lspconfig.util").root_pattern("hie.yaml", "stack.yaml", "cabal.project")(filepath)
				or require("lspconfig.util").root_pattern("*.cabal", "package.yaml")(filepath)
			)
		end,
		single_file_support = true,
		settings = {
			haskell = {
				formattingProvider = "ormolu",
				cabalFormattingProvider = "cabalfmt",
			},
		},
		lspinfo = function(cfg)
			local extra = {}
			local function on_stdout(_, data, _)
				local version = data[1]
				table.insert(extra, "version:   " .. version)
			end

			local opts = {
				cwd = cfg.cwd,
				stdout_buffered = true,
				on_stdout = on_stdout,
			}
			local chanid = vim.fn.jobstart({ cfg.cmd[1], "--version" }, opts)
			vim.fn.jobwait({ chanid })
			return extra
		end,
	},

	docs = {
		description = [[
https://github.com/haskell/haskell-language-server

Haskell Language Server

If you are using HLS 1.9.0.0, enable the language server to launch on Cabal files as well:

```lua
require('lspconfig')['hls'].setup{
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
}
```
    ]]
    --[[,

		default_config = {
			root_dir = [[
function (filepath)
  return (
    util.root_pattern('hie.yaml', 'stack.yaml', 'cabal.project')(filepath)
    or util.root_pattern('*.cabal', 'package.yaml')(filepath)
  )
end
     ]]
    --[[],
		},
	},
})
 ]]
    --

    lspconfig.hls.setup({})
    lspconfig.dhall_lsp_server.setup({})

    local cmd = vim.cmd
    -- LSP
    cmd([[augroup lsp]])
    cmd([[autocmd!]])
    cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
    -- If you want a :Format command this is useful
    cmd([[command! Format lua vim.lsp.buf.formatting()]])
  end,
}
