return {
    "amitds1997/remote-nvim.nvim",
    version = "*",                       -- Pin to GitHub releases
    dependencies = {
        "nvim-lua/plenary.nvim",         -- For standard functions
        "MunifTanjim/nui.nvim",          -- To build the plugin UI
        "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    },
    opts = {
        client_callback = function(port, _)
            vim.fn.jobstart({
                "kitty",
                "--detach",
                "nvim",
                "--server",
                ("localhost:%s"):format(port),
                "--remote-ui",
            }, {
                detach = true,
            })
        end,
    },
    keys = {
        {
            "<leader>r",
            "<cmd>RemoteStart<CR>",
            desc = "List remote configs"
        }
    },
}
