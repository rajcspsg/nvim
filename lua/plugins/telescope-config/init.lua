return {

  {
    "Marskey/telescope-sg",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-lua/plenary.nvim",
      "Marskey/telescope-sg",
    },
    config = function()
      local actions = require("telescope.actions")
      local default_theme = "dropdown"
      require("telescope").setup({
        pickers = {
          find_files = {
            theme = default_theme,
            previewer = false,
          },
          git_files = {
            theme = default_theme,
            previewer = false,
          },
          builtin = {
            theme = default_theme,
            previewer = false,
          },
          current_buffer_fuzzy_find = {
            previewer = false,
          },
        },
        defaults = {
          layout_config = {
            width = 0.75,
            prompt_position = "top",
            preview_cutoff = 120,
            horizontal = { mirror = false },
            vertical = { mirror = false },
          },
          find_command = {
            "rg",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          prompt_prefix = " ",
          selection_caret = " ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "descending",
          layout_strategy = "horizontal",
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          file_ignore_patterns = {},
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          path_display = {},
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          use_less = false,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default + actions.center,
            },
            n = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_ivy(),
          },
          ast_grep = {
            command = {
              "sg",
              "--json=stream",
            }, -- must have --json=stream
            grep_open_files = false, -- search in opened files
            lang = nil, -- string value, specify language for ast-grep `nil` for default
          },
        },
      })
      local utils = require("telescope.utils")
      local builtin = require("telescope.builtin")
      local project_files = function()
        local _, ret, _ = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" })
        if ret == 0 then
          builtin.git_files()
        else
          builtin.find_files()
        end
      end
      vim.keymap.set("n", "<C-p>", project_files, { desc = "Project Files" })

      vim.keymap.set("n", "<leader>tj", builtin.builtin, { desc = "Telescope builtins" })
      vim.keymap.set("n", "<leader>tf", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Telescope live grep" })
      vim.keymap.set("n", "<leader>th", builtin.help_tags, { desc = "Telescope help tags" })
      vim.keymap.set("n", "<leader>c", function()
        builtin.git_files({ cwd = "~/.config/nvim/" })
      end, { desc = "Open nvim init.lua" })

      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
    end,
  },
  {
    "jmacadie/telescope-hierarchy.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    keys = {
      { -- lazy style key map
        -- Choose your own keys, this works for me
        "<leader>si",
        "<cmd>Telescope hierarchy incoming_calls<cr>",
        desc = "LSP: [S]earch [I]ncoming Calls",
      },
      {
        "<leader>so",
        "<cmd>Telescope hierarchy outgoing_calls<cr>",
        desc = "LSP: [S]earch [O]utgoing Calls",
      },
    },
    opts = {
      -- don't use `defaults = { }` here, do this in the main telescope spec
      extensions = {
        hierarchy = {
          -- telescope-hierarchy.nvim config, see below
        },
        -- no other extensions here, they can have their own spec too
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us. We won't use data, as everything is in it's own namespace (telescope
      -- defaults, as well as each extension).
      require("telescope").setup(opts)
      require("telescope").load_extension("hierarchy")
    end,
  },
  { "debugloop/telescope-undo.nvim" },
  { "nvim-telescope/telescope-symbols.nvim" },
  {
    "luc-tielen/telescope_hoogle",
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if ok then
        telescope.load_extension("hoogle")
      end
    end,
  },
}
