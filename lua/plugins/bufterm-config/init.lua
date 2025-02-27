return {
	"boltlessengineer/bufterm.nvim",
	config = function()
		require("bufterm").setup({
			save_native_terms = true, -- integrate native terminals from `:terminal` command
			start_in_insert = true, -- start terminal in insert mode
			remember_mode = true, -- remember vi_mode of terminal buffer
			enable_ctrl_w = true, -- use <C-w> for window navigating in terminal mode (like vim8)
			terminal = { -- default terminal settings
				buflisted = false, -- whether to set 'buflisted' option
				fallback_on_exit = true, -- prevent auto-closing window on terminal exit
			},
		})
	end,
}
