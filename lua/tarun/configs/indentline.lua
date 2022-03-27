local status_ok, indentline = pcall(require, 'indent_blankline')
if not status_ok then
	return
end

local g = vim.g

indentline.setup({
	show_current_context = true,
	show_current_context_start = true,
	space_char_blankline = ' ',
})
g.indent_blankline_filetype_exclude = {
	'help',
	'startify',
	'dashboard',
	'packer',
	'NvimTree',
	'Trouble',
	'LspInfo',
	'LspInstallInfo',
}
g.indent_blankline_char = '▏'
g.indent_blankline_show_trailing_blankline_indent = true
g.indent_blankline_show_first_indent_level = true
g.indent_blankline_use_treesitter = true
