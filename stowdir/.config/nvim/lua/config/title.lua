vim.opt.title = true
vim.opt.titlestring = "%{$USER}@%{hostname()}: %F %m"
vim.opt.titleold = ""

vim.api.nvim_create_autocmd("VimLeave", {
    group = vim.api.nvim_create_augroup("title_clear_on_exit", { clear = true }),
    callback = function() vim.opt.title = false end,
})
