--  ____        _   _       _
-- |  _ \  __ _| \ | |_   _(_)_ __ ___
-- | | | |/ _` |  \| \ \ / / | '_ ` _ \
-- | |_| | (_| | |\  |\ V /| | | | | | |
-- |____/ \__,_|_| \_| \_/ |_|_| |_| |_|
-- Author: https://github.com/TarunDaCoder
-- GitHub: https://github.com/TarunDaCoder/DaNvim
-- License: MIT License Copyright (c) 2022 by TarunDaCoder

vim.opt.termguicolors = true -- Set termguicolors

-- General
require("tarun.settings")
require("tarun.plugins")
require("tarun.keymaps")
require("tarun.colourscheme")

-- LSP
require("tarun.lsp")
