return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        cmd = { "Telescope", "Rg" },
        keys = {
            {
                "<c-f><c-b>",
                function()
                    -- Sort by bufnr to match :bnext / ]b traversal order, and preselect the next
                    -- buffer ]b would jump to (with wrap-around).
                    local current = vim.api.nvim_get_current_buf()
                    local listed = vim.tbl_filter(function(b)
                        return vim.fn.buflisted(b) == 1
                    end, vim.api.nvim_list_bufs())
                    table.sort(listed)
                    local idx = 1
                    for i, b in ipairs(listed) do
                        if b == current then
                            idx = (i % #listed) + 1
                            break
                        end
                    end
                    require("telescope.builtin").buffers({
                        sort_buffers = function(a, b)
                            return a < b
                        end,
                        default_selection_index = idx,
                    })
                end,
                desc = "Telescope buffers",
            },
            {
                "<c-f><c-t>",
                function()
                    require("telescope.builtin").find_files({
                        find_command = {
                            "fd",
                            "--type",
                            "f",
                            "--hidden",
                            "--no-ignore",
                            "--exclude",
                            ".git",
                        },
                    })
                end,
                desc = "Telescope find non-VCS files",
            },
            {
                "<c-f><c-g>",
                function()
                    require("telescope.builtin").find_files({
                        find_command = { "fd", "--type", "f", "--hidden" },
                    })
                end,
                desc = "Telescope find VCS files",
            },
            {
                "<c-f><c-r>",
                "<cmd>Telescope command_history<cr>",
                desc = "Telescope command history",
            },
            {
                "<c-f><c-f>",
                "<cmd>Telescope search_history<cr>",
                desc = "Telescope search history",
            },
            { "<c-f><c-h>", "<cmd>Telescope oldfiles<cr>", desc = "Telescope file history" },
            { "<c-f><c-j>", "<cmd>Telescope jumplist<cr>", desc = "Telescope jumps" },
            { "<c-f><c-m>", "<cmd>Telescope marks<cr>", desc = "Telescope marks" },
        },
        config = function()
            require("telescope").setup({
                pickers = {
                    colorscheme = { enable_preview = true },
                },
            })
            require("telescope").load_extension("fzf")

            vim.api.nvim_create_user_command("Rg", function(opts)
                require("telescope.builtin").live_grep({ default_text = opts.args })
            end, { nargs = "*" })
        end,
    },
    {
        "debugloop/telescope-undo.nvim",
        dependencies = "nvim-telescope/telescope.nvim",
        keys = {
            { "<c-f><c-u>", "<cmd>Telescope undo<cr>", desc = "Telescope undo history" },
        },
        config = function()
            require("telescope").load_extension("undo")
        end,
    },
}
