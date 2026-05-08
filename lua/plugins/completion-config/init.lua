-- LuaSnip configuration
require("luasnip.loaders.from_vscode").lazy_load({
  paths = { vim.fn.stdpath("config") .. "/snippets" },
})

vim.keymap.set("i", "<leader><leader>;", function()
  require("luasnip").jump(1)
end, { desc = "Jump forward a snippet placement", noremap = true, silent = true })

vim.keymap.set("i", "<leader><leader>,", function()
  require("luasnip").jump(-1)
end, { desc = "Jump backward a snippet placement", noremap = true, silent = true })

-- Blink.cmp configuration
return {
  {
    build = function()
      require("blink.cmp").build():wait(60000)
    end,
    config = function()
      local blink_cmp = require("blink.cmp")
      blink_cmp.setup({
        keymap = {
          preset = "super-tab",
          ["<S-k>"] = { "scroll_documentation_up", "fallback" },
          ["<S-j>"] = { "scroll_documentation_down", "fallback" },
        },
        snippets = {
          preset = "luasnip",
          expand = function(snippet)
            require("luasnip").lsp_expand(snippet)
          end,
          active = function(filter)
            if filter and filter.direction then
              return require("luasnip").jumpable(filter.direction)
            end
            return require("luasnip").in_snippet()
          end,
          jump = function(direction)
            require("luasnip").jump(direction)
          end,
        },
        sources = {
          default = {
            "lsp",
            "path",
            "snippets",
            "buffer",
          },
          providers = {},
        },
        completion = {
          trigger = {
            show_on_trigger_character = true,
            show_on_insert_on_trigger_character = true,
            show_on_x_blocked_trigger_characters = { "'", '"', "(", "{" },
          },
          menu = {
            border = "rounded",
            draw = {
              columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
              treesitter = {},
            },
          },
          accept = {
            auto_brackets = { enabled = true },
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            treesitter_highlighting = true,
            window = {
              border = "rounded",
            },
          },
          ghost_text = {
            enabled = false,
          },
        },
        signature = {
          enabled = true,
          window = {
            border = "rounded",
          },
        },
        appearance = {
          kind_icons = {
            Copilot = "",
            Text = "󰉿",
            Method = "󰊕",
            Function = "󰊕",
            Constructor = "󰒓",
            Field = "󰜢",
            Variable = "󰆦",
            Property = "󰖷",
            Class = "󱡠",
            Interface = "󱡠",
            Struct = "󱡠",
            Module = "󰅩",
            Unit = "󰪚",
            Value = "󰦨",
            Enum = "󰦨",
            EnumMember = "󰦨",
            Keyword = "󰻾",
            Constant = "󰏿",
            Snippet = "󱄽",
            Color = "󰏘",
            File = "󰈔",
            Reference = "󰬲",
            Folder = "󰉋",
            Event = "󱐋",
            Operator = "󰪚",
            TypeParameter = "󰬛",
          },
        },
      })

      -- Setup blink.compat
      require("blink.compat").setup({ impersonate_nvim_cmp = true })
    end,
  },
}
