return {
    {
        "stevearc/conform.nvim",
        cmd = { "ConformInfo" },
        keys = {
            {
                "<F1>",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = { "n", "i" },
                desc = "Format buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                c = { "clang-format" },
                cmake = { "cmake_format" },
                cpp = { "clang-format" },
                css = { "prettier" },
                html = { "prettier" },
                java = { lsp_format = "prefer" },
                javascript = { "prettier" },
                json = { "jq" },
                lua = { "stylua" },
                markdown = { "dprint" },
                python = { "ruff_format" },
                rust = { "rustfmt" },
                sh = { "shfmt" },
                toml = { "dprint" },
                ["_"] = { "trim_whitespace", "trim_newlines" },
            },
            formatters = {
                jq = { prepend_args = { "--indent", "4" } },
                prettier = {
                    prepend_args = {
                        "--print-width",
                        "120",
                        "--prose-wrap",
                        "always",
                        "--tab-width",
                        "4",
                        "--html-whitespace-sensitivity",
                        "css",
                    },
                },
                ruff_format = { prepend_args = { "--line-length=100" } },
                shfmt = { prepend_args = { "--indent", "4" } },
            },
        },
    },
}
