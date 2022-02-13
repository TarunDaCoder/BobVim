local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
    return
end

gitsigns.setup {
    current_line_blame = true,
    preview_config = {
        border = 'single',
        style = 'minimal'
    }
}
