--  ____        _  __     ___
-- | __ )  ___ | |_\ \   / (_)_ __ ___
-- |  _ \ / _ \| '_ \ \ / /| | '_ ` _ \
-- | |_) | (_) | |_) \ V / | | | | | | |
-- |____/ \___/|_.__/ \_/  |_|_| |_| |_|
-- Author: https://github.com/TarunDaCoder
-- GitHub: https://github.com/TarunDaCoder/BobVim
-- License: MIT License Copyright (c) 2022 by TarunDaCoder

vim.defer_fn(function()
	-- LSP
	require('tarun.lsp.lsp')
	require('tarun.lsp.null-ls')
	require('tarun.lsp.lspkind')
	require('tarun.lsp.trouble')

	-- General
	require('tarun.general.settings')
	require('tarun.general.plugins')
	require('tarun.general.keymaps')
	require('tarun.general.autocmds')

	-- Plugins
	require('tarun.configs.comment')
	require('tarun.configs.themer')
	require('tarun.configs.telescope')
	require('tarun.configs.bufferline')
	require('tarun.configs.cmp')
	require('tarun.configs.nvim_tree')
	require('tarun.configs.autopairs')
	require('tarun.configs.neorg')
	require('tarun.configs.treesitter')
	require('tarun.configs.gitsigns')
	require('tarun.configs.colorizer')
	require('tarun.configs.indentline')
	require('tarun.configs.startup')
	require('tarun.configs.copilot')
	require('tarun.configs.whichkey')
	require('tarun.configs.heirline')
end, 0)

-- Some secret stuff to reduce my strartup time
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_ftplugin = 1
vim.g.did_load_ftplugin = 1

vim.g.loaded_python3_provider = 1
vim.g.loaded_python_provider = 1
vim.g.loaded_ruby_provider = 1
vim.g.loaded_perl_provider = 1
