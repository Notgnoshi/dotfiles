vim.opt.autowrite = true
vim.opt.updatetime = 1000

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
    group = vim.api.nvim_create_augroup("filewatching_checktime", { clear = true }),
    command = "checktime",
})

local checktime_timer = vim.uv.new_timer()
checktime_timer:start(2000, 2000, vim.schedule_wrap(function()
    if vim.fn.getcmdwintype() == "" then
        vim.cmd("checktime")
    end
end))
