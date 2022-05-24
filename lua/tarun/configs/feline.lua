local status_ok, feline = pcall(require, 'feline')
if not status_ok then
  return
end

feline.setup{
  -- components = require("catppuccin.core.integrations.feline"),
}
