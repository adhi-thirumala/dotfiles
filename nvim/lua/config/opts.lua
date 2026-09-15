local options = vim.o

local home = vim.env.HOME
if home and vim.env.SSH_CONNECTION then
    vim.env.PATH = table.concat({
        home .. "/.local/bin",
        home .. "/.cargo/bin",
        vim.env.PATH or "",
    }, ":")
end
options.number = true
options.relativenumber = true
options.undofile = true
options.expandtab = true
options.smartindent = true
options.tabstop = 4
options.shiftwidth = 4
vim.opt.termguicolors = true
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

vim.diagnostic.config({
    virtual_text = false,
})
