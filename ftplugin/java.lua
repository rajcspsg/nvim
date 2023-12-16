local status, jdtls = pcall(require, "jdtls")
if not status then
	return
end
local api = vim.api
local home = os.getenv("HOME")

local root_markers = { "gradlew", "mvnw", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)

jdtls.jol_path = os.getenv("HOME") .. "/tools/jol.jar"

local workspace_folder = home .. "/.cache/jdtls/workspace" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
local jar_patterns = {
	"/tools/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
	"/tools/vscode-java-decompiler/server/*.jar",
	"/tools/vscode-java-test/java-extension/com.microsoft.java.test.plugin/target/*.jar",
	"/tools/vscode-java-test/java-extension/com.microsoft.java.test.runner/target/*.jar",
	"/tools/vscode-java-test/java-extension/com.microsoft.java.test.runner/lib/*.jar",
}
local plugin_path =
	"/tools/vscode-java-test/java-extension/com.microsoft.java.test.plugin.site/target/repository/plugins/"

local bundle_list = vim.tbl_map(function(x)
	return require("jdtls.path").join(plugin_path, x)
end, {
	"junit-jupiter-*.jar",
	"junit-platform-*.jar",
	"junit-vintage-engine_*.jar",
	"org.opentest4j*.jar",
	"org.apiguardian.api_*.jar",
	"org.eclipse.jdt.junit4.runtime_*.jar",
	"org.eclipse.jdt.junit5.runtime_*.jar",
	"org.opentest4j_*.jar",
})
vim.list_extend(jar_patterns, bundle_list)
local bundles = {}
for _, jar_pattern in ipairs(jar_patterns) do
	for _, bundle in ipairs(vim.split(vim.fn.glob(home .. jar_pattern), "\n")) do
		if
			not vim.endswith(bundle, "com.microsoft.java.test.runner-jar-with-dependencies.jar")
			and not vim.endswith(bundle, "com.microsoft.java.test.runner.jar")
		then
			table.insert(bundles, bundle)
		end
	end
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
-- extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
extendedClientCapabilities.onCompletionItemSelectedCommand = "editor.action.triggerParameterHints"

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local on_attach = function(client, bufnr)
	local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
	if status_ok then
		jdtls_dap.setup_dap_main_class_configs()
	end

	local _, _ = pcall(vim.lsp.codelens.refresh)
	vim.lsp.codelens.refresh()

	local opts = {
		silent = true,
		buffer = bufnr,
	}

	vim.keymap.set("n", "<leader>0", function()
		if vim.lsp.inlay_hint.is_enabled(bufnr) then
			vim.lsp.inlay_hint.enable(bufnr, false)
		else
			vim.lsp.inlay_hint.enable(bufnr, true)
		end
	end, opts)

	vim.keymap.set("n", "<C-o>", jdtls.organize_imports, {
		desc = "Organize imports",
		buffer = bufnr,
	})

	vim.keymap.set("n", "<leader>df", jdtls.test_class, opts)

	vim.keymap.set("n", "<leader>dn", jdtls.test_nearest_method, opts)

	vim.keymap.set("n", "<leader>rv", jdtls.extract_variable_all, {
		desc = "Extract variable",
		buffer = bufnr,
	})

	vim.keymap.set("v", "<leader>rm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], {
		desc = "Extract method",
		buffer = bufnr,
	})

	vim.keymap.set("n", "<leader>rc", jdtls.extract_constant, {
		desc = "Extract constant",
		buffer = bufnr,
	})

	vim.keymap.set("n", "<leader>ds", function()
		local dap = require("dap")
		if dap.session() then
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.scopes)
		else
			client.request_sync("java/buildWorkspace", false, 5000, bufnr)
			require("jdtls.dap").pick_test()
		end
	end, opts)

	require("jdtls").setup_dap({ hotcodereplace = "auto" })
end
local config = {
	capabilities = capabilities,
	root_dir = root_dir,
	on_attach = on_attach,
	flags = {
		debounce_text_changes = 80,
		allow_incremental_sync = true,
	},
	init_options = {
		bundles = bundles,
	},
	settings = {
		java = {
			maxConcurrentBuilds = 8,
			eclipse = {
				downloadSources = true,
			},
			saveActions = {
				organizeImports = true,
			},
			maven = {
				downloadSources = true,
			},
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
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
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
					"java.util.stream.Collectors.*",
					"org.assertj.core.api.Assertions.*",
				},
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
			},
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
			extendedClientCapabilities = extendedClientCapabilities,
		},
	},
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx4g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. home .. "/tools/jdtls/lombok.jar",
		"-jar",
		vim.fn.glob("/home/jp/tools/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar"),
		"-configuration",
		"/home/jp/tools/jdtls/config_linux/",
		"-data",
		workspace_folder,
	},
}

require("dap.ext.vscode").load_launchjs()

--vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--    pattern = { "*.java" },
--    callback = function()
--        local _, _ = pcall(vim.lsp.codelens.refresh)
--    end,
--})

jdtls.start_or_attach(config)

vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
