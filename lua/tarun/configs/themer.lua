-- require('themer').setup({
-- colorscheme = 'catppuccin',
-- styles = {
-- comment = { style = 'italic' },
-- ['function'] = { style = 'italic' },
-- functionbuiltin = { style = 'italic' },
-- variable = { style = 'italic' },
-- variableBuiltIn = { style = 'italic' },
-- parameter = { style = 'italic' },
-- },
-- })

-- Dawn - Latte, Noon - frappe, storm - macchiato, dusk - moccha

vim.g.catppuccin_flavour = 'macchiato'
vim.cmd([[colorscheme catppuccin]])

local status_ok, ctp = pcall(require, 'catppuccin')
if not status_ok then
	return
end

ctp.setup({
	integrations = {
		lsp_trouble = true,
		indent_blankline = {
			colored_indent_levels = true,
		},
		lightspeed = true,
		ts_rainbow = true,
	},
})
