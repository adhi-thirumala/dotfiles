-- Directories where Codeium should be disabled
local disabled_dirs = {
    "~/school",
    "~/writing-a-c-compiler-sandler-rs"
}

local function check_and_disable_codeium()
    local cwd = vim.fn.getcwd()

    for _, dir in ipairs(disabled_dirs) do
        local expanded_dir = vim.fn.expand(dir)
        if cwd:find(expanded_dir, 1, true) then
            vim.cmd("CodeiumDisable")
            break
        end
    end
end

-- Run check on startup
check_and_disable_codeium()

-- Also check when directory changes
vim.api.nvim_create_autocmd("DirChanged", {
    callback = check_and_disable_codeium,
})
