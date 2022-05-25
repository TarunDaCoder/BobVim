local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Code from max
local codes = {
	no_matching_function = {
		message = " Can't find a matching function",
		'redundant-parameter',
		'ovl_no_viable_function_in_call',
	},
	empty_block = {
		message = " That shouldn't be empty here",
		'empty-block',
	},
	missing_symbol = {
		message = ' Here should be a symbol',
		'miss-symbol',
	},
	expected_semi_colon = {
		message = ' Please put the `;` or `,`',
		'expected_semi_declaration',
		'miss-sep-in-table',
		'invalid_token_after_toplevel_declarator',
	},
	redefinition = {
		message = ' That variable was defined before',
		'redefinition',
		'redefined-local',
	},
	no_matching_variable = {
		message = " Can't find that variable",
		'undefined-global',
		'reportUndefinedVariable',
	},
	trailing_whitespace = {
		message = ' Whitespaces are useless',
		'trailing-whitespace',
		'trailing-space',
	},
	unused_variable = {
		message = " Don't define variables you don't use",
		'unused-local',
	},
	unused_function = {
		message = " Don't define functions you don't use",
		'unused-function',
	},
	useless_symbols = {
		message = ' Remove that useless symbols',
		'unknown-symbol',
	},
	wrong_type = {
		message = ' Try to use the correct types',
		'init_conversion_failed',
	},
	undeclared_variable = {
		message = ' Have you delcared that variable somewhere?',
		'undeclared_var_use',
	},
	lowercase_global = {
		message = ' Should that be a global? (if so make it uppercase)',
		'lowercase-global',
	},
}

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
	virtual_text = false,
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
		format = function(diagnostic)
      if diagnostic.user_data == nil then
          return diagnostic.message
      elseif vim.tbl_isempty(diagnostic.user_data) then
          return diagnostic.message
      end
			local code = diagnostic.user_data.lsp.code
			for _, table in pairs(codes) do
				if vim.tbl_contains(table, code) then
					return table.message
				end
			end
		end,
	},
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = 'rounded',
})

local on_attach = function(client)
	client.server_capabilities.document_formatting = false
	client.server_capabilities.document_range_formatting = false
end

local lsp_servers = {
	'html',
	'rust_analyzer',
	'cssls',
	'jsonls',
	'tsserver',
	'yamlls',
	'clangd',
	'sumneko_lua',
}
for _, lsp in ipairs(lsp_servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

lspconfig.sumneko_lua.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'vim' },
			},
		},
	},
	on_attach = function(client)
		client.server_capabilities.document_formatting = false
		client.server_capabilities.document_range_formatting = false
	end,
})

lspconfig.tsserver.setup({
	on_attach = function(client)
		client.server_capabilities.document_formatting = false
		client.server_capabilities.document_range_formatting = false
	end,
})

lspconfig.html.setup({
	on_attach = function(client)
		client.server_capabilities.document_formatting = false
		client.server_capabilities.document_range_formatting = false
	end,
})

lspconfig.cssls.setup({
	on_attach = function(client)
		client.server_capabilities.document_formatting = false
		client.server_capabilities.document_range_formatting = false
	end,
})

lspconfig.rust_analyzer.setup({
	on_attach = function(client)
		client.server_capabilities.document_formatting = false
		client.server_capabilities.document_range_formatting = false
	end,
})

lspconfig.jsonls.setup({
	on_attach = function(client)
		client.server_capabilities.document_formatting = false
		client.server_capabilities.document_range_formatting = false
	end,
})

lspconfig.yamlls.setup({
	on_attach = function(client)
		client.server_capabilities.document_formatting = false
		client.server_capabilities.document_range_formatting = false
	end,
})

lspconfig.clangd.setup({
	on_attach = function(client)
		client.server_capabilities.document_formatting = false
		client.server_capabilities.document_range_formatting = false
	end,
})

if not configs.ls_emmet then
	configs.ls_emmet = {
		default_config = {
			cmd = { 'ls_emmet', '--stdio' },
			filetypes = {
				'html',
				'css',
				'scss',
				'javascript',
				'javascriptreact',
				'typescript',
				'typescriptreact',
				'haml',
				'xml',
				'xsl',
				'pug',
				'slim',
				'sass',
				'stylus',
				'less',
				'sss',
				'hbs',
				'handlebars',
			},
			root_dir = function(fname)
				return vim.loop.cwd()
			end,
			settings = {},
		},
	}
end

lspconfig.ls_emmet.setup({ capabilities = capabilities })
