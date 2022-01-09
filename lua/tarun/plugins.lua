local fn = vim.fn

-- Install packer automatically
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so when we don't error out on first use
local packer_ok, packer = pcall(require, "packer")
if not packer_ok then
  return
end

-- Make packer use a popout window and other stuff
packer.init {
	profile = { enabled = true },
    git = { clone_timeout = 300 },
	display = {
	  open_fn = function()
	    return require("packer.util").float { border = "double" }
	  end,
	},
}

-- Install plugins here
return require('packer').startup(function(use)
	-- Packer can manage itself
	use {'wbthomason/packer.nvim'}

	-- Devicons
	use {'kyazdani42/nvim-web-devicons'}

    -- Popup thingy
    use {'nvim-lua/popup.nvim'}

    -- Plenary
    use {'nvim-lua/plenary.nvim'}

	-- Colourscheme
	use {'mofiqul/dracula.nvim'}

	-- Status line
	use {'nvim-lualine/lualine.nvim',
		config = function()
			require('lualine').setup {
			  options = {
				icons_enabled = true,
				theme = 'dracula',
				component_separators = '|',
				section_separators = { left = '', right = '' },
				disabled_filetypes = {},
				always_divide_middle = true,
			  },
			  sections = {
				lualine_a = {'mode'},
				lualine_b = {'branch', 'diff', 'diagnostics'},
				lualine_c = {'filename'},
				lualine_x = {'encoding', 'fileformat', 'filetype'},
				lualine_y = {'progress'},
				lualine_z = {'location'}
			  },
			  inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {'filename'},
				lualine_x = {'location'},
				lualine_y = {},
				lualine_z = {}
			  },
			  tabline = {},
			  extensions = {}
			}
		end
	}

	-- Tabline
	use {'akinsho/bufferline.nvim',
		require('bufferline').setup{}
	}

	-- CMP
	use {'hrsh7th/nvim-cmp',
		config = function()
			local cmp_status_ok, cmp = pcall(require, "cmp")
			if not cmp_status_ok then
			  return
			end

			local snip_status_ok, luasnip = pcall(require, "luasnip")
			if not snip_status_ok then
			  return
			end

			require("luasnip/loaders/from_vscode").lazy_load()

			local check_backspace = function()
			  local col = vim.fn.col "." - 1
			  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
			end

			--   פּ ﯟ   some other good icons
			local kind_icons = {
			  Text = "",
			  Method = "m",
			  Function = "",
			  Constructor = "",
			  Field = "",
			  Variable = "",
			  Class = "",
			  Interface = "",
			  Module = "",
			  Property = "",
			  Unit = "",
			  Value = "",
			  Enum = "",
			  Keyword = "",
			  Snippet = "",
			  Color = "",
			  File = "",
			  Reference = "",
			  Folder = "",
			  EnumMember = "",
			  Constant = "",
			  Struct = "",
			  Event = "",
			  Operator = "",
			  TypeParameter = "",
			}
			-- find more here: https://www.nerdfonts.com/cheat-sheet

			cmp.setup {
			  snippet = {
				expand = function(args)
				  luasnip.lsp_expand(args.body) -- For `luasnip` users.
				end,
			  },
			  mapping = {
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
				["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
				["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
				["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
				["<C-e>"] = cmp.mapping {
				  i = cmp.mapping.abort(),
				  c = cmp.mapping.close(),
				},
				-- Accept currently selected item. If none selected, `select` first item.
				-- Set `select` to `false` to only confirm explicitly selected items.
				["<CR>"] = cmp.mapping.confirm { select = true },
				["<Tab>"] = cmp.mapping(function(fallback)
				  if cmp.visible() then
					cmp.select_next_item()
				  elseif luasnip.expandable() then
					luasnip.expand()
				  elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				  elseif check_backspace() then
					fallback()
				  else
					fallback()
				  end
				end, {
				  "i",
				  "s",
				}),
				["<S-Tab>"] = cmp.mapping(function(fallback)
				  if cmp.visible() then
					cmp.select_prev_item()
				  elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				  else
					fallback()
				  end
				end, {
				  "i",
				  "s",
				}),
			  },
			  formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
				  -- Kind icons
				  vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
				  -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
				  vim_item.menu = ({
					luasnip = "",
				  })[entry.source.name]
				  return vim_item
				end,
			  },
			  sources = {
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
				{ name = "nvim_lua" },
			  },
			  confirm_opts = {
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			  },
			  documentation = {
				border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			  },
			  experimental = {
				ghost_text = true,
				native_menu = false,
			  },
			}

			cmp.setup.cmdline(':', {
				sources = {
					{ name = 'cmdline' },
				}
			})

			cmp.setup.cmdline('/', {
			  sources = {
				{ name = 'buffer' },
			  }
			})
		end
	}
	use {'hrsh7th/cmp-buffer'}
	use {'hrsh7th/cmp-path'}
	use {'hrsh7th/cmp-cmdline'}
	use {'saadparwaiz1/cmp_luasnip'}
	use {'hrsh7th/cmp-nvim-lua'}
	use {'hrsh7th/cmp-nvim-lsp'}

	-- Snippets
	use {'L3MON4D3/LuaSnip'}
	use {'rafamadriz/friendly-snippets'}

	-- Comments
	use {
		'numToStr/Comment.nvim',
		config = function()
			local status_ok, comment = pcall(require, "Comment")
			if not status_ok then
			  return
			end

			comment.setup {
			  pre_hook = function(ctx)
				local U = require "Comment.utils"

				local location = nil
				if ctx.ctype == U.ctype.block then
				  location = require("ts_context_commentstring.utils").get_cursor_location()
				elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
				  location = require("ts_context_commentstring.utils").get_visual_start_location()
				end

				return require("ts_context_commentstring.internal").calculate_commentstring {
				  key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
				  location = location,
				}
			  end,
			}
		end
	}
  use {'JoosepAlviste/nvim-ts-context-commentstring'}

	-- Better explorer
	use {'kyazdani42/nvim-tree.lua',
		config = function()
			-- following options are the default
			-- each of these are documented in `:help nvim-tree.OPTION_NAME`
			vim.g.nvim_tree_icons = {
			  default = "",
			  symlink = "",
			  git = {
				unstaged = "",
				staged = "S",
				unmerged = "",
				renamed = "➜",
				deleted = "",
				untracked = "U",
				ignored = "◌",
			  },
			  folder = {
				default = "",
				open = "",
				empty = "",
				empty_open = "",
				symlink = "",
			  },
			}

			local status_ok, nvim_tree = pcall(require, "nvim-tree")
			if not status_ok then
			  return
			end

			local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
			if not config_status_ok then
			  return
			end

			local tree_cb = nvim_tree_config.nvim_tree_callback

			nvim_tree.setup {
			  disable_netrw = true,
			  hijack_netrw = true,
			  open_on_setup = false,
			  ignore_ft_on_setup = {
				"startify",
				"dashboard",
				"alpha",
			  },
			  auto_close = true,
			  open_on_tab = false,
			  hijack_cursor = false,
			  update_cwd = true,
			  update_to_buf_dir = {
				enable = true,
				auto_open = true,
			  },
			  diagnostics = {
				enable = true,
				icons = {
				  hint = "",
				  info = "",
				  warning = "",
				  error = "",
				},
			  },
			  update_focused_file = {
				enable = true,
				update_cwd = true,
				ignore_list = {},
			  },
			  git = {
				enable = true,
				ignore = true,
				timeout = 500,
			  },
			  view = {
				width = 30,
				height = 30,
				hide_root_folder = false,
				side = "left",
				auto_resize = true,
				mappings = {
				  custom_only = false,
				  list = {
					{ key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
					{ key = "h", cb = tree_cb "close_node" },
					{ key = "v", cb = tree_cb "vsplit" },
				  },
				},
				number = false,
				relativenumber = false,
			  },
			  quit_on_open = 0,
			  git_hl = 1,
			  disable_window_picker = 0,
			  root_folder_modifier = ":t",
			  show_icons = {
				git = 1,
				folders = 1,
				files = 1,
				folder_arrows = 1,
				tree_width = 30,
			  },
			}
		end
	}

	-- LSP
	use {'neovim/nvim-lspconfig'}
	use {'williamboman/nvim-lsp-installer'}
  use {'jose-elias-alvarez/null-ls.nvim'}

  -- Autopairs
  use {'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup {
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          offset = 0, -- Offset from pattern match
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      }

      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      local cmp_status_ok, cmp = pcall(require, "cmp")
      if not cmp_status_ok then
        return
      end
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
    end
  }

  -- Telescope
  use {'nvim-telescope/telescope.nvim'}
  use {'nvim-telescope/telescope-file-browser.nvim'}
  use {'nvim-telescope/telescope-packer.nvim'}
  use {'nvim-telescope/telescope-rg.nvim'}

  -- Neorg
  use {'vhyrro/neorg',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			require('neorg').setup {
				load = {
					["core.defaults"] = {},
					["core.norg.completion"] = {
						config = {
							engine = "nvim-cmp",
						},
					},
					["core.norg.concealer"] = {
						config = {
                            icons = {
                                heading = {
                                    enabled = true,
                                    level_1 = {
                                        icon = "◉",
                                    },
                                    level_2 = {
                                        icon = " ○",
                                    },
                                    level_3 = {
                                        icon = "  ●",
                                    },
                                    level_4 = {
                                        icon = "   ○",
                                    },
                                    level_5 = {
                                        icon = "    ●",
                                    },
                                    level_6 = {
                                        icon = "     ○",
                                    },
                                    level_7 = {
                                        icon = "      ●",
                                    },
                                },
                            },
                        },
					},
					["core.norg.dirman"] = {
						config = {
							workspaces = {
								nvim_config_todos = "~/.config/nvim/todos/",
							},
							-- Automatically detect whenever we have entered a subdirectory of a workspace
						autodetect = true,
						-- Automatically change the directory to the root of the workspace every time
						autochdir = true,
						}
					}
				}
			}
		end,
	}

  -- Treesitter
  use {'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

      parser_configs.norg = {
        install_info = {
          url = "https://github.com/nvim-neorg/tree-sitter-norg",
          files = { "src/parser.c", "src/scanner.cc" },
          branch = "main",
        },
      }

      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true, -- false will disable the whole extension
          additional_vim_regex_highlighting = true,
          disable = { "latex" },
        },
        ensure_installed = {'norg', 'javascript', 'html', 'css', 'lua'},
        matchup = {
          enable = false,
        },
        context_commentstring = {
          enable = true,
          config = { css = "// %s" },
          enable_autocmd = false,
        },
        indent = { enable = true },
        autotag = { enable = false },
        autopairs = { enable = true },
        playground = {
          enable = true,
          updatetime = 25,
          persist_queries = false,
          keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
          },
        },
        rainbow = {
          enable = true,
          extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
          max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
          colors = {
            "#ff5555",
            "#8be9fd",
            "#50fa7b",
            "#ff79c6",
          },
        },
      }
    end
  }
  use {'p00f/nvim-ts-rainbow'}
  use {'nvim-treesitter/playground'}
  -- Shade
  use {'sunjon/shade.nvim',
    config = function()
      require'shade'.setup({
        overlay_opacity = 50,
        opacity_step = 1,
        keys = {
          brightness_up    = '<C-Up>',
          brightness_down  = '<C-Down>',
          toggle           = '<Leader>s',
        }
      })
    end
  }
  -- Gitsigns
  use {'lewis6991/gitsigns.nvim',
  config = function()
    require("gitsigns").setup {
      current_line_blame = true,
      preview_config = {
        border = 'single',
        style = 'minimal'
      }
    }
  end
  }
	-- Automatically set up the config after cloning packer.nvim
  -- This needs to be at the end after all the plugins
  if PACKER_BOOTSTRAP then
      require('packer').sync()
  end
end)
