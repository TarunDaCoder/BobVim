local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

parser_configs.norg = {
	install_info = {
		url = "https://github.com/nvim-neorg/tree-sitter-norg",
		files = { "src/parser.c", "src/scanner.cc" },
		branch = "main",
	},
}

require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true, -- false will disable the whole extension
		additional_vim_regex_highlighting = true,
		disable = { "latex" },
	},
	ensure_installed = { "norg", "javascript", "html", "css", "lua" },
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
})
