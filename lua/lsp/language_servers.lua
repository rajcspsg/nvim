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

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim_capabilities)

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
  "elixirls",
  "emmet_ls",
  "golangci_lint_ls",
  "gopls",
  "gradle_ls",
  "hls",
  "html",
  "jdtls",
  "lua_ls",
  "metals",
  "ocamlls",
  "rust-analyzer",
  "pylsp",
  "lua_ls",
  "ts_ls",
  "yamllint",
  "yamlfmt",
  "yaml-language-server",
  "vls",
  "zls",
}

for _, server in ipairs(langservers) do
  require("lspconfig")[server].setup({ capabilities = capabilities })
end

require("lspconfig").lua_ls.setup({

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

-- Configure ElixirLS as the LSP server for Elixir.
require("lspconfig").elixirls.setup({
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

require("lspconfig").yamlls.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = true
  end,
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

require("lspconfig").rust_analyzer.setup({
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
})
local cmd = vim.cmd
-- LSP
cmd([[augroup lsp]])
cmd([[autocmd!]])
cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
-- NOTE: You may or may not want java included here. You will need it if you want basic Java support
-- but it may also conflict if you are using something like nvim-jdtls which also works on a java filetype
-- autocmd.
cmd([[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(metals_config)]])
cmd([[augroup end]])

----------------------------------
-- LSP Setup ---------------------
----------------------------------
metals_config = require("metals").bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  showImplicitConversionsAndClasses = true,
  showInferredType = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

metals_config.init_options.statusBarProvider = "off"

-- *READ THIS*
-- I *highly* recommend setting statusBarProvider to true, however if you do,
-- you *have* to have a setting to display this in your statusline or else
-- you'll not see any messages from metals. There is more info in the help
-- docs about this
-- metals_config.init_options.statusBarProvider = "on"

-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
--local capabilities = vim.lsp.protocol.make_client_capabilities()
metals_config.capabilities = capabilities

-- Debug settings if you're using nvim-dap
local dap = require("dap")
dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "RunOrTest",
    metals = {
      runType = "runOrTestFile",
      --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

metals_config.on_attach = function(client, bufnr)
  require("metals").setup_dap()
end

-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  -- NOTE: You may or may not want java included here. You will need it if you
  -- want basic Java support but it may also conflict if you are using
  -- something like nvim-jdtls which also works on a java filetype autocmd.
  pattern = { "scala", "sbt" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})

-- If you want a :Format command this is useful
cmd([[command! Format lua vim.lsp.buf.formatting()]])
