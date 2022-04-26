local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local map = vim.api.nvim_set_keymap

-- local function test(bufnr)
-- 	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
-- end

-- Remap space as leader key
map('', '<Space>', '<Nop>', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Keymap to save file
map('n', '<leader>w', ':w<CR>', opts)

-- Normal mode --
-- Better window navigation
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)

-- Resize with arrows
map('n', '<C-Up>', ':resize +2<CR>', opts)
map('n', '<C-Down>', ':resize -2<CR>', opts)
map('n', '<C-Left>', ':vertical resize -2<CR>', opts)
map('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- Navigate buffers
-- keymap("n", "<S-l>", ":bnext<CR>", opts)
-- keymap("n", "<S-h>", ":bprevious<CR>", opts)
vim.cmd([[
	nnoremap <silent><TAB> :BufferLineCycleNext<CR>
	nnoremap <silent><S-TAB> :BufferLineCyclePrev<CR>
]])

-- Make highlights dissappear
map('n', '<leader>h', ':set hlsearch!<CR>', opts)

-- Format code
map('n', '<leader>f', ':lua vim.lsp.buf.formatting_sync(nil, 2000)<CR>', opts)

-- Insert mode --
-- Quicker escape
map('i', 'jj', '<ESC>', opts)

-- Visual mode --
-- Stay in indent mode
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- Move text up and down
map('v', '<A-j>', ':m .+1<CR>==', opts)
map('v', '<A-k>', ':m .-2<CR>==', opts)
map('v', 'p', '"_dP', opts)

-- Visual block mode --
-- Move text up and down
map('x', 'J', ":move '>+1<CR>gv-gv", opts)
map('x', 'K', ":move '<-2<CR>gv-gv", opts)
map('x', '<A-j>', ":move '>+1<CR>gv-gv", opts)
map('x', '<A-k>', ":move '<-2<CR>gv-gv", opts)

-- Terminal mode --
-- Better terminal navigation
map('t', '<C-h>', '<C-\\><C-N><C-w>h', term_opts)
map('t', '<C-j>', '<C-\\><C-N><C-w>j', term_opts)
map('t', '<C-k>', '<C-\\><C-N><C-w>k', term_opts)
map('t', '<C-l>', '<C-\\><C-N><C-w>l', term_opts)

-- LSP --
map('n', 'r', [[<cmd>lua vim.lsp.buf.rename()<CR>]], opts)
map('n', 'gD', [[<cmd>lua vim.lsp.buf.declaration()<CR>]], opts)
map('n', 'gd', [[<cmd>lua vim.lsp.buf.definition()<CR>]], opts)
map('n', 'td', [[<cmd>lua vim.lsp.buf.type_definition()<CR>]], opts)
map('n', 'sh', [[<cmd>lua vim.lsp.buf.signature_help()<CR>]], opts)

-- PLugin stuff --
-- NvimTree
map('n', '<Leader>e', ':NvimTreeToggle<CR>', opts)

-- Telescope
map('n', '<leader>ff', ':Telescope find_files<CR>', opts)
map('n', '<leader>tt', ':Telescope<CR>', opts)
