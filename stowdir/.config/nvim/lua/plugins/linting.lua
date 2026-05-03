return {
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufWritePost", "InsertLeave" },
        config = function()
            require("lint").linters_by_ft = {
                dockerfile = { "hadolint" },
                gitcommit = { "gitlint" },
            }

            vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
                group = vim.api.nvim_create_augroup("nvim_lint_trigger", { clear = true }),
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
}
