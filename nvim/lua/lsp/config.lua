--lspattach function
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
        -- Completion is handled by nvim-cmp + cmp-nvim-lsp, so we do NOT
        -- enable the native vim.lsp.completion here (they conflict).
        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
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

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

local cmp = require 'cmp'

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

            -- For `mini.snippets` users:
            -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
            -- insert({ body = args.body }) -- Insert at cursor
            -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
            -- require("cmp.config").set_onetime({ sources = {} })
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
    }),
    matching = {
        disallow_symbol_nonprefix_matching = false,
    },
    sorting = {
        priority_weight = 2,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        }
    }
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]] --

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- code actions to g .
vim.keymap.set('n', 'g.', function()
    return '<Cmd>lua vim.lsp.buf.code_action()<CR>'
end, { expr = true })

vim.keymap.set('n', "<leader>k", function()
    return '<Cmd>Telescope diagnostics<CR>'
end, { expr = true })

vim.keymap.set("n", "<leader>m", function()
    -- Toggles inlay hints for the current buffer
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Toggle LSP Inlay Hints" })






-- server specific configs past defaults

vim.lsp.config["lua_ls"] = {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }, -- make it so that the global vim not found thing doesnt happen
            },
        }
    },
    capabilities = capabilities
}

vim.lsp.config('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                enable = true,
            }
        }
    },
    capabilities = capabilities
})


vim.lsp.config('ocamllsp', {
    capabilities = capabilities
})

-- Register filetypes that Neovim doesn't detect by default (needed for ocamllsp)
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

--enable everything
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
