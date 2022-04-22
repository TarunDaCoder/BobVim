local null_ls_status_ok, null_ls = pcall(require, 'null-ls')
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local cmd = vim.api.nvim_create_autocmd
local grp = vim.api.nvim_create_augroup

null_ls.setup({
	debug = false,
	sources = {
		-- JavaScript
		formatting.prettier,
		diagnostics.eslint,

		-- Lua
		formatting.stylua, -- FIX: Fix formatting
		diagnostics.luacheck,
	},
	-- Format on save (laggy) -- FIX: Fix this thing also
	on_attach = function(client)
		if client.resolved_capabilities.document_formatting then
			grp('Lsp', {})
			cmd({ 'BufWritePre' }, {
				pattern = '<buffer>',
				desc = 'Format on save',
				group = 'Lsp',
				command = [[lua vim.lsp.buf.formatting_sync(nil, 2000)]],
			})
		end
	end,
	autostart = true,
})
