vim.filetype.add({
    extension = { nginx = "nginx" },
    filename = { ["nginx.conf"] = "nginx" },
    pattern = {
        [".*/etc/nginx/.*"] = "nginx",
        [".*/usr/local/nginx/conf/.*"] = "nginx",
        [".*/nginx/.*%.conf"] = "nginx",
        [".*%.env"] = "sh",
        [".*%.env%..*"] = "sh",
    },
})

local group = vim.api.nvim_create_augroup("filetype_overrides", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "yaml",
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "c", "cpp" },
    callback = function()
        vim.opt_local.comments:prepend(":///,://!")
        vim.opt_local.commentstring = "// %s"
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "nginx", "qmake" },
    callback = function()
        vim.opt_local.commentstring = "# %s"
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "rust",
    callback = function()
        vim.g.termdebugger = "rust-gdb"
    end,
})
