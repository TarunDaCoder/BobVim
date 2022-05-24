local status_ok, autosave = pcall(require, 'autosave')
if not status_ok then
	return
end

autosave.setup({
	execution_message = 'Just saved your file before the world collapses or you type `:qa!`',
	write_all_buffers = true,
})
