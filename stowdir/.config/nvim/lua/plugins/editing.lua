return {
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
    {
        "tpope/vim-eunuch",
        cmd = { "Move", "Rename", "Delete", "Chmod", "SudoWrite", "Mkdir", "Wall", "SudoEdit" },
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                char = {
                    jump_labels = false,
                },
                search = { enabled = false },
            },
        },
    },
    {
        "chentoast/marks.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<C-h>", "<cmd>TmuxNavigateLeft<cr>",     desc = "Tmux/win left" },
            { "<C-j>", "<cmd>TmuxNavigateDown<cr>",     desc = "Tmux/win down" },
            { "<C-k>", "<cmd>TmuxNavigateUp<cr>",       desc = "Tmux/win up" },
            { "<C-l>", "<cmd>TmuxNavigateRight<cr>",    desc = "Tmux/win right" },
            { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Tmux/win previous" },
        },
    },
}
