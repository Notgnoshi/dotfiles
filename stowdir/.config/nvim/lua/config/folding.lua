vim.opt.foldlevelstart = 15
vim.opt.foldnestmax = 10
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("folding_fallback", { clear = true }),
    callback = function(args)
        local ok, parser = pcall(vim.treesitter.get_parser, args.buf)
        if not ok or not parser then
            vim.opt_local.foldmethod = "indent"
            vim.opt_local.foldexpr = ""
        end
    end,
})

vim.keymap.set("n", "<space>", "za")
