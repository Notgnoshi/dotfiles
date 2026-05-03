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
}
