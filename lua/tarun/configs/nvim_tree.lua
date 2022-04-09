local g = vim.g

g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names
g.nvim_tree_git_hl = 0
g.nvim_tree_highlight_opened_files = 0
g.nvim_tree_indent_markers = 1
g.nvim_tree_root_folder_modifier = table.concat({ ':t:gs?$?/..', string.rep(' ', 1000), '?:gs?^??' })

g.nvim_tree_show_icons = {
	folders = 1,
	files = 1,
	git = 1,
}

g.nvim_tree_icons = {
	default = '',
	symlink = '',
	git = {
		unstaged = '',
		staged = '✓',
		unmerged = '',
		renamed = '➜',
		deleted = '',
		untracked = '★',
		ignored = '◌',
	},
	folder = {
		default = '',
		open = '',
		empty = '',
		empty_open = '',
		symlink = '',
	},
}

local status_ok, nvim_tree = pcall(require, 'nvim-tree')
if not status_ok then
	return
end

local config_status_ok, nvim_tree_config = pcall(require, 'nvim-tree.config')
if not config_status_ok then
	return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup({
	disable_netrw = true,
	hijack_netrw = true,
	open_on_setup = false,
	ignore_ft_on_setup = {
		'startup',
	},
	open_on_tab = false,
	hijack_cursor = true,
	update_cwd = true,
	update_to_buf_dir = {
		enable = true,
		auto_open = true,
	},
	diagnostics = {
		enable = true,
		icons = {
			hint = '',
			info = '',
			warning = '',
			error = '',
		},
	},
	update_focused_file = {
		enable = true,
		update_cwd = false,
	},
	git = {
		enable = true,
		ignore = true,
		timeout = 2000,
	},
	view = {
		width = 25,
		hide_root_folder = true,
		side = 'left',
		allow_resize = true,
		mappings = {
			custom_only = false,
			list = {
				{ key = { 'l', '<CR>', 'o' }, cb = tree_cb('edit') },
				{ key = 'h', cb = tree_cb('close_node') },
				{ key = 'v', cb = tree_cb('vsplit') },
			},
		},
		number = false,
		relativenumber = false,
	},
	quit_on_open = 0,
	git_hl = 1,
	disable_window_picker = 0,
	root_folder_modifier = ':t',
	show_icons = {
		git = 1,
		folders = 1,
		files = 1,
		folder_arrows = 1,
		tree_width = 30,
	},
	actions = {
		open_file = {
			exclude = {
				filetype = { 'notify', 'packer' },
				buftype = { 'terminal' },
			},
		},
	},
})
