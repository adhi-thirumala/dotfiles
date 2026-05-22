-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    checker = { enabled = true },
})
require("ashen").setup()
vim.cmd('colorscheme ashen')
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}
require 'colorizer'.setup {
    '*',                      -- Highlight all files, but customize some others.
    css = { rgb_fn = true, }, -- Enable parsing rgb(...) functions in css.
    html = { names = false, } -- Disable parsing "names" like Blue or Gray
}
require('telescope').setup {
    pickers = {
    },
    extensions = {
    }
}

-- map ctrl alt space to telescope
vim.keymap.set('n', '<Leader><Leader>', require('telescope.builtin').find_files, { desc = 'Find Files' })
vim.api.nvim_set_keymap('n', '<C-A-b>', '<cmd>lua require("telescope.builtin").buffers()<CR>',
    { noremap = true, silent = true })

require('ibl').setup()


require('nvim-ts-autotag').setup({
    opts = {
        -- Defaults
        enable_close = true,          -- Auto close tags
        enable_rename = true,         -- Auto rename pairs of tags
        enable_close_on_slash = false -- Auto close on trailing </
    },
})



require("bufferline").setup {}
require('tcss').setup()
vim.keymap.set(
    "",
    "<Leader>l",
    require("lsp_lines").toggle,
    { desc = "Toggle lsp_lines" }
)
