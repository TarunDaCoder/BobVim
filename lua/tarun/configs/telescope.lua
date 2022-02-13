local Telescope = {}

Telescope.custom_theme = {
    results_title = false,
    layout_strategy = "center",
    previewer = false,
    winblend = 30,
    layout_config = { width = 0.6, height = 0.6 },
    borderchars = {
        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        results = { "─", " ", " ", " ", "╰", "╯", " ", " " },
    }
}

require("telescope").load_extension "file_browser"
require("telescope").load_extension "packer"
-- require("telescope").extensions.live_grep_raw.live_grep_raw()
require("telescope").load_extension "zoxide"

require("telescope").setup {
    defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
            horizontal = {
                mirror = false,
            },
            vertical = {
                mirror = true,
            },
        },
        winblend = 30,
        border = {},
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },

        color_devicons = true,
    }
}

return Telescope
