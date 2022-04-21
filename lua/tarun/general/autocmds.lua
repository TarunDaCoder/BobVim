local cmd = vim.api.nvim_create_autocmd

vim.cmd([[ autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif ]])

vim.cmd([[
      augroup remove_o_formatoption
        autocmd!
        autocmd BufWinEnter,BufRead,BufNewFile * setlocal formatoptions-=o
      augroup END
]])

cmd({ 'CursorHold' }, {
	desc = 'Open float when there is diagnostics',
	callback = vim.diagnostic.open_float,
})

cmd({ 'VimLeave' }, {
	desc = 'Change cursor shape to line when leaving nvim',
	callback = 'vim.opt.guicursor=a:ver90',
})
