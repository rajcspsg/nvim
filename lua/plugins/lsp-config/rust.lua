return {
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
		["rust-analyzer"] = {
			assist = {
				importEnforceGranularity = true,
				importPrefix = "create",
			},
			cargo = {
				allFeatures = true,
				loadOutDirsFromCheck = true,
				runBuildScripts = true,
			},
			checkOnSave = {
				-- default: `cargo check`
				command = "clippy",
				allFeatures = true,
			},
			procMacro = {
				enable = true,
			},
			inlayHints = {
				lifetimeElisionHints = {
					enable = true,
					useParameterNames = true,
				},
			},
		},
	},
}
