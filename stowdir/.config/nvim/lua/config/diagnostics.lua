vim.diagnostic.config({
    virtual_text = { current_line = true },
    severity_sort = true,
    float = { border = "rounded", source = true },
})

vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
