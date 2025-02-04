return {
	{ "crispgm/nvim-go" },
	{
		"leoluz/nvim-dap-go",
		config = function()
			require("dap-go").setup({
				dap_configurations = {
					{
						type = "go",
						name = "Debug (Build Flags)",
						request = "launch",
						program = "${file}",
						buildFlags = require("dap-go").get_build_flags,
					},
					{
						type = "go",
						name = "Debug (Build Flags & Arguments)",
						request = "launch",
						program = "${file}",
						args = require("dap-go").get_arguments,
						buildFlags = require("dap-go").get_build_flags,
					},
				},
			})
		end,
	},
}
