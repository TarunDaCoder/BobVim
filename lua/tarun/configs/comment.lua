local status_ok, comment = pcall(require, 'Comment')
if not status_ok then
	return
end

local todo_status_ok, todo = pcall(require, 'todo-comments')
if not todo_status_ok then
	return
end

comment.setup({
	padding = true,
	sticky = true,
	ignore = '^$',
	toggler = {
		line = 'gcc',
		block = 'gbc',
	},
	opleader = {
		line = 'gc',
		block = 'gb',
	},
	pre_hook = function(ctx)
		local U = require('Comment.utils')

		local location = nil
		if ctx.ctype == U.ctype.block then
			location = require('ts_context_commentstring.utils').get_cursor_location()
		elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
			location = require('ts_context_commentstring.utils').get_visual_start_location()
		end

		return require('ts_context_commentstring.internal').calculate_commentstring({
			key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
			location = location,
		})
	end,
})

todo.setup()
