if vim.fn.executable("dhall-lsp-server") ~= 1 then
	return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

---@diagnostic disable-next-line: missing-fields
vim.lsp.start({
	cmd = { "dhall-lsp-server" },
	root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
	capabilities = capabilities,
})
