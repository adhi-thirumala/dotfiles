return {
  "ficcdaf/ashen.nvim",
  lazy = false,
  priority = 1000,
  opts = {
  },
  config = function(_, opts)
    require("ashen").setup(opts)
    vim.cmd('colorscheme ashen')
  end,
}
