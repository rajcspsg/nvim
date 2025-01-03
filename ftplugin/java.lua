local M = {}
local root_markers = { "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" }
local root_dir = require("jdtls.setup").find_root(root_markers)
local home = os.getenv("HOME")

local workspace_folder = home .. "/Coding/java" .. "/workspace" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local system_os = ""

-- Determine OS
if vim.fn.has("mac") == 1 then
	system_os = "mac"
elseif vim.fn.has("unix") == 1 then
	system_os = "linux"
elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
	system_os = "win"
else
	print("OS not found, defaulting to 'linux'")
	system_os = "linux"
end

-- Needed for debugging
local bundles = {
	vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"),
}

-- Needed for running/debugging unit tests
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-test/*.jar", true), "\n"))

local extendedClientCapabilities = require("jdtls").extendedClientCapabilities

extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
local java_cmds = vim.api.nvim_create_augroup("java_cmds", { clear = true })
local runtimes = {
	{
		name = "JavaSE-11",
		path = home .. "/.sdkman/candidates/java/11.0.7-amzn/",
	},
	{
		name = "JavaSE-23",
		path = home .. "/.sdkman/candidates/java/23.0.1.fx-zulu/",
	},
	{
		name = "JavaSE-21",
		path = home .. "/.sdkman/candidates/java/21.0.4-tem/",
	},
}

local lsp_settings = {
	["java.format.settings.url"] = home .. "/.config/nvim/language-servers/java-google-formatter.xml",
	["java.format.settings.profile"] = "GoogleStyle",
	java = {
		eclipse = {
			downloadSources = true,
		},

		configuration = {
			updateBuildConfiguration = "interactive",
			runtimes = runtimes,
		},
		maven = {
			downloadSources = true,
		},
		implementationsCodeLens = {
			enabled = true,
		},
		referencesCodeLens = {
			enabled = true,
		},
		references = {
			includeDecompiledSources = true,
		},
		inlayHints = {
			parameterNames = {
				enabled = "all", -- literals, all, none
			},
		},
		format = {
			enabled = true,
			-- Formatting works by default, but you can refer to a specific file/URL if you choose
			--[[settings = {
				url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml",
				profile = "GoogleStyle",
			},]]
			--
		},
		signatureHelp = {
			enabled = true,
		},
		completion = {
			favoriteStaticMembers = {
				"org.hamcrest.MatcherAssert.assertThat",
				"org.hamcrest.Matchers.*",
				"org.hamcrest.CoreMatchers.*",
				"org.junit.jupiter.api.Assertions.*",
				"java.util.Objects.requireNonNull",
				"java.util.Objects.requireNonNullElse",
				"org.mockito.Mockito.*",
			},
			filteredTypes = {
				"com.sun.*",
				"io.micrometer.shaded.*",
				"java.awt.*",
				"jdk.*",
				"sun.*",
			},
			importOrder = {
				"java",
				"javax",
				"com",
				"org",
			},
			guessMethodArguments = true,
		},
		contentProvider = {
			preferred = "fernflower",
		},
		extendedClientCapabilities = extendedClientCapabilities,
		sources = {
			organizeImports = {
				starThreshold = 9999,
				staticStarThreshold = 9999,
			},
		},
		codeGeneration = {
			toString = {
				template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
			},
			hashCodeEquals = {
				useJava7Objects = true,
			},
			useBlocks = true,
		},
	},
}

local function enable_codelens(bufnr)
	pcall(vim.lsp.codelens.refresh)

	vim.api.nvim_create_autocmd("BufWritePost", {
		buffer = bufnr,
		group = java_cmds,
		desc = "refresh codelens",
		callback = function()
			pcall(vim.lsp.codelens.refresh)
		end,
	})
end

function M.setup()
	local on_attach = function(client, bufnr)
		require("jdtls.setup").add_commands()
		require("jdtls").setup_dap()
		require("jdtls.dap").setup_dap_main_class_configs()
		require("lsp-status").register_progress()
		enable_codelens(bufnr)
		require("compe").setup({
			enabled = true,
			autocomplete = true,
			debug = false,
			min_length = 1,
			preselect = "enable",
			throttle_time = 80,
			source_timeout = 200,
			incomplete_delay = 400,
			max_abbr_width = 100,
			max_kind_width = 100,
			max_menu_width = 100,
			documentation = true,

			source = {
				path = true,
				buffer = true,
				calc = true,
				vsnip = false,
				nvim_lsp = true,
				nvim_lua = true,
				spell = true,
				tags = true,
				snippets_nvim = false,
				treesitter = true,
			},
		})

		require("lspkind").init()
		require("lspsaga").init_lsp_saga()

		-- Kommentary
		vim.api.nvim_set_keymap("n", "<leader>/", "<plug>kommentary_line_default", {})
		vim.api.nvim_set_keymap("v", "<leader>/", "<plug>kommentary_visual_default", {})

		require("formatter").setup({
			filetype = {
				java = {
					function()
						return {
							exe = "java",
							args = {
								"-jar",
								os.getenv("HOME") .. "/.local/jars/google-java-format.jar",
								vim.api.nvim_buf_get_name(0),
							},
							stdin = true,
						}
					end,
				},
			},
		})

		vim.api.nvim_exec(
			[[
        augroup FormatAutogroup
          autocmd!
          autocmd BufWritePost *.java FormatWrite
        augroup end
      ]],
			true
		)

		local function buf_set_keymap(...)
			vim.api.nvim_buf_set_keymap(bufnr, ...)
		end
		local function buf_set_option(...)
			vim.api.nvim_buf_set_option(bufnr, ...)
		end

		buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

		-- Mappings.
		local opts = { noremap = true, silent = true }
		buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
		buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
		buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
		buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
		buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
		buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
		buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
		buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
		buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
		buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
		buf_set_keymap("n", "gr", '<cmd>lua vim.lsp.buf.references() && vim.cmd("copen")<CR>', opts)
		buf_set_keymap("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
		buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
		buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
		buf_set_keymap("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
		-- Java specific
		buf_set_keymap("n", "<leader>di", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
		buf_set_keymap("n", "<leader>dt", "<Cmd>lua require'jdtls'.test_class()<CR>", opts)
		buf_set_keymap("n", "<leader>dn", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", opts)
		buf_set_keymap("v", "<leader>de", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
		buf_set_keymap("n", "<leader>de", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
		buf_set_keymap("v", "<leader>dm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)

		buf_set_keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

		vim.api.nvim_exec(
			[[
          hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
          hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
          hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
          augroup lsp_document_highlight
            autocmd!
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
      ]],
			false
		)
	end

	local capabilities = {
		workspace = {
			configuration = true,
		},
		textDocument = {
			completion = {
				completionItem = {
					snippetSupport = true,
				},
			},
		},
	}

	local nvim_cmp_lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

	local config = {

		cmd = { "java-lsp", workspace_folder },

		on_init = function(client, _)
			client.notify("workspace/didChangeConfiguration", { settings = config.settings })
		end,

		init_options = {
			bundles = bundles,
			extendedClientCapabilities = extendedClientCapabilities,
		},

		root_dir = root_dir,
		flags = {
			allow_incremental_sync = true,
		},
		settings = lsp_settings,
		capabilities = capabilities,
		on_attach = on_attach,
	}

	-- Needed for debugging
	config["on_attach"] = function(client, bufnr)
		require("jdtls").setup_dap({ hotcodereplace = "auto" })
		require("jdtls.dap").setup_dap_main_class_configs()
	end

	-- UI
	local finders = require("telescope.finders")
	local sorters = require("telescope.sorters")
	local actions = require("telescope.actions")
	local pickers = require("telescope.pickers")
	require("jdtls.ui").pick_one_async = function(items, prompt, label_fn, cb)
		local opts = {}
		pickers
			.new(opts, {
				prompt_title = prompt,
				finder = finders.new_table({
					results = items,
					entry_maker = function(entry)
						return {
							value = entry,
							display = label_fn(entry),
							ordinal = label_fn(entry),
						}
					end,
				}),
				sorter = sorters.get_generic_fuzzy_sorter(),
				attach_mappings = function(prompt_bufnr)
					actions.goto_file_selection_edit:replace(function()
						local selection = actions.get_selected_entry(prompt_bufnr)
						actions.close(prompt_bufnr)

						cb(selection.value)
					end)

					return true
				end,
			})
			:find()
	end

	-- Server
	require("jdtls").start_or_attach(config)
end

return M
