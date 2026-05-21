vim.g.mapleader = " "
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.maplocalleader = "\\"
-- Find ALL files (including gitignored and hidden)
vim.keymap.set('n', '<leader><C-Space>', function()
    require('telescope.builtin').find_files({ no_ignore = true, hidden = true })
end, { desc = 'Find all files (ignore gitignore)' })
