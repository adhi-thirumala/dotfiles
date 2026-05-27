local options = vim.o
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
