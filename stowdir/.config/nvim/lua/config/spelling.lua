vim.opt.spelllang = "en_us"
vim.opt.spelloptions = "camel"
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

local spell_dir = vim.fn.stdpath("config") .. "/spell"
if vim.fn.isdirectory(spell_dir) == 0 then
    vim.fn.mkdir(spell_dir, "p")
end

vim.keymap.set({ "n", "i" }, "<F7>", "<cmd>setlocal spell! spell?<cr>")

-- Recompile *.spl from *.add when the source is newer (keeps binary .spl file out of git).
local function setup_spellfile()
    for _, add in ipairs(vim.fn.glob(spell_dir .. "/*.add", true, true)) do
        local spl = add .. ".spl"
        if
            vim.fn.filereadable(add) == 1
            and (vim.fn.filereadable(spl) == 0 or vim.fn.getftime(add) > vim.fn.getftime(spl))
        then
            vim.cmd("silent mkspell! " .. vim.fn.fnameescape(add))
        end
    end
end

-- Sort/dedupe *.add on exit so the file is diff-friendly. Only write if the
-- result differs from the current contents, otherwise mtime updates would
-- confuse git rebases.
local function sort_spellfile()
    for _, add in ipairs(vim.fn.glob(spell_dir .. "/*.add", true, true)) do
        local current = vim.fn.readfile(add)
        local sorted = vim.fn.systemlist({ "sort", "--unique", add })
        if not vim.deep_equal(current, sorted) then
            vim.fn.writefile(sorted, add)
        end
    end
end

vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("spellfile_compile", { clear = true }),
    callback = setup_spellfile,
})
vim.api.nvim_create_autocmd("VimLeave", {
    group = vim.api.nvim_create_augroup("spellfile_sort", { clear = true }),
    callback = sort_spellfile,
})
