local status_ok, ducky = pcall(require, 'duckytype')
if not status_ok then
  return
end

ducky.setup()
