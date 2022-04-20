local status_ok, cmp = pcall(require, 'cmp')
if not status_ok then
	return
end

local lsnip_status_ok, luasnip = pcall(require, 'luasnip')
if not lsnip_status_ok then
	return
end

require('luasnip/loaders/from_vscode').lazy_load()

local check_backspace = function()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
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

local border = {
	'╔',
	'═',
	'╗',
	'║',
	'╝',
	'═',
	'╚',
	'║',
}

cmp.setup({
	completion = {
		border = border,
	},
	window = {
		documentation = { border = 'rounded' },
		completion = { border = 'rounded' },
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		['<C-k>'] = cmp.mapping.select_prev_item(),
		['<C-j>'] = cmp.mapping.select_next_item(),
		['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		['<C-e>'] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<Tab>'] = cmp.mapping(function(fallback)
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
			'i',
			's',
		}),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			'i',
			's',
		}),
		['<C-J>'] = cmp.mapping(function(fallback)
			cmp.mapping.abort()
			local copilot_keys = vim.fn['copilot#Accept']()
			if copilot_keys ~= '' then
				vim.api.nvim_feedkeys(copilot_keys, 'i', true)
			else
				fallback()
			end
		end, {
			'i',
			's',
		}),
	},
	formatting = {
		-- fields = { 'kind', 'abbr', 'menu' },
		format = require('lspkind').cmp_format({
			with_text = false,
			menu = {
				buffer = '[Buf]',
				nvim_lsp = '[LSP]',
				nvim_lua = '[Lua]',
				path = '[Path]',
				neorg = '[Neorg]',
				luasnip = '[LuaSnip]',
			},
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
		{ name = 'neorg' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
		{ name = 'path' },
		{ name = 'nvim_lua' },
		{ name = 'nvim_lsp' },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	experimental = {
		ghost_text = true,
		native_menu = false,
	},
})

cmp.setup.cmdline(':', {
	sources = {
		{ name = 'cmdline' },
	},
})

cmp.setup.cmdline('/', {
	sources = {
		{ name = 'buffer' },
	},
})
