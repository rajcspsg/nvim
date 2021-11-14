require('nvim-autopairs').setup{
   disable_filetype = { "TelescopePrompt" , "vim" },
   check_ts = true,
   map_cr = true,
   map_complete = true,
   auto_select = true,
   insert = false,
   map_char = {
    all = '(',
    tex = '{'
   }
}

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

-- add a lisp filetype (wrap my-function), FYI: Hardcoded = { "clojure", "clojurescript", "fennel", "janet" }
cmp_autopairs.lisp[#cmp_autopairs.lisp+1] = "racket"
