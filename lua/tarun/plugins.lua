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
    use {'monsonjeremy/onedark.nvim'}
    use {'~/dev/neovim_stuff/themer.lua', branch = "new-palette",
        config = function()
            require("themer").setup({colorscheme = "tokyonight", dim_inactive = true})
        end
    }

	-- Status line
	use {'nvim-lualine/lualine.nvim',
		config = function()

          local lualine = require('lualine')

          -- Color table for highlights
          local colors = {
            bg       = '#202328',
            fg       = '#bbc2cf',
            yellow   = '#ECBE7B',
            cyan     = '#008080',
            darkblue = '#081633',
            green    = '#98be65',
            orange   = '#FF8800',
            violet   = '#a9a1e1',
            magenta  = '#c678dd',
            blue     = '#51afef',
            red      = '#ec5f67',
          }

          local conditions = {
            buffer_not_empty = function()
              return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
            end,
            hide_in_width = function()
              return vim.fn.winwidth(0) > 80
            end,
            check_git_workspace = function()
              local filepath = vim.fn.expand('%:p:h')
              local gitdir = vim.fn.finddir('.git', filepath .. ';')
              return gitdir and #gitdir > 0 and #gitdir < #filepath
            end,
          }

          -- Config
          local config = {
            options = {
              -- Disable sections and component separators
              component_separators = '',
              section_separators = '',
              theme = {
                -- We are going to use lualine_c an lualine_x as left and
                -- right section. Both are highlighted by c theme .  So we
                -- are just setting default looks o statusline
                normal = { c = { fg = colors.fg, bg = colors.bg } },
                inactive = { c = { fg = colors.fg, bg = colors.bg } },
              },
            },
            sections = {
              -- these are to remove the defaults
              lualine_a = {},
              lualine_b = {},
              lualine_y = {},
              lualine_z = {},
              -- These will be filled later
              lualine_c = {},
              lualine_x = {},
            },
            inactive_sections = {
              -- these are to remove the defaults
              lualine_a = {},
              lualine_b = {},
              lualine_y = {},
              lualine_z = {},
              lualine_c = {},
              lualine_x = {},
            },
          }

          -- Inserts a component in lualine_c at left section
          local function ins_left(component)
            table.insert(config.sections.lualine_c, component)
          end

          -- Inserts a component in lualine_x ot right section
          local function ins_right(component)
            table.insert(config.sections.lualine_x, component)
          end

          ins_left({
            function()
              return '▊'
            end,
            color = { fg = colors.blue }, -- Sets highlighting of component
            padding = { left = 0, right = 1 }, -- We don't need space before this
          })

          ins_left({
            -- mode component
            function()
              -- auto change color according to neovims mode
              local mode_color = {
                n = colors.red,
                i = colors.green,
                v = colors.blue,
                [''] = colors.blue,
                V = colors.blue,
                c = colors.magenta,
                no = colors.red,
                s = colors.orange,
                S = colors.orange,
                [''] = colors.orange,
                ic = colors.yellow,
                R = colors.violet,
                Rv = colors.violet,
                cv = colors.red,
                ce = colors.red,
                r = colors.cyan,
                rm = colors.cyan,
                ['r?'] = colors.cyan,
                ['!'] = colors.red,
                t = colors.red,
              }
              vim.api.nvim_command('hi! LualineMode guifg=' .. mode_color[vim.fn.mode()] .. ' guibg=' .. colors.bg)
              return ' '
            end,
            color = 'LualineMode',
            padding = { right = 1 },
          })

          ins_left({
            -- filesize component
            'filesize',
            cond = conditions.buffer_not_empty,
          })

          ins_left({
            'filename',
            cond = conditions.buffer_not_empty,
            color = { fg = colors.magenta, gui = 'bold' },
          })

          ins_left({ 'location' })

          ins_left({ 'progress', color = { fg = colors.fg, gui = 'bold' } })

          ins_left({
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = { error = ' ', warn = ' ', info = ' ' },
            diagnostics_color = {
              color_error = { fg = colors.red },
              color_warn = { fg = colors.yellow },
              color_info = { fg = colors.cyan },
            },
          })

          -- Insert mid section. You can make any number of sections in neovim :)
          -- for lualine it's any number greater then 2
          ins_left({
            function()
              return '%='
            end,
          })

          ins_left({
            -- Lsp server name .
            function()
              local msg = 'No Active Lsp'
              local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
              local clients = vim.lsp.get_active_clients()
              if next(clients) == nil then
                return msg
              end
              for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                  return client.name
                end
              end
              return msg
            end,
            icon = ' LSP:',
            color = { fg = '#ffffff', gui = 'bold' },
          })

          -- Add components to right sections
          ins_right({
            'o:encoding', -- option component same as &encoding in viml
            fmt = string.upper, -- I'm not sure why it's upper case either ;)
            cond = conditions.hide_in_width,
            color = { fg = colors.green, gui = 'bold' },
          })

          ins_right({
            'fileformat',
            fmt = string.upper,
            icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
            color = { fg = colors.green, gui = 'bold' },
          })

          ins_right({
            'branch',
            icon = '',
            color = { fg = colors.violet, gui = 'bold' },
          })

          ins_right({
            'diff',
            -- Is it me or the symbol for modified us really weird
            symbols = { added = ' ', modified = '柳 ', removed = ' ' },
            diff_color = {
              added = { fg = colors.green },
              modified = { fg = colors.orange },
              removed = { fg = colors.red },
            },
            cond = conditions.hide_in_width,
          })

          ins_right({
            function()
              return '▊'
            end,
            color = { fg = colors.blue },
            padding = { left = 1 },
          })

          -- Now don't forget to initialize lualine
          lualine.setup(config)
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
			-- local kind_icons = {
			--   Text = "",
			--   Method = "m",
			--   Function = "",
			--   Constructor = "",
			--   Field = "",
			--   Variable = "",
			--   Class = "",
			--   Interface = "",
			--   Module = "",
			--   Property = "",
			--   Unit = "",
			--   Value = "",
			--   Enum = "",
			--   Keyword = "",
			--   Snippet = "",
			--   Color = "",
			--   File = "",
			--   Reference = "",
			--   Folder = "",
			--   EnumMember = "",
			--   Constant = "",
			--   Struct = "",
			--   Event = "",
			--   Operator = "",
			--   TypeParameter = "",
			-- }
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
                  fields = {
                    cmp.ItemField.Kind,
                    cmp.ItemField.Abbr,
                    cmp.ItemField.Menu,
                  },
              format = require("lspkind").cmp_format({
            with_text = false,
            before = function(entry, vim_item)
              -- Get the full snippet (and only keep first line)
              local word = entry:get_insert_text()
              if
                entry.completion_item.insertTextFormat
                --[[  ]]
                == require("cmp.types").lsp.InsertTextFormat.Snippet
              then
                word = vim.lsp.util.parse_snippet(word)
              end
              word = require("cmp.utils.str").oneline(word)

              -- concatenates the string
              local max = 50
              if string.len(word) >= max then
                local before = string.sub(word, 1, math.floor((max - 3) / 2))
                word = before .. "..."
              end

              if
                entry.completion_item.insertTextFormat
                  == require("cmp.types").lsp.InsertTextFormat.Snippet
                and string.sub(vim_item.abbr, -1, -1) == "~"
              then
                word = word .. "~"
              end
              vim_item.abbr = word

              vim_item.dup = ({
                buffer = 1,
                path = 1,
                nvim_lsp = 0,
              })[entry.source.name] or 0

              return vim_item
            end,
          }),

          -- format = function(entry, vim_item)
          --   -- Kind icons
          --   vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
          --   -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
          --   vim_item.menu = ({
          --   luasnip = "",
          --   })[entry.source.name]
          --   return vim_item
          -- end,
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
                border = {
                  "╔",
                  "═",
                  "╗",
                  "║",
                  "╝",
                  "═",
                  "╚",
                  "║",
                },
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
  use {'folke/trouble.nvim',
    config = function()
      require("trouble").setup {
        auto_close = true,
        use_diagnostic_signs = true,
      }
    end
  }
  use {'onsails/lspkind-nvim',
    config = function()
      local lspkind = {}
      local fmt = string.format

      local kind_presets = {
        default = {
          Class = "   ",
          Color = "   ",
          Constant = "   ",
          Constructor = "   ",
          Enum = " 了  ",
          EnumMember = "   ",
          Event = "   ",
          Field = " ﰠ  ",
          -- File = "  ",
          File = "   ",
          Folder = "   ",
          Function = "   ",
          Interface = "ﰮ  ",
          Keyword = "   ",
          Method = " ƒ  ",
          Module = "   ",
          Operator = "   ",
          Property = "   ",
          Reference = "  ",
          Snippet = "   ",
          -- Snippet = "  ",
          -- Snippet = "   ",
          -- Snippet = " > ",
          Struct = "  ",
          Text = "   ",
          TypeParameter = " ",
          Unit = " 塞 ",
          Value = "   ",
          Variable = "   ",
        },
      }

      local kind_order = {
        "Text",
        "Method",
        "Function",
        "Constructor",
        "Field",
        "Variable",
        "Class",
        "Interface",
        "Module",
        "Property",
        "Unit",
        "Value",
        "Enum",
        "Keyword",
        "Snippet",
        "Color",
        "File",
        "Reference",
        "Folder",
        "EnumMember",
        "Constant",
        "Struct",
        "Event",
        "Operator",
        "TypeParameter",
      }
      local kind_len = 25

      -- default true
      local function opt_with_text(opts)
        return opts == nil or opts["with_text"] == nil or opts["with_text"]
      end

      -- default 'default'
      local function opt_preset(opts)
        local preset
        if opts == nil or opts["preset"] == nil then
          preset = "default"
        else
          preset = opts["preset"]
        end
        return preset
      end

      function lspkind.init(opts)
        local preset = opt_preset(opts)

        local symbol_map = kind_presets[preset]
        lspkind.symbol_map = (
            opts
            and opts["symbol_map"]
            and vim.tbl_extend("force", symbol_map, opts["symbol_map"])
          ) or symbol_map

        local symbols = {}
        local len = kind_len
        for i = 1, len do
          local name = kind_order[i]
          symbols[i] = lspkind.symbolic(name, opts)
        end

        for k, v in pairs(symbols) do
          require("vim.lsp.protocol").CompletionItemKind[k] = v
        end
      end

      lspkind.presets = kind_presets
      lspkind.symbol_map = kind_presets.default

      function lspkind.symbolic(kind, opts)
        local with_text = opt_with_text(opts)

        local symbol = lspkind.symbol_map[kind]
        if with_text == true then
          symbol = symbol and (symbol .. " ") or ""
          return fmt("%s%s", symbol, kind)
        else
          return symbol
        end
      end

      function lspkind.cmp_format(opts)
        if opts == nil then
          opts = {}
        end
        if opts.preset or opts.symbol_map then
          lspkind.init(opts)
        end

        return function(entry, vim_item)
          vim_item.kind = lspkind.symbolic(vim_item.kind, opts)

          if opts.menu ~= nil then
            vim_item.menu = opts.menu[entry.source.name]
          end

          if opts.maxwidth ~= nil then
            vim_item.abbr = string.sub(vim_item.abbr, 1, opts.maxwidth)
          end

          return vim_item
        end
      end
      function lspkind.setup()
        local kinds = vim.lsp.protocol.CompletionItemKind
        for i, kind in ipairs(kinds) do
          kinds[i] = lspkind.icons[kind] or kind
        end
      end

      return lspkind
    end
  }

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
    -- Colorizer
    use {'norcalli/nvim-colorizer.lua',
        config = function()
            require("colorizer").setup {
                'css',
                'lua',
                'javascript',
                'html',
            }
        end
    }

    -- Indent-blankline
    use {'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup {
                show_current_context = true,
                show_current_context_start = true,
                space_char_blankline = " ",
            }
            vim.g.indent_blankline_filetype_exclude = {
                "help",
                "startify",
                "dashboard",
                "packer",
                "NvimTree",
                "Trouble",
                "LspInfo",
                "LspInstallInfo",
            }
            vim.g.indent_blankline_char = "▏"
            vim.g.indent_blankline_show_trailing_blankline_indent = true
            vim.g.indent_blankline_show_first_indent_level = true
            vim.g.indent_blankline_use_treesitter = true
        end
    }

    -- Toggleterm
    use {'akinsho/toggleterm.nvim',
        config = function()
            require("toggleterm").setup {
                size = 20,
                open_mapping = [[<c-\>]],
                hide_numbers = true,
                shade_filetypes = {},
                shade_terminals = true,
                shading_factor  = true,
                start_in_insert = true,
                insert_mappings = true,
                persist_size = true,
                direction = 'float',
                close_on_exit = true,
                shell = vim.o.shell,
                float_opts = {
                    border = 'curved',
                    winblend = 0,
                    highlights = {
                        border = "Normal",
                        background  = "Normal",
                    }
                },
            }

            function _G.set_terminal_keymaps()
                local opts = {noremap = true}
                vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
                vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
                vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
                vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
                vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
                vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
            end

            vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

            local Terminal = require("toggleterm.terminal").Terminal
            local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

            function _LAZYGIT_TOGGLE()
                lazygit:toggle()
            end

            local node = Terminal:new({ cmd = "node", hidden = true })

            function _NODE_TOGGLE()
                node:toggle()
            end

            local btop = Terminal:new({ cmd = "btop", hidden = true })

            function _BTOP_TOGGLE()
                btop:toggle()
            end
        end
    }
	-- Automatically set up the config after cloning packer.nvim
    -- This needs to be at the end after all the plugins
    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)
