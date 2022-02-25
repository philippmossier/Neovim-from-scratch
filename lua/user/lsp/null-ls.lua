local null_ls_status_ok, null_ls = pcall(require, "null-ls")

if not null_ls_status_ok then
    return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

-- used for async formatting https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Async-formatting
_G.formatting = function(bufnr)
    bufnr = tonumber(bufnr) or vim.api.nvim_get_current_buf()

    vim.lsp.buf_request(
        bufnr,
        "textDocument/formatting",
        {textDocument = {uri = vim.uri_from_bufnr(bufnr)}},
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

                vim.api.nvim_buf_call(
                    bufnr,
                    function()
                        vim.cmd("silent noautocmd update")
                    end
                )
            end
        end
    )
end

null_ls.setup(
    {
        debug = false,
        sources = {
            -- formatting.stylua,
            diagnostics.eslint_d,
            formatting.eslint_d,
            -- formatting.prettier,
            -- formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }), -- only use if no local prettiertc or eslintrc
            -- formatting.black.with({ extra_args = { "--fast" } }), -- not sure what this does
            -- diagnostics.flake8
        },
        -- format on save (sync) but i think this saves all buffers not only one https://github.com/jose-elias-alvarez/null-ls.nvim
        on_attach = function(client)
            if client.resolved_capabilities.document_formatting then
                vim.cmd(
                    [[
            augroup LspFormatting
              autocmd! * <buffer>
              autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync() 
            augroup END
            ]]
                )
            end
        end

        -- format on save (sync)
        -- on_attach = function(client)
        --     if client.resolved_capabilities.document_formatting then
        --         vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 3000)")
        --     end
        -- end,

        -- format on save (async) more performant but does not format on :wq
        --     on_attach = function(client, bufnr)
        --         if client.supports_method("textDocument/formatting") then
        --             -- wrap in an augroup to prevent duplicate autocmds
        --             vim.cmd(
        --                 [[
        --         augroup LspFormatting
        --             autocmd! * <buffer>
        --             autocmd BufWritePost <buffer> lua formatting(vim.fn.expand("<abuf>"))
        --         augroup END
        --
        --         ]]
        --             )
        --         end
        --     end
    }

)
