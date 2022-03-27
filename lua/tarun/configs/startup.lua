local status_ok, startup = pcall(require, 'startup')
if not status_ok then
	return
end

startup.setup({ theme = 'evil' })
