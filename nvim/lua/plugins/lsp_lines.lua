return {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    keys = {
        { "M", function() require("lsp_lines").toggle() end, mode = "n", desc = "Toggle lsp_lines" },
    },
}
