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
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.cmd('set number')
vim.cmd('set rnu')
-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- automatically check for plugin updates
  checker = { enabled = true },
})
require("ashen").setup()
vim.cmd('colorscheme ashen')


-- theme styles
local virtual_env = function()
  -- only show virtual env for Python
  if vim.bo.filetype ~= 'python' then
    return ""
  end

  local conda_env = os.getenv('CONDA_DEFAULT_ENV')
  local venv_path = os.getenv('VIRTUAL_ENV')

  if venv_path == nil then
    if conda_env == nil then
      return ""
    else
      return string.format("  %s (conda)", conda_env)
    end
  else
    local venv_name = vim.fn.fnamemodify(venv_path, ':t')
    return string.format("  %s (venv)", venv_name)
  end
end
-- python venv status line for lualine

-- lualine
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
    lualine_x = { 'encoding', 'fileformat', 'filetype', 'virtual_env' },
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
-- profile escalation
vim.cmd('cmap w!! w !sudo tee "%"')
-- nvim-tree
--
--
require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn", -- set to `false` to disable one of the mappings
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
-- make tab length two spaces for all lsp servers
local options = vim.o
options.expandtab = true
options.smartindent = true
options.tabstop = 4
options.shiftwidth = 4









vim.keymap.set('n', '<Leader>f', vim.lsp.buf.format, { desc = 'Format buffer' })


-- formatter.nvim config that uses default LSP to format on save and uses 2 spces instead of tabs
require('telescope').setup {
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
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
  -- Also override individual filetype configs, these take priority.
  -- Empty by default, useful if one of the "opts" global settings
  -- doesn't work well in a specific filetype
})
-- If you want insert `(` after select function or method item
-- sdf



-- ai section

vim.opt.termguicolors = true
require("bufferline").setup {}
require('tcss').setup()
vim.api.nvim_set_keymap('n', '<A-Tab>', '<cmd>lua require("telescope.builtin").buffers()<CR>',
  { noremap = true, silent = true })
vim.diagnostic.config({
  virtual_text = false,
})
vim.keymap.set(
  "n",
  "M",
  require("lsp_lines").toggle,
  { desc = "Toggle lsp_lines" }
)
vim.api.nvim_set_keymap('n', '<A-Space>', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
-- add ctrl ald d to toggle a new augment chat and to make me start a message - its :Augment toggle-chat and :Augment start-message
-- nnoremap <leader>ac :Augment chat<CR>
--vnoremap <leader>ac :Augment chat<CR>
--nnoremap <leader>an :Augment chat-new<CR>
-- nnoremap <leader>at :Augment chat-toggle<CR>
-- change to nvim from vim
-- bing ctrl alt d to doing :augment chat-toggle
-- make a keybind tojump to line  1e79ac5c-96fd-4a32-88d5-a01ebb30f0ae




--toggle terminal
require("toggleterm").setup()
