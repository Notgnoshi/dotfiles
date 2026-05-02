-- Quit nvim if quickfix or netrw is the only remaining window.
vim.api.nvim_create_autocmd("WinEnter", {
    group = vim.api.nvim_create_augroup("windowing_exit_if_last", { clear = true }),
    callback = function()
        if vim.fn.winnr("$") ~= 1 then return end
        if vim.bo.buftype == "quickfix" then
            vim.bo.buftype = "nofile"
            vim.cmd("quit")
        elseif vim.bo.filetype == "netrw" then
            vim.cmd("quit")
        end
    end,
})
