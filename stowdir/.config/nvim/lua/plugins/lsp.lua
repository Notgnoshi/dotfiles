return {
    {
        "williamboman/mason.nvim",
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        event = "VeryLazy",
        config = function()
            local function find_formatter_xml(start_dir)
                local home = vim.uv.os_homedir()
                local dir = start_dir
                while dir and dir ~= "" and dir ~= "/" do
                    local xml = dir .. "/eclipse-formatter.xml"
                    if vim.uv.fs_stat(xml) then
                        return xml
                    end
                    if vim.uv.fs_stat(dir .. "/.git") then
                        return nil
                    end
                    if dir == home then
                        return nil
                    end
                    local parent = vim.fs.dirname(dir)
                    if parent == dir then
                        return nil
                    end
                    dir = parent
                end
                return nil
            end

            local function first_profile_name(xml_path)
                local f = io.open(xml_path, "r")
                if not f then
                    return nil
                end
                local content = f:read("*a")
                f:close()
                return content:match('<profile[^>]+name="([^"]+)"')
            end

            vim.lsp.config("clangd", {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--header-insertion=iwyu",
                    "--pch-storage=memory",
                    "--completion-style=bundled",
                    "--query-driver=/opt/**/clang++,/tmp/**/*-linux-*,/opt/**/*-linux-*,/usr/bin/c++,/usr/bin/cc,/usr/bin/gcc,/usr/bin/g++",
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
            vim.lsp.config("basedpyright", {
                settings = {
                    basedpyright = {
                        analysis = {
                            diagnosticSeverityOverrides = {
                                reportAny = false,
                                reportExplicitAny = false,
                                reportUnknownArgumentType = false,
                                reportUnknownLambdaType = false,
                                reportUnknownMemberType = false,
                                reportUnknownParameterType = false,
                                reportUnknownVariableType = false,
                                reportUnusedCallResult = false,
                            },
                        },
                    },
                },
            })
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "basedpyright",
                    "bashls",
                    "clangd",
                    "jdtls",
                    "lua_ls",
                    "neocmake",
                    "ruff",
                },
            })

            vim.lsp.enable({
                "basedpyright",
                "bashls",
                "clangd",
                "jdtls",
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
                        map(
                            { "n", "i" },
                            "<F4>",
                            "<cmd>LspClangdSwitchSourceHeader<cr>",
                            "Switch source/header"
                        )
                    end
                    if client and client.name == "jdtls" then
                        map({ "n", "i" }, "<F1>", function()
                            client:request("workspace/executeCommand", {
                                command = "java.edit.organizeImports",
                                arguments = { vim.uri_from_bufnr(buf) },
                            }, function(err, edit)
                                if not err and edit then
                                    vim.lsp.util.apply_workspace_edit(
                                        edit,
                                        client.offset_encoding or "utf-16"
                                    )
                                end
                                vim.lsp.buf.format({ async = false, bufnr = buf })
                            end, buf)
                        end, "Organize imports + format")

                        local xml = find_formatter_xml(client.root_dir)
                        if xml then
                            local profile = first_profile_name(xml)
                            client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
                                java = {
                                    format = {
                                        settings = {
                                            url = "file://" .. xml,
                                            profile = profile,
                                        },
                                    },
                                },
                            })
                            client:notify(
                                "workspace/didChangeConfiguration",
                                { settings = client.settings }
                            )
                        end
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
