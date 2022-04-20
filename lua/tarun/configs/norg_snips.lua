local ls = require('luasnip')
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt
local conds = require('luasnip.extras.expand_conditions')

-- vsedovs snippet magic
local autosnippets = {
	s({
		trig = '*([2-6])',
		name = 'Heading',
		dscr = 'Add Heading',
		regTrig = true,
		hidden = true,
	}, {
		f(function(_, snip)
			return string.rep('*', tonumber(snip.captures[1])) .. ' '
		end, {}),
	}, {
		condition = conds.line_begin,
	}),
	s({
		trig = 'q([2-6])',
		name = 'Quote',
		dscr = 'Add Quote',
		regTrig = true,
		hidden = true,
	}, {
		f(function(_, snip)
			return string.rep('>', tonumber(snip.captures[1])) .. ' '
		end, {}),
	}, {
		condition = conds.line_begin,
	}),
	s(
		{
			trig = ';l',
			name = 'fast option',
		},
		-- = {
		fmt([[ - [{}] ]], {
			-- return option "plugin"
			d(1, function()
				local options = { ' ', 'x', '-', '=', '_', '!', '+', '?' }
				for i = 1, #options do
					options[i] = t(options[i])
				end
				return sn(nil, {
					c(1, options),
				})
			end),
		})
	),
	s({
		trig = '-([2-6])',
		name = 'Unordered lists',
		dscr = 'Add Unordered lists',
		regTrig = true,
		hidden = true,
	}, {
		f(function(_, snip)
			return string.rep('-', tonumber(snip.captures[1])) .. ' ['
		end, {}),
	}, {
		condition = conds.line_begin,
	}),
	s({
		trig = '~([2-6])',
		name = 'Ordered lists',
		dscr = 'Add Ordered lists',
		regTrig = true,
		hidden = true,
	}, {
		f(function(_, snip)
			return string.rep('~', tonumber(snip.captures[1])) .. ' '
		end, {}),
	}, {
		condition = conds.line_begin,
	}),
}

local function gen_rec_snip(delimiter)
	local ret
	ret = function()
		return sn(nil, {
			c(1, {
				-- important!! Having the sn(...) as the first choice will cause infinite recursion.
				t({ '' }),
				-- The same dynamicNode as in the snippet (also note: self reference).
				sn(nil, { t({ '', delimiter }), i(1), d(2, ret, {}) }),
			}),
		})
	end
	return ret
end

-- TODO: Make this a choice via snippet, to choose list depth
-- Perhaps using the autosnippets seen above!
-- Idea being you start out by making a list (for example `---`),
-- And then every node generated after that has the same heading level
-- currently, for me at least just typing a kw in insert mode is simple enough, and only 2 keystrokes to change heading level is not bad at all
local snippets = {
	s('l1', d(1, gen_rec_snip('- '), {})), -- to lreq, bind parse the list
	s('l1', d(1, gen_rec_snip('- '), {})), -- to lreq, bind parse the list
	s('l2', d(1, gen_rec_snip('-- '), {})), -- to lreq, bind parse the list
	s('l3', d(1, gen_rec_snip('--- '), {})), -- to lreq, bind parse the list
	s('i1', d(1, gen_rec_snip('~ '), {})), -- to lreq, bind parse the list
	s('i2', d(1, gen_rec_snip('~~ '), {})), -- to lreq, bind parse the list
	s('i3', d(1, gen_rec_snip('~~~ '), {})), -- to lreq, bind parse the list
}

-- TODO: What is the right way to return these? Do we auto update the user snippets?
ls.add_snippets('norg', autosnippets, { type = 'autosnippets' })
ls.add_snippets('norg', snippets)
