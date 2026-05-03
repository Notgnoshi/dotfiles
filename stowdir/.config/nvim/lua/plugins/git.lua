return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                local gs = require("gitsigns")
                vim.keymap.set("n", "]c", function() gs.nav_hunk("next") end, { buffer = bufnr, desc = "Next hunk" })
                vim.keymap.set("n", "[c", function() gs.nav_hunk("prev") end, { buffer = bufnr, desc = "Prev hunk" })
            end,
        },
    },
    {
        "tpope/vim-fugitive",
        cmd = { "G", "Git", "Gdiff", "Gdiffsplit", "Gvdiffsplit", "Gblame", "Gread", "Gwrite", "Gedit", "GBrowse" },
    },
}
