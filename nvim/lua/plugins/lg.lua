local lazygit_tab_count

local function configure_lazygit()
    local override_path = vim.fn.stdpath("cache") .. "/lazygit-nvim.yml"
    vim.fn.writefile({
        "os:",
        "  editPreset: nvim-remote",
    }, override_path)

    local config_paths = { override_path }
    local default_config = vim.fn.trim(vim.fn.system({ "lazygit", "-cd" })) .. "/config.yml"
    if vim.uv.fs_stat(default_config) then
        table.insert(config_paths, 1, default_config)
    end

    vim.g.lazygit_use_custom_config_file_path = 1
    vim.g.lazygit_config_file_path = config_paths
    vim.env.NVIM = vim.v.servername
    vim.g.lazygit_on_exit_callback = function()
        local tabs = vim.api.nvim_list_tabpages()
        if lazygit_tab_count and #tabs > lazygit_tab_count then
            vim.api.nvim_set_current_tabpage(tabs[#tabs])
        end
        lazygit_tab_count = nil
    end
end

local function open_lazygit()
    lazygit_tab_count = #vim.api.nvim_list_tabpages()
    vim.cmd.LazyGit()
end

return {
    "kdheepak/lazygit.nvim",
    config = configure_lazygit,
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- Plenary provides the floating window.
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    -- Declaring the mapping here lets lazy.nvim load the plugin on demand.
    keys = {
        { "<leader>lg", open_lazygit, desc = "LazyGit" }
    }
}
