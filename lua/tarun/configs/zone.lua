local status_ok,zone = pcall(require, 'zone')
if not status_ok then
  return
end

zone.setup{
  style = "vanish",
  after = 200,
}
