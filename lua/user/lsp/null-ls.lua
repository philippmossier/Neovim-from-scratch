-- null-ls DOCS builtins: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md

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
            -- Note: UPDATED 16.6.2022, Try using eslint_d as much as possible because its the fastest
            null_ls.builtins.code_actions.eslint_d, -- requires npm install -g eslint_d
            null_ls.builtins.diagnostics.eslint_d,
            null_ls.builtins.formatting.eslint_d,
            null_ls.builtins.formatting.prettierd.with({ -- requires npm install -g @fsouza/prettierd, not sure if this respects project-based-linter-configs like prettierrc or eslintrc (this is often needed to fix error when using eslint&prettier together)
                env = {
                  PRETTIERD_LOCAL_PRETTIER_ONLY = 1, -- to use prettierd exclusively with the locally installed prettier package 
                -- PRETTIERD_DEFAULT_CONFIG = vim.fn.expand "~/.config/nvim/utils/linter-config/.prettierrc.json",
                },
                -- filetypes = { "css", "scss", "html", "json", "yaml", "markdown", "graphql" },
                -- extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
            }),
            null_ls.builtins.formatting.stylua,
            -- null_ls.builtins.code_actions.gitsigns,
            -- null_ls.builtins.diagnostics.markdownlint,
        },

        -- format on save (sync) but i think this saves all buffers not only one https://github.com/jose-elias-alvarez/null-ls.nvim
        -- format on save UPDATED 16.6.2022
        -- Regarding https://neovim.io/doc/user/lsp.html you can check the current available capabilities with :lua =vim.lsp.get_active_clients()[1].server_capabilities
        on_attach = function(client)
            if client.server_capabilities.documentFormattingProvider then -- client.resolved_capabilities.document_formatting (deprecated)
                vim.cmd(
                    [[
                augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()
                augroup END
                ]]
                )
            end
        end

        -- format on save (sync)
        -- on_attach = function(client)
        --     if client.server_capabilities.documentFormattingProvider then -- resolved_capabilities DEPRECATED (use server_capabilities instead)
        --         vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format(nil, 3000)")
        --     end
        -- end,

        -- format on save (async) more performant but does not format on :wq
            -- on_attach = function(client, bufnr)
            --     if client.supports_method("textDocument/formatting") then
            --         -- wrap in an augroup to prevent duplicate autocmds
            --         vim.cmd(
            --             [[
            --     augroup LspFormatting
            --         autocmd! * <buffer>
            --         autocmd BufWritePost <buffer> lua formatting(vim.fn.expand("<abuf>"))
            --     augroup END
        
            --     ]]
            --         )
            --     end
            -- end
    }

)
