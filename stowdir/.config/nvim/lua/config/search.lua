vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.grepprg = "rg --vimgrep --smart-case --follow"

vim.keymap.set("n", "<CR>", "<cmd>nohlsearch<cr>", { silent = true })
