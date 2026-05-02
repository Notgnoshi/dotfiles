vim.opt.autowrite = true
vim.opt.updatetime = 1000

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = vim.api.nvim_create_augroup("filewatching_checktime", { clear = true }),
    command = "checktime",
})
