-- Bootstrap lazy.nvim
--
vim.g.augment_workspace_folders = { '/home/adhi/tabsort', '/home/adhi/honors-cs128' }
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
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.cmd('set number')
vim.cmd('set rnu')
-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  install = { colorscheme = { "ashen" } },
  -- colorscheme that will be used when installing plugins.
  -- automatically check for plugin updates
  checker = { enabled = true },
})
local function check_completion_blacklist()
  local current_dir = vim.fn.getcwd()
  local blocked_folders = {
    -- Add your folders here, for example:
    "/home/adhi/school", -- uncomment and modify as needed
  }

  for _, folder in ipairs(blocked_folders) do
    if vim.startswith(current_dir, folder) then
      vim.g.augment_disable_completions = true
      return
    end
  end

  vim.g.augment_disable_completions = false
end

-- Set up an autocommand to check when changing directories
vim.api.nvim_create_autocmd({ "DirChanged" }, {
  callback = function()
    check_completion_blacklist()
  end,
})


-- Run the check when Neovim starts
check_completion_blacklist()
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
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,

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
require("mason").setup()
require("mason-lspconfig").setup()
local cmp = require 'cmp'
require 'cmp'.setup {
  sources = {
    { name = 'nvim_lsp' }
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
}
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
-- make tab length two spaces for all lsp servers
local o = vim.o

o.expandtab = true
o.smartindent = true
o.tabstop = 2
o.shiftwidth = 2
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require 'lspconfig'.pyright.setup {
  capabilities = capabilities
}
require 'lspconfig'.texlab.setup {
  capabilities = capabilities
}
require 'lspconfig'.lua_ls.setup {
  capabilities = capabilities
}
require 'lspconfig'.yamlls.setup {
  capabilities = capabilities
}
require 'lspconfig'.ltex.setup {
  capabilities = capabilities
}
require 'lspconfig'.ts_ls.setup {
  capabilities = capabilities
}
require 'lspconfig'.bashls.setup {
  capabilities = capabilities
}
require 'lspconfig'.eslint.setup {
  capabilities = capabilities
}
require 'lspconfig'.autotools_ls.setup {
  capabilities = capabilities
}
require 'lspconfig'.rust_analyzer.setup {
  capabilities = capabilities
}
local on_attach_ocaml = function(client, bufnr)
  -- Enable formatting on save
  require("lsp-format").on_attach(client, bufnr)

  -- Add any OCaml-specific keymaps or settings here
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
end

require('lspconfig').ocamllsp.setup {
  capabilities = capabilities,
  on_attach = on_attach_ocaml,
  filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" }
}
require 'lspconfig'.gopls.setup {
  capabilities = capabilities,
}
require("lsp-format").setup {}

require("lspconfig").pyright.setup { on_attach = require("lsp-format").on_attach }
require("lspconfig").texlab.setup { on_attach = require("lsp-format").on_attach }
require("lspconfig").lua_ls.setup { on_attach = require("lsp-format").on_attach }
require("lspconfig").yamlls.setup { on_attach = require("lsp-format").on_attach }
require("lspconfig").rust_analyzer.setup { on_attach = require("lsp-format").on_attach }
require("lspconfig").bashls.setup { on_attach = require("lsp-format").on_attach }

require 'lspconfig'.clangd.setup {
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=Google"
  },
  on_attach = require("lsp-format").on_attach
}
require("lspconfig").html.setup { on_attach = require("lsp-format").on_attach }
require("lspconfig").ltex.setup { on_attach = require("lsp-format").on_attach }
require("lspconfig").gopls.setup { on_attach = require("lsp-format").on_attach }
require("lspconfig").eslint.setup { on_attach = require("lsp-format").on_attach }
require("lspconfig").autotools_ls.setup { on_attach = require("lsp-format").on_attach }




-- formatter.nvim config that uses default LSP to format on save and uses 2 spces instead of tabs
local builtin = require('telescope.builtin')
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
vim.api.nvim_set_keymap('n', '<C-A-Space>', '<cmd>lua require("telescope.builtin").find_files()<CR>',
  { noremap = true, silent = true })
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


-- ai section

vim.opt.termguicolors = true
require("bufferline").setup {}
require('tcss').setup()
vim.api.nvim_set_keymap('n', '<A-Tab>', '<cmd>lua require("telescope.builtin").buffers()<CR>',
  { noremap = true, silent = true })
require('nvim-autopairs').setup()
cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
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
vim.api.nvim_set_keymap('n', '<C-A-d>', ':Augment chat-toggle<CR>', { noremap = true, silent = true })
-- make a keybind tojump to line  1e79ac5c-96fd-4a32-88d5-a01ebb30f0ae


vim.api.nvim_set_keymap('n', '<C-A-m>', ':Augment chat<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-A-]>',
  ':lua vim.g.augment_disable_completions = not vim.g.augment_disable_completions<CR>',
  { noremap = true, silent = true })
