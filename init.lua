--  ____        _   _       _
-- |  _ \  __ _| \ | |_   _(_)_ __ ___
-- | | | |/ _` |  \| \ \ / / | '_ ` _ \
-- | |_| | (_| | |\  |\ V /| | | | | | |
-- |____/ \__,_|_| \_| \_/ |_|_| |_| |_|
-- Author: https://github.com/TarunDaCoder
-- GitHub: https://github.com/TarunDaCoder/DaNvim
-- License: MIT License Copyright (c) 2022 by TarunDaCoder

-- General
require("tarun.settings")
require("tarun.plugins")
require("tarun.keymaps")

-- LSP
require("tarun.lsp")
require("tarun.null-ls")

-- Some secret stuff to reduce my strartup time
vim.g.loaded_gzip            = 1
vim.g.loaded_tar             = 1
vim.g.loaded_tarPlugin       = 1
vim.g.loaded_zip             = 1
vim.g.loaded_zipPlugin       = 1
vim.g.loaded_getscript       = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball         = 1
vim.g.loaded_vimballPlugin   = 1
vim.g.loaded_matchit         = 1
vim.g.loaded_matchparen      = 1
vim.g.loaded_2html_plugin    = 1
vim.g.loaded_logiPat         = 1
vim.g.loaded_rrhelper        = 1
vim.g.loaded_netrw           = 1
vim.g.loaded_netrwPlugin     = 1
vim.g.loaded_netrwSettings   = 1
