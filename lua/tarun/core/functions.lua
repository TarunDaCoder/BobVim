-- Get last insertion

local function show_gi_mark()
    local cursor_pos = vim.api.nvim_win_get_cursor(0) -- Get actual position

    local ok, _ = pcall(vim.cmd, 'normal `.')
    if ok then
        Mark_last = vim.api.nvim_win_get_cursor(0) -- Get the position
    else
        return
    end

    vim.api.nvim_win_set_cursor(0, cursor_pos) -- Restore position

    local line_num = Mark_last[1] - 1

    vim.api.nvim_set_hl(0, 'ShowgiMark', { bg = 'NONE', fg = '#c4a7e7' })
    local opts_virtualtext = {
        end_line = 0,
        id = 1,
        virt_text = { { '  Last insertion', 'ShowgiMark' } },
        virt_text_pos = 'eol',
    }

    vim.api.nvim_buf_set_extmark(vim.fn.bufnr('%'), vim.api.nvim_create_namespace('show_gi_mark'), line_num, 0, opts_virtualtext)
end

vim.api.nvim_create_autocmd('InsertLeave', {
    callback = show_gi_mark,
})
show_gi_mark()
