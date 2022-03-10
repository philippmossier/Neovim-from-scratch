local default_on_attach = require("user.lsp.handlers").on_attach

return {
	on_attach = function(client, bufnr)
		-- import on_attach settings which are used on every server 
		default_on_attach(client, bufnr)
	  end,
	settings = {

		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
}
