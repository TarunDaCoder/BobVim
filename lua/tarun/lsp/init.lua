local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require('tarun.lsp.lsp-installer')
require('tarun.lsp.handlers').setup()
require('tarun.lsp.null-ls')
