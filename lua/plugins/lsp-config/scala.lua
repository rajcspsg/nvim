return {
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    ft = { "scala", "sbt", },
    config = function(self, metals_config)
      local ok, metals = pcall(require, 'metals')
      if not ok then
        return
      end

      metals.initialize_or_attach(vim.tbl_deep_extend('force', metals.bare_config(), {
        handlers = {
          ['metals/status'] = function(_, status, ctx)
            vim.lsp.handlers['$/progress'](_, {
              token = 1,
              value = {
                kind = status.show and 'begin' or status.hide and 'end' or 'report',
                message = status.text,
              },
            }, ctx)
          end,
        },
        tvp = {
          icons = {
            enabled = true,
          },
        },
        init_options = {
          statusBarProvider = 'on',
          icons = "unicode",
        },
        settings = {
          showInferredType = true,
          showImplicitArguments = true,
          enableSemanticHighlighting = true,
          defaultBspToBuildTool = true,

        },
      }))

      metals.setup_dap()

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
      vim.lsp.inlay_hint.enable(true)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          metals.initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
      return true
    end,
  },
}
