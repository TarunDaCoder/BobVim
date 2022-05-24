local status_ok, gitsigns = pcall(require, 'gitsigns')
if not status_ok then
	return
end

gitsigns.setup({
	signcolumn = true,
	numhl = true,
	current_line_blame = true,
	preview_config = {
		border = 'single',
		style = 'minimal',
	},
})
