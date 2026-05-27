local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        if client:supports_method('textDocument/definition') then
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf })
        end

        if client:supports_method('textDocument/implementation') then
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = args.buf })
        end

        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end
    end,
})

vim.keymap.set('n', '<Leader>f', vim.lsp.buf.format, { desc = 'Format buffer' })
vim.keymap.set('n', 'g.', vim.lsp.buf.code_action, { desc = 'Code action' })
vim.keymap.set('n', '<leader>k', '<Cmd>Telescope diagnostics<CR>', { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>m', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = 'Toggle LSP Inlay Hints' })

vim.lsp.config["lua_ls"] = {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
    capabilities = capabilities,
}

vim.lsp.config('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                enable = true,
            },
        },
    },
    capabilities = capabilities,
})

vim.lsp.config('ocamllsp', {
    capabilities = capabilities,
})

vim.filetype.add({
    extension = {
        mli = 'ocamlinterface',
        mll = 'ocamllex',
        mly = 'menhir',
        re = 'reason',
        rei = 'reason',
    },
})

vim.lsp.config('oxlint', {
    cmd = { 'oxlint', '--lsp' },
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_markers = { 'oxlint.config.json', '.oxlintrc.json', 'package.json', '.git' },
    capabilities = capabilities,
})

vim.lsp.config('vtsls', {
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
})

vim.lsp.enable('ty')
vim.lsp.enable('ruff')
vim.lsp.enable('lua_ls')
vim.lsp.enable('vtsls')
vim.lsp.enable('typst_lsp')
vim.lsp.enable('clangd')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('tinymist')
vim.lsp.enable('svelte')
vim.lsp.enable('ocamllsp')
vim.lsp.enable('oxlint')
vim.lsp.enable('oxfmt')
vim.lsp.enable('hls')
vim.lsp.enable('gopls')
