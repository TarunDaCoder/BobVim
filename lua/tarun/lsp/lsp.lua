local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require('lspconfig')
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local signs = {
	{ name = 'DiagnosticSignError', text = '' },
	{ name = 'DiagnosticSignWarn', text = '' },
	{ name = 'DiagnosticSignHint', text = '' },
	{ name = 'DiagnosticSignInfo', text = '' },
}
for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
end

local border = {
	{ '╔', 'FloatBorder' },
	{ '═', 'FloatBorder' },
	{ '╗', 'FloatBorder' },
	{ '║', 'FloatBorder' },
	{ '╝', 'FloatBorder' },
	{ '═', 'FloatBorder' },
	{ '╚', 'FloatBorder' },
	{ '║', 'FloatBorder' },
}

vim.diagnostic.config({
	signs = true,
	underline = true,
	severity_sort = true,
	update_in_insert = true,
	float = {
		focusable = false,
		scope = 'cursor',
		source = true,
		border = border,
		header = { 'Mistakes you made:', 'DiagnosticHeader' },
		prefix = function(diagnostic, i, total)
			local icon, highlight
			if diagnostic.severity == 1 then
				icon = ''
				highlight = 'DiagnosticError'
			elseif diagnostic.severity == 2 then
				icon = ''
				highlight = 'DiagnosticWarn'
			elseif diagnostic.severity == 3 then
				icon = ''
				highlight = 'DiagnosticInfo'
			elseif diagnostic.severity == 4 then
				icon = ''
				highlight = 'DiagnosticHint'
			end
			return i .. '/' .. total .. ' ' .. icon .. '  ', highlight
		end,
	},
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = 'rounded',
})

local on_attach = function(client)
	client.resolved_capabilities.document_formatting = false
	client.resolved_capabilities.document_range_formatting = false
end

local servers = {
	'html',
	'rust_analyzer',
	'cssls',
	'emmet_ls',
	'jsonls',
	'tsserver',
	'yamlls',
	'clangd',
	'sumneko_lua',
}
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end
