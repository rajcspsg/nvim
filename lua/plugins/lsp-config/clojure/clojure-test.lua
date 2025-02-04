return {
	"julienvincent/clojure-test.nvim",
	config = function()
		local clojure_test = require("clojure-test")
		clojure_test.setup({
			-- list of default keybindings
			keys = {
				ui = {
					expand_node = { "l", "<Right>" },
					collapse_node = { "h", "<Left>" },
					go_to = { "<Cr>", "gd" },

					cycle_focus_forwards = "<Tab>",
					cycle_focus_backwards = "<S-Tab>",

					quit = { "q", "<Esc>" },
				},
			},

			hooks = {
				-- This is a hook that will be called with a table of tests that are about to be run. This
				-- can be used as an opportunity to save files and/or reload clojure namespaces.
				--
				-- This combines really well with https://github.com/tonsky/clj-reload
				before_run = function(tests) end,
			},
		})
	end,
}
