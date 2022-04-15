local status_ok, neorg = pcall(require, 'neorg')
if not status_ok then
	return
end

neorg.setup({
	load = {
		['core.defaults'] = {},
		['core.norg.completion'] = {
			config = {
				engine = 'nvim-cmp',
			},
		},
		['core.norg.concealer'] = {
			config = {
				markup_preset = 'dimmed',
				icon_preset = 'diamond',
				icons = {
					marker = {
						icon = ' ',
					},
					todo = {
						enable = true,
						pending = {
							-- icon = ""
							icon = '',
						},
						uncertain = {
							icon = '?',
						},
						urgent = {
							icon = '',
						},
						on_hold = {
							icon = '',
						},
						cancelled = {
							icon = '',
						},
					},
				},
			},
		},
		['core.norg.dirman'] = {
			config = {
				workspaces = {
					bobvim_todos = '~/.config/nvim/',
					neorg = '~/.norg/',
				},
				autodetect = true,
				autochdir = true,
				index = 'index.norg',
			},
		},
	},
})
