return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            theme = "dragon",
            transparent = true,
            dimInactive = true,
            keywordStyle = { italic = false },
            overrides = function(colors)
                return {
                    ["@markup.raw.markdown_inline"] = { fg = colors.palette.carpYellow },
                }
            end,
        },
        config = function(_, opts)
            require("kanagawa").setup(opts)
            vim.cmd.colorscheme("kanagawa-dragon")
        end,
    },
}
