local cmd = vim.api.nvim_create_autocmd
local grp = vim.api.nvim_create_augroup

grp('Shape', {})
grp('FileReload', {})
grp('Lsp', {})
grp('Buffer', {})

cmd({ 'CursorHold' }, {
	desc = 'Open float when there is diagnostics',
	callback = vim.diagnostic.open_float,
	group = 'Lsp',
})

cmd({ 'VimLeave' }, {
	desc = 'Change cursor shape to line when leaving nvim',
	command = [[set guicursor=a:ver90]],
	group = 'Shape',
})

cmd({
	'FileChangedShellPost',
}, {
	desc = 'Actions when the file is changed outside of neovim',
	group = 'FileReload',
	callback = function()
		vim.notify('File changed, reloading buffer', vim.log.levels.ERROR)
	end,
})

cmd({ 'BufWinEnter', 'BufRead', 'BufNewFile' }, {
	command = [[setlocal formatoptions-=o]],
	group = 'Buffer',
})

cmd({ 'TextYankPost' }, {
	desc = 'Highlight while yanking',
	group = 'Buffer',
	callback = function()
		vim.highlight.on_yank({ higroup = 'Visual' })
	end,
})
