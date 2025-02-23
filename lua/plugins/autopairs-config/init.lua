return {
  "windwp/nvim-autopairs",
  config = function()
    require("nvim-autopairs").setup({
      disable_filetype = { "TelescopePrompt", "vim" },
      check_ts = true,
      map_cr = true,
      map_complete = true,
      auto_select = true,
      insert = false,
      map_char = {
        all = "(",
        tex = "{",
      },
    })

    -- If you want insert `(` after select function or method item

    -- add a lisp filetype (wrap my-function), FYI: Hardcoded = { "clojure", "clojurescript", "fennel", "janet" }
    --cmp_autopairs.lisp[#cmp_autopairs.lisp+1] = "racket"
  end,
}
