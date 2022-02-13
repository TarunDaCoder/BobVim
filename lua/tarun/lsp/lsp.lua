local lsp_config = {}

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require("lspconfig")
local capabilities1 = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
local configs = require("lspconfig/configs")
local root_pattern = require("lspconfig.util").root_pattern

local signs = {
	{ name = "DiagnosticSignError", text = "" },
	{ name = "DiagnosticSignWarn", text = "" },
	{ name = "DiagnosticSignHint", text = "" },
	{ name = "DiagnosticSignInfo", text = "" },
}
for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local border = {
	{ "╔", "FloatBorder" },
	{ "═", "FloatBorder" },
	{ "╗", "FloatBorder" },
	{ "║", "FloatBorder" },
	{ "╝", "FloatBorder" },
	{ "═", "FloatBorder" },
	{ "╚", "FloatBorder" },
	{ "║", "FloatBorder" },
}

vim.diagnostic.config({
	signs = true,
	underline = true,
	severity_sort = true,
	update_in_insert = true,
	float = {
		focusable = false,
		scope = "cursor",
		source = true,
		border = border,
		header = { "Mistakes you made:", "DiagnosticHeader" },
		prefix = function(diagnostic, i, total)
			local icon, highlight
			if diagnostic.severity == 1 then
				icon = ""
				highlight = "DiagnosticError"
			elseif diagnostic.severity == 2 then
				icon = ""
				highlight = "DiagnosticWarn"
			elseif diagnostic.severity == 3 then
				icon = ""
				highlight = "DiagnosticInfo"
			elseif diagnostic.severity == 4 then
				icon = ""
				highlight = "DiagnosticHint"
			end
			return i .. "/" .. total .. " " .. icon .. "  ", highlight
		end,
	},
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "rounded",
})

lspconfig.html.setup({
	cmd = { "vscode-html-language-server.cmd", "--stdio" },
	capabilities = capabilities,
})

lspconfig.cssls.setup({
	cmd = { "vscode-css-language-server.cmd", "--stdio" },
	capabilities = capabilities,
})

lspconfig.tsserver.setup({
	cmd = { "typescript-language-server.cmd", "--stdio" },
	capabilities = capabilities1,
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	on_attach = function(client)
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
	end,
})

lspconfig.jsonls.setup({
	cmd = { "vscode-json-language-server.cmd", "--stdio" },
	capabilities = capabilities,
	filetypes = { "json" },
})

if not lspconfig.emmet_ls then
	configs.emmet_ls = {
		default_config = {
			cmd = { "emmet-ls.cmd", "--stdio" },
			filetypes = { "html", "css", "scss" },
		},
	}
end
lspconfig.emmet_ls.setup({ capabilities = capabilities })

local lua_cmd = {
	vim.fn.expand("~") .. "/lua-language-server/bin/lua-language-server",
}

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup({
	cmd = lua_cmd,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
	on_attach = function(client)
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
	end,
})

lspconfig.rust_analyzer.setup({
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_dir = root_pattern("Cargo.toml", "rust-project.json"),
})

return lsp_config
