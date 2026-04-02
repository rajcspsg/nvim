-- nvim-treesitter (main branch) uses `vim.treesitter.start()` + this plugin's
-- indentexpr — not `nvim-treesitter.configs`. Textobjects are configured via
-- `nvim-treesitter-textobjects` + explicit keymaps.
-- Upstream README still recommends `lazy = false` for nvim-treesitter; we lazy-load
-- on buffer open below — if anything misbehaves, switch back to `lazy = false`.

local ts_parsers = {
  "lua",
  "python",
  "javascript",
  "typescript",
  "tsx",
  "jsx",
  "clojure",
  "go",
  "haskell",
  "rust",
  "zig",
  "nix",
  "java",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter").setup({})

      vim.schedule(function()
        require("nvim-treesitter").install(ts_parsers)
      end)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start)
          pcall(function()
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end)
        end,
      })

      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      local function map_select(lhs, query)
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(query, "textobjects")
        end)
      end

      map_select("af", "@function.outer")
      map_select("if", "@function.inner")
      map_select("aa", "@parameter.outer")
      map_select("ia", "@parameter.inner")
      map_select("ac", "@comment.outer")
      map_select("ic", "@comment.inner")

      local function map_move(key, fn, query)
        vim.keymap.set({ "n", "x", "o" }, key, function()
          fn(query, "textobjects")
        end)
      end

      map_move("]f", move.goto_next_start, "@function.outer")
      map_move("]a", move.goto_next_start, "@parameter.inner")
      map_move("]c", move.goto_next_start, "@comment.outer")
      map_move("[f", move.goto_previous_start, "@function.outer")
      map_move("[a", move.goto_previous_start, "@parameter.inner")
      map_move("[c", move.goto_previous_start, "@comment.outer")

      vim.keymap.set("n", "<leader>za", function()
        swap.swap_next("@parameter.inner")
      end)
      vim.keymap.set("n", "<leader>zA", function()
        swap.swap_previous("@parameter.inner")
      end)

      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
      -- Vim-style ; / , (same direction / opposite) for textobject moves and f/F/t/T
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    end,
  },

  {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  {
    "bbjornstad/pretty-fold.nvim",
    event = "VeryLazy",
    config = function()
      require("pretty-fold").setup()
    end,
  },

  {
    "anuvyklack/fold-preview.nvim",
    dependencies = { "anuvyklack/keymap-amend.nvim" },
    event = "VeryLazy",
    config = function()
      require("fold-preview").setup({})
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("treesitter-context").setup({
        ensure_installed = {
          "clojure",
          "lua",
          "javascript",
          "typescript",
          "python",
          "go",
          "jsx",
          "tsx",
          "haskell",
          "java",
          "zig",
          "rust",
          "nix",
        },
        enable = false,
        max_lines = 1,
        line_numbers = true,
        trim_scope = "outer",
        mode = "cursor",
        zindex = 20,
      })
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "javascript", "javascriptreact", "typescriptreact" },
    config = true,
  },

  {
    "RRethy/nvim-treesitter-endwise",
    event = "InsertEnter",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  {
    "ldelossa/litee.nvim",
    event = "VeryLazy",
    opts = {
      notify = { enabled = false },
      panel = { orientation = "bottom", panel_size = 10 },
    },
    config = function(_, opts)
      require("litee.lib").setup(opts)
    end,
  },
  {
    "ldelossa/litee-calltree.nvim",
    event = "VeryLazy",
    dependencies = "ldelossa/litee.nvim",
    opts = { on_open = "panel", map_resize_keys = false },
    config = function(_, opts)
      require("litee.calltree").setup(opts)
    end,
  },

  {
    "Wansmer/treesj",
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("configs.treesj")
    end,
  },

  {
    "aaronik/treewalker.nvim",
    opts = { highlight = true, highlight_duration = 250, highlight_group = "CursorLine" },
  },

  {
    "maxbol/treesorter.nvim",
    cmd = "TSort",
    config = function()
      require("treesorter").setup()
    end,
  },

  {
    "bassamsdata/namu.nvim",
    config = function()
      require("namu").setup({ namu_symbols = { enable = true } })
      vim.keymap.set("n", "<leader>ss", ":Namu symbols<cr>", { desc = "Jump to LSP symbol", silent = true })
      vim.keymap.set("n", "<leader>th", ":Namu colorscheme<cr>", { desc = "Colorscheme Picker", silent = true })
    end,
  },
}
