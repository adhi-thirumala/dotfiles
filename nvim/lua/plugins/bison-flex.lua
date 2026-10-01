return {
    "adhi-thirumala/bison-flex.nvim",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter", branch = "main" },
    },
    config = function()
        require("bison-flex").setup({
            server_path = vim.fn.expand("~/bison-flex-lang/dist/server/server.js"),
            lsp = {
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            },
        })
    end,
}
