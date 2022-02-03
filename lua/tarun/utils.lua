local Util = {}

-- Custom telescope theme
Util.telescope_theme = {
    results_title = false,
    layout_strategy = "center",
    previewer = false,
    winblend = 30,
    layout_config = { width = 0.6, height = 0.6 },
    borderchars = {
        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        results = { "─", " ", " ", " ", "╰", "╯", " ", " " },
    },
}
--> Different Kinds of Borders
local borders = {
	{ "╒", "═", "╕", "│", "╛", "═", "╘", "│" },
	{ "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
	{ "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
}
Util.border = borders[0]

return Util
