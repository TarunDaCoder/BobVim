local status_ok, curline = pcall(require, "nvim-cursorline")
if not status_ok then
  return
end

curline.setup{
  cursorline = {
    enable = true,
    number = true,
    timeout = 500,
  },
  cursorword = {
    enable = true,
    hl = { underline = true },
  },
}
