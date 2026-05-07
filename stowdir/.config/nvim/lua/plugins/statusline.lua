return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = {
            options = {
                icons_enabled = false,
                theme = "ayu_dark",
                component_separators = { left = "|", right = "|" },
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    "branch",
                    "diff",
                    {
                        "diagnostics",
                        symbols = { error = "✗ ", warn = "⚠ ", info = "ⓘ ", hint = "? " },
                    },
                },
                lualine_c = { "filename" },
                lualine_x = { vim.lsp.status, "encoding", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        },
        init = function()
            -- lualine shows the mode; nvim's default echo-area mode line is redundant.
            vim.opt.showmode = false
        end,
    },
}
