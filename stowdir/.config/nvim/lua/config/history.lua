-- ! - save and restore global variables
-- ' - max files to remember marks from
-- / - max search-pattern history entries
-- : - max command-line history entries
-- < - max lines saved per register
-- s - max kbytes per register
-- h - don't restore hlsearch from shada
vim.opt.shada = "!,'500,/5000,:5000,<500,s1000,h"

-- Don't restore cursor position (or anything else) for git commit / rebase
-- buffers, where the cursor should always start at the top.
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("history_disable_for_git", { clear = true }),
    pattern = { "gitcommit", "gitrebase" },
    callback = function()
        vim.opt_local.shada = ""
    end,
})
