return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "basedpyright",
                    "bashls",
                    "clangd",
                    "lua_ls",
                    "neocmake",
                    "ruff",
                },
            })

            vim.lsp.config("clangd", {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--header-insertion=iwyu",
                    "--pch-storage=memory",
                    "--completion-style=bundled",
                    "--query-driver=/opt/**/*-linux-*,/usr/bin/c++,/usr/bin/cc,/usr/bin/gcc,/usr/bin/g++",
                    "-j=4",
                    "--clang-tidy",
                },
            })
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
            })
            vim.lsp.config("rust_analyzer", {
                settings = {
                    ["rust-analyzer"] = {
                        cargo = { cfgs = { "test" }, features = "all" },
                        procMacro = { enable = true },
                        check = { command = "clippy" },
                        diagnostics = { disabled = { "unresolved-proc-macro" } },
                    },
                },
            })
            vim.lsp.enable({
                "basedpyright",
                "bashls",
                "clangd",
                "lua_ls",
                "neocmake",
                "ruff",
                "rust_analyzer",
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
                callback = function(args)
                    local buf = args.buf
                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
                    end
                    map("n", "gd", vim.lsp.buf.definition, "LSP definition")
                    map("n", "gD", vim.lsp.buf.type_definition, "LSP type definition")
                    map("n", "gh", vim.lsp.buf.hover, "LSP hover")
                    map({ "n", "i" }, "<F2>", vim.lsp.buf.rename, "LSP rename")
                    map({ "n", "i" }, "<F3>", function()
                        require("telescope.builtin").lsp_references()
                    end, "LSP references")
                    map("n", "]p", function()
                        vim.diagnostic.jump({ count = 1 })
                    end, "Next diagnostic")
                    map("n", "[p", function()
                        vim.diagnostic.jump({ count = -1 })
                    end, "Prev diagnostic")

                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client and client.name == "clangd" then
                        map({ "n", "i" }, "<F4>", "<cmd>LspClangdSwitchSourceHeader<cr>", "Switch source/header")
                    end
                end,
            })
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                "clang-format",
                "cmakelang",
                "gitlint",
                "hadolint",
                "prettier",
                "stylua",
            },
        },
    },
}
