-- Vanilla Neovim treesitter configuration
-- Uses built-in vim.treesitter API instead of the archived nvim-treesitter plugin

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
  "dap_repl",
}

-- Helper function to ensure parsers are installed
-- Parsers can be manually installed via :TSInstall command if needed
-- or by using a package manager to install them
local function ensure_parsers_installed()
  -- Vanilla treesitter parsers are typically included with Neovim
  -- Additional parsers can be installed via Mason or manually
  -- This is a placeholder for any future parser installation logic
end

-- Setup treesitter with vanilla API
local function setup_treesitter()
  -- Enable treesitter-based folding
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

  -- Auto-start treesitter for all buffers
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)

      -- Use treesitter for indenting
      vim.bo[args.buf].indentexpr = "v:lua.vim.treesitter.indentexpr()"
    end,
  })

  ensure_parsers_installed()
end

-- Setup treesitter textobjects using vanilla API
local function setup_textobjects()
  -- Helper to select textobject
  local function select_textobject(query_string)
    local bufnr = vim.api.nvim_get_current_buf()
    local node = vim.treesitter.get_node()
    if not node then return end

    local query = vim.treesitter.query.get(vim.bo.filetype, query_string)
    if not query then return end

    local start_row, start_col, end_row, end_col
    for _, match in query:iter_matches(node:tree():root(), bufnr) do
      for id, matched_node in pairs(match) do
        local name = query.captures[id]
        if name == query_string:match("@(.*)") then
          start_row, start_col, end_row, end_col = matched_node:range()
          break
        end
      end
    end

    if start_row then
      vim.api.nvim_buf_set_mark(bufnr, "<", start_row + 1, start_col, {})
      vim.api.nvim_buf_set_mark(bufnr, ">", end_row + 1, end_col - 1, {})
      vim.cmd("normal! gv")
    end
  end

  -- Helper to move to next/previous textobject
  local function goto_textobject(query_string, forward)
    local bufnr = vim.api.nvim_get_current_buf()
    local node = vim.treesitter.get_node()
    if not node then return end

    local query = vim.treesitter.query.get(vim.bo.filetype, query_string)
    if not query then return end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_row = cursor[1] - 1

    local target_node
    local min_distance = math.huge

    for _, match in query:iter_matches(node:tree():root(), bufnr) do
      for id, matched_node in pairs(match) do
        local start_row = matched_node:range()
        local distance = forward and (start_row - cursor_row) or (cursor_row - start_row)

        if distance > 0 and distance < min_distance then
          min_distance = distance
          target_node = matched_node
        end
      end
    end

    if target_node then
      local row, col = target_node:range()
      vim.api.nvim_win_set_cursor(0, { row + 1, col })
    end
  end

  -- Textobject selection mappings
  vim.keymap.set({ "x", "o" }, "af", function()
    select_textobject("@function.outer")
  end, { desc = "Select outer function" })

  vim.keymap.set({ "x", "o" }, "if", function()
    select_textobject("@function.inner")
  end, { desc = "Select inner function" })

  vim.keymap.set({ "x", "o" }, "aa", function()
    select_textobject("@parameter.outer")
  end, { desc = "Select outer parameter" })

  vim.keymap.set({ "x", "o" }, "ia", function()
    select_textobject("@parameter.inner")
  end, { desc = "Select inner parameter" })

  vim.keymap.set({ "x", "o" }, "ac", function()
    select_textobject("@comment.outer")
  end, { desc = "Select outer comment" })

  vim.keymap.set({ "x", "o" }, "ic", function()
    select_textobject("@comment.inner")
  end, { desc = "Select inner comment" })

  -- Movement mappings
  vim.keymap.set({ "n", "x", "o" }, "]f", function()
    goto_textobject("@function.outer", true)
  end, { desc = "Next function" })

  vim.keymap.set({ "n", "x", "o" }, "[f", function()
    goto_textobject("@function.outer", false)
  end, { desc = "Previous function" })

  vim.keymap.set({ "n", "x", "o" }, "]a", function()
    goto_textobject("@parameter.inner", true)
  end, { desc = "Next parameter" })

  vim.keymap.set({ "n", "x", "o" }, "[a", function()
    goto_textobject("@parameter.inner", false)
  end, { desc = "Previous parameter" })

  vim.keymap.set({ "n", "x", "o" }, "]c", function()
    goto_textobject("@comment.outer", true)
  end, { desc = "Next comment" })

  vim.keymap.set({ "n", "x", "o" }, "[c", function()
    goto_textobject("@comment.outer", false)
  end, { desc = "Previous comment" })
end

-- Initialize vanilla treesitter
setup_treesitter()
setup_textobjects()

return {
  {
    "retran/meow.yarn.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
        require("meow.yarn").setup({
            -- Your custom configuration goes here
        })
    end,
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
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "javascript", "javascriptreact", "typescriptreact" },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
      })
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
