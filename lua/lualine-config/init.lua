--[=====[require('lualine').setup({
  options = {theme = 'tokyodark', options = {section_separators = '', component_separators = ''}}
})]=====]-- 

local config = require("lualine-config.config")

local M = {}

local function setup()
  local cpn = require("lualine-config.components")
  local theme = require("lualine-config.highlights").custom(config.options)

  require("lualine").setup({
    options = {
      theme = theme,
      icons_enabled = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = { "dashboard", "lazy", "alpha" },
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = true,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        -- winbar = 100,
      },
    },
    sections = {
      lualine_a = { cpn.branch },
      lualine_b = { cpn.diagnostics },
      lualine_c = {},
      lualine_x = { cpn.diff },
      lualine_y = { cpn.position, cpn.filetype },
      lualine_z = { cpn.spaces, cpn.mode },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = {},
  })
end

M.setup = config.setup

M.load = function()
  setup()
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      setup()
    end,
  })
end

return M
