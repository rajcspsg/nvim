vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.sexp_filetypes = "clojure,scheme,lisp,racket,fennel,janet"
local map = vim.keymap.set

map("n", "<C-h>", "<C-w>h", { noremap = true, silent = false })
map("n", "<C-l>", "<C-w>l", { noremap = true, silent = false })
map("n", "<C-j>", "<C-w>j", { noremap = true, silent = false })
map("n", "<C-k>", "<C-w>k", { noremap = true, silent = false })

-- map('i', 'jk', '<ESC>', {noremap = true, silent = false})
-- map('i', 'kj', '<ESC>', {noremap = true, silent = false})

--map('n', '<leader>e', ':NvimTreeToggle<CR>', {noremap = true, silent = true })

map("v", "<", "<gv", { noremap = true, silent = false })
map("v", ">", ">gv", { noremap = true, silent = false })

-- NeoTree
vim.keymap.set("n", "<C-e>", "<Cmd>Neotree toggle<CR>")
-- LSP
map("n", "gD", "<cmd>lua vim.lsp.buf.definition()<CR>", {})
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", {})
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", {})
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", {})
map("n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", {})
map("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", {})
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", {})
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", {})
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", {})
map("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>', {})
map("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]], {}) -- all workspace diagnostics
map("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]], {}) -- all workspace errors
map("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]], {}) -- all workspace warnings
map("n", "<leader>d", "<cmd>lua vim.diagnostic.setloclist()<CR>", {}) -- buffer diagnostics only
map("n", "[c", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>", {})
map("n", "]c", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>", {})

-- Example mappings for usage with nvim-dap. If you don't use that, you can
-- skip these
map("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]], {})
map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]], {})
map("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]], {})
map("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]], {})
map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]], {})
map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]], {})
map("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]], {})
-- Vimspector
vim.cmd([[
nmap <F9> <cmd>call vimspector#Launch()<cr>
nmap <F5> <cmd>call vimspector#StepOver()<cr>
nmap <F8> <cmd>call vimspector#Reset()<cr>
nmap <F11> <cmd>call vimspector#StepOver()<cr>")
nmap <F12> <cmd>call vimspector#StepOut()<cr>")
nmap <F10> <cmd>call vimspector#StepInto()<cr>")
]])
map("n", "Db", ":call vimspector#ToggleBreakpoint()<cr>", {})
map("n", "Dw", ":call vimspector#AddWatch()<cr>", {})
map("n", "De", ":call vimspector#Evaluate()<cr>", {})
map("n", "<leader>ft", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=2 fish <CR> ", {})
map("n", "t", ":FloatermToggle myfloat<CR>", {})
map("t", "<Esc>", "<C-\\><C-n>:q<CR>", {})

map("n", "<leader>R", ":RunCode<CR>", { noremap = true, silent = false })
map("n", "<leader>Rf", ":RunFile<CR>", { noremap = true, silent = false })
map("n", "<leader>Rft", ":RunFile tab<CR>", { noremap = true, silent = false })
map("n", "<leader>Rp", ":RunProject<CR>", { noremap = true, silent = false })
map("n", "<leader>Rc", ":RunClose<CR>", { noremap = true, silent = false })
map("n", "<leader>Crf", ":CRFiletype<CR>", { noremap = true, silent = false })
map("n", "<leader>Crp", ":CRProjects<CR>", { noremap = true, silent = false })

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		local params = vim.lsp.util.make_range_params()
		params.context = { only = { "source.organizeImports" } }
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
		for _, res in pairs(result or {}) do
			for _, action in pairs(res.result or {}) do
				if action.edit then
					vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
				end
			end
		end
	end,
})
