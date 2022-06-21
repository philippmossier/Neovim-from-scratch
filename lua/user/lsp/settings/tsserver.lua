local default_on_attach = require("user.lsp.handlers").on_attach
local M = {}

-- Needed for inlayHints. Merge this table with your settings or copy
-- it from the source if you want to add your own init_options.
M.init_options = require("nvim-lsp-ts-utils").init_options

M.on_attach = function(client, bufnr)
	-- import on_attach settings which are used on every server
	default_on_attach(client, bufnr)

	-- fixes asking about null-ls or tsserver (on video minute:17:20) https://www.youtube.com/watch?v=b7OguLuaYvE&list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ&index=17
	if client.name == "tsserver" then
		client.resolved_capabilities.document_formatting = false -- resolved_capabilities DEPRECATED (use server_capabilities instead)
		client.resolved_capabilities.document_range_formatting = false

		-- I think nvim v8 needs server_capabilities (v7 uses resolved_capabilities)
		-- client.server_capabilities.documentFormattingProvider = false
		-- client.server_capabilities.documentRangeFormattingProvider = false
	end

	-- ts_utils
	local ts_utils = require("nvim-lsp-ts-utils")
	-- ts_utils defaults
	ts_utils.setup({
		debug = false,
		disable_commands = false,
		enable_import_on_completion = true,

		-- import all
		import_all_timeout = 5000, -- ms
		-- lower numbers = higher priority
		import_all_priorities = {
			same_file = 1, -- add to existing import statement
			local_files = 2, -- git files or files with relative path markers
			buffer_content = 3, -- loaded buffer content
			buffers = 4, -- loaded buffer names
		},
		import_all_scan_buffers = 100,
		import_all_select_source = false,
		-- if false will avoid organizing imports
		always_organize_imports = true,

		-- filter diagnostics
		filter_out_diagnostics_by_severity = {},
		filter_out_diagnostics_by_code = {},

		-- inlay hints
		auto_inlay_hints = true,
		inlay_hints_highlight = "Comment",
		inlay_hints_priority = 200, -- priority of the hint extmarks
		inlay_hints_throttle = 150, -- throttle the inlay hint request
		inlay_hints_format = { -- format options for individual hint kind
			Type = {},
			Parameter = {},
			Enum = {},
			-- Example format customization for `Type` kind:
			-- Type = {
			--     highlight = "Comment",
			--     text = function(text)
			--         return "->" .. text:sub(2)
			--     end,
			-- },
		},

		-- update imports on file move
		update_imports_on_move = true,
		require_confirmation_on_move = false,
		watch_dir = nil,
	})

	-- required to fix code action ranges and filter diagnostics
	ts_utils.setup_client(client)

	-- no default maps, so you may want to define some here
	local opts = { silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)
end

return M
