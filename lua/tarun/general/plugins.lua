local fn = vim.fn

-- Install packer automatically
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]])

-- Use a protected call so when we don't error out on first use
local packer_ok, packer = pcall(require, "packer")
if not packer_ok then
	return
end

-- Make packer use a popout window and other stuff
packer.init({
	profile = { enabled = true },
	git = { clone_timeout = 300 },
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "double" })
		end,
	},
})

-- Install plugins here
return require("packer").startup(function(use)
	-- Packer can manage itself
	use({ "wbthomason/packer.nvim" })

	-- Devicons
	use({ "kyazdani42/nvim-web-devicons" })

	-- Popup thingy
	use({ "nvim-lua/popup.nvim" })

	-- Plenary
	use({ "nvim-lua/plenary.nvim" })

	-- Colourscheme
	use({ "themercorp/themer.lua" })

	-- Status line
	use({ "feline-nvim/feline.nvim" })

	-- Tabline
	use({ "akinsho/bufferline.nvim" })

	-- CMP
	use({ "hrsh7th/nvim-cmp" })
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-path" })
	use({ "hrsh7th/cmp-cmdline" })
	use({ "saadparwaiz1/cmp_luasnip" })
	use({ "hrsh7th/cmp-nvim-lua" })
	use({ "hrsh7th/cmp-nvim-lsp" })

	-- Snippets
	use({ "L3MON4D3/LuaSnip" })
	use({ "rafamadriz/friendly-snippets" })

	-- Comments
	use({ "numToStr/Comment.nvim" })
	use({ "JoosepAlviste/nvim-ts-context-commentstring" })
	use({ "folke/todo-comments.nvim" })

	-- Better explorer
	use({ "kyazdani42/nvim-tree.lua" })

	-- LSP
	use({ "neovim/nvim-lspconfig" })
	use({ "williamboman/nvim-lsp-installer" })
	use({ "jose-elias-alvarez/null-ls.nvim" })
	use({ "folke/trouble.nvim", opt = true })
	use({ "onsails/lspkind-nvim" })

	-- Autopairs
	use({ "windwp/nvim-autopairs" })

	-- Telescope
	use({ "nvim-telescope/telescope.nvim" })
	use({ "nvim-telescope/telescope-file-browser.nvim" })
	use({ "nvim-telescope/telescope-packer.nvim" })
	use({ "nvim-telescope/telescope-rg.nvim", requires = { "nvim-telescope/telescope-live-grep-raw.nvim" } })
	use({ "jvgrootveld/telescope-zoxide" })

	-- Neorg
	use({ "nvim-neorg/neorg", requires = "nvim-lua/plenary.nvim" })

	-- Treesitter
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use({ "p00f/nvim-ts-rainbow" })
	use({ "nvim-treesitter/playground" })

	-- Gitsigns
	use({ "lewis6991/gitsigns.nvim", opt = true })
	-- Colorizer
	use({ "norcalli/nvim-colorizer.lua", opt = true })

	-- Indent-blankline
	use({ "lukas-reineke/indent-blankline.nvim" })

	-- Toggleterm
	use({ "akinsho/toggleterm.nvim", opt = true })

	-- Notify
	use({
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
	})

	-- Dashboard
	use({ "startup-nvim/startup.nvim" })

	-- Illuminate words that are repeated in the file
	use({
		"rrethy/vim-illuminate",
		config = function()
			vim.cmd([[ hi def link LspReferenceText Cursorline ]])
			vim.cmd([[ hi def link LspReferenceWrite Cursorline ]])
			vim.cmd([[ hi def link LspReferenceRead Cursorline ]])
		end,
	})

	-- GitHub Copilot
	use({ "github/copilot.vim" })

	-- Wordle
	use({ "shift-d/wordle.nvim", branch = "finish-win" })

	-- WhichKey
	use({ "folke/which-key.nvim" })

	-- Automatically set up the config after cloning packer.nvim
	-- This needs to be at the end after all the plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
