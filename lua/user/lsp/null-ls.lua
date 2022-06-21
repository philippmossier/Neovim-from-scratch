-- null-ls DOCS builtins: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md

local null_ls_status_ok, null_ls = pcall(require, "null-ls")

if not null_ls_status_ok then
	return
end

-- used for async formatting https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Async-formatting
_G.formatting = function(bufnr)
	bufnr = tonumber(bufnr) or vim.api.nvim_get_current_buf()

	vim.lsp.buf_request(
		bufnr,
		"textDocument/formatting",
		{ textDocument = { uri = vim.uri_from_bufnr(bufnr) } },
		function(err, res)
			if err then
				local err_msg = type(err) == "string" and err or err.message

				-- you can modify the log message / level (or ignore it completely)
				vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)

				return
			end

			-- don't apply results if buffer is unloaded or has been modified
			if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
				return
			end

			if res then
				vim.lsp.util.apply_text_edits(res, bufnr)

				vim.api.nvim_buf_call(bufnr, function()
					vim.cmd("silent noautocmd update")
				end)
			end
		end
	)
end

null_ls.setup({
	debug = false,
	sources = {
		-- Note: UPDATED 16.6.2022, Try using eslint_d as much as possible because its the fastest

		-- ================================ LINTING =============================================
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
		null_ls.builtins.code_actions.eslint_d, -- requires npm install -g eslint_d
		-- null_ls.builtins.code_actions.gitsigns,

		-- ============================== DIAGNOSTICS ==========================================
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
		null_ls.builtins.diagnostics.eslint_d,
		-- null_ls.builtins.diagnostics.markdownlint,

		-- ============================== FORMATTING ==========================================
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
		null_ls.builtins.formatting.eslint_d,
		null_ls.builtins.formatting.stylua,
		-- USE this if your project uses prettier:
		null_ls.builtins.formatting.prettierd.with({
			env = {
				PRETTIERD_LOCAL_PRETTIER_ONLY = 1, -- to use prettierd exclusively with the locally installed prettier package, ENABLE this if your project uses prettier
				-- string.format('PRETTIERD_DEFAULT_CONFIG=%s', vim.fn.expand('~/.config/nvim/utils/linter-config/.prettierrc.json')),
				-- PRETTIERD_DEFAULT_CONFIG = vim.fn.expand "~/.config/nvim/utils/linter-config/.prettierrc.json",
			},
		}),
		-- USE this if your project does not have prettier:
		-- null_ls.builtins.formatting.prettierd,
	},

	-- ============================== FORMAT ON SAVE ==========================================
	-- format on save (sync) but i think this saves all buffers not only one https://github.com/jose-elias-alvarez/null-ls.nvim
	-- format on save UPDATED 16.6.2022
	-- Regarding https://neovim.io/doc/user/lsp.html you can check the current available capabilities with :lua =vim.lsp.get_active_clients()[1].server_capabilities
	-- different formatting ways formatting_sync() formatting() format()
	-- 0.7 --vim.lsp.buf.formatting_sync(nil, 2000) -- 2 seconds
	-- 0.8 --vim.lsp.buf.format({ timeout_ms = 2000 })
	on_attach = function(client)
		if client.server_capabilities.documentFormattingProvider then -- client.resolved_capabilities.document_formatting OR server_capabilities.documentFormattingProvider
			vim.cmd([[
                    augroup LspFormatting
                        autocmd! * <buffer>
                        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
                    augroup END
                ]])
		end
	end,
})
