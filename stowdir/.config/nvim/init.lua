vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- Auto-load every lua/config/*.lua module in alphabetical order
for _, path in ipairs(vim.api.nvim_get_runtime_file("lua/config/*.lua", true)) do
    require("config." .. path:match("lua/config/(.+)%.lua$"))
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
        }, true, {})
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = { { import = "plugins" } },
    checker = { enabled = true, notify = false },
    ui = { border = "single" },
})
