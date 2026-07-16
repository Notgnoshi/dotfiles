local parsers = {
    "bash",
    "bitbake",
    "c",
    "cmake",
    "cpp",
    "css",
    "diff",
    "dockerfile",
    "gitcommit",
    "gitignore",
    "html",
    "htmldjango",
    "java",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "proto",
    "python",
    "rust",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
}

local filetypes = {
    "bash",
    "bitbake",
    "c",
    "cmake",
    "cpp",
    "css",
    "diff",
    "dockerfile",
    "gitcommit",
    "gitignore",
    "help",
    "html",
    "htmldjango",
    "java",
    "javascript",
    "json",
    "lua",
    "markdown",
    "proto",
    "python",
    "rust",
    "sh",
    "toml",
    "typescript",
    "typescriptreact",
    "vim",
    "xml",
    "yaml",
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").install(parsers)

            vim.api.nvim_create_autocmd("FileType", {
                pattern = filetypes,
                callback = function()
                    vim.treesitter.start()
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = { lookahead = true },
                move = { set_jumps = true },
            })

            local select = require("nvim-treesitter-textobjects.select").select_textobject
            local move = require("nvim-treesitter-textobjects.move")

            vim.keymap.set({ "x", "o" }, "ac", function() select("@comment.outer", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "ic", function() select("@comment.outer", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "af", function() select("@function.outer", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "if", function() select("@function.inner", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "aC", function() select("@class.outer", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "iC", function() select("@class.inner", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "aa", function() select("@parameter.outer", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "ia", function() select("@parameter.inner", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "ao", function() select("@conditional.outer", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "io", function() select("@conditional.inner", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "al", function() select("@loop.outer", "textobjects") end)
            vim.keymap.set({ "x", "o" }, "il", function() select("@loop.inner", "textobjects") end)

            vim.keymap.set({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "]]", function() move.goto_next_start("@class.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.inner", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "]l", function() move.goto_next_start("@loop.outer", "textobjects") end)

            vim.keymap.set({ "n", "x", "o" }, "]M", function() move.goto_next_end("@function.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "][", function() move.goto_next_end("@class.outer", "textobjects") end)

            vim.keymap.set({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[[", function() move.goto_previous_start("@class.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.inner", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[l", function() move.goto_previous_start("@loop.outer", "textobjects") end)

            vim.keymap.set({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@function.outer", "textobjects") end)
            vim.keymap.set({ "n", "x", "o" }, "[]", function() move.goto_previous_end("@class.outer", "textobjects") end)
        end,
    },
}
