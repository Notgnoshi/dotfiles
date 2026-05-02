vim.opt.foldlevelstart = 15
vim.opt.foldnestmax = 10
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.keymap.set("n", "<space>", "za")
