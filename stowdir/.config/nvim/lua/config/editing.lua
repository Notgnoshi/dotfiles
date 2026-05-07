vim.opt.number = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "100"
vim.opt.textwidth = 100
vim.opt.scrolloff = 6
vim.opt.sidescrolloff = 6
vim.opt.virtualedit = "all"
vim.opt.display = "truncate"

vim.opt.lazyredraw = true
vim.opt.showmatch = true

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("editing_gitcommit", { clear = true }),
    pattern = "gitcommit",
    callback = function()
        vim.opt_local.colorcolumn = "72"
    end,
})

-- Reselect visual block after indent.
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move by visual line so wrapped lines feel like arrow-key movement.
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Defeat smartindent's habit of yanking `#` to column 0.
vim.keymap.set("i", "#", "X<BS>#")

-- New empty buffer.
vim.keymap.set("n", "<C-t>", "<cmd>enew<cr>")

-- Buffer and quickfix navigation (replaces vim-unimpaired's ]b/[b/]q/[q).
vim.keymap.set("n", "]b", "<cmd>bnext<cr>")
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>")
vim.keymap.set("n", "]q", "<cmd>cnext<cr>")
vim.keymap.set("n", "[q", "<cmd>cprevious<cr>")

-- :bd / :bd! delete the current buffer but keep the window open by switching to another buffer first.
vim.api.nvim_create_user_command("Bd", function(opts)
    local current = vim.api.nvim_get_current_buf()

    -- Surface "no write since last change" before switching, so the user
    -- stays on the modified buffer rather than ending up on the alternate.
    if not opts.bang and vim.bo[current].modified then
        vim.notify(
            ("E89: No write since last change for buffer %d (use :Bd!)"):format(current),
            vim.log.levels.ERROR
        )
        return
    end

    local has_others = false
    for _, info in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
        if info.bufnr ~= current then
            has_others = true
            break
        end
    end
    if has_others then
        vim.cmd("bprevious")
    else
        vim.cmd("enew")
    end
    vim.cmd(("bdelete%s %d"):format(opts.bang and "!" or "", current))
end, { bang = true })

vim.cmd([[cnoreabbrev <expr> bd getcmdtype() == ':' && getcmdline() == 'bd' ? 'Bd' : 'bdelete']])
