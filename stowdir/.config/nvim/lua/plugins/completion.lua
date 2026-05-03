return {
    {
        "saghen/blink.cmp",
        version = "1.*",
        dependencies = { "L3MON4D3/LuaSnip" },
        opts = {
            snippets = { preset = "luasnip" },
            keymap = {
                preset = "enter",
                ["<Tab>"] = {
                    function()
                        local ok, copilot = pcall(require, "copilot.suggestion")
                        if ok and copilot.is_visible() then
                            copilot.accept()
                            return true
                        end
                    end,
                    "snippet_forward",
                    "fallback",
                },
            },
            sources = {
                default = { "buffer", "lsp", "path", "snippets" },
            },
            signature = { enabled = true },
            appearance = {
                kind_icons = {
                    Class         = "◇",
                    Color         = "●",
                    Constant      = "π",
                    Constructor   = "⊕",
                    Enum          = "≡",
                    EnumMember    = "·",
                    Event         = "!",
                    Field         = "·",
                    File          = "▤",
                    Folder        = "▥",
                    Function      = "ƒ",
                    Interface     = "◈",
                    Keyword       = "★",
                    Method        = "ƒ",
                    Module        = "▦",
                    Operator      = "⊕",
                    Property      = "◦",
                    Reference     = "→",
                    Snippet       = "◊",
                    Struct        = "◆",
                    Text          = "T",
                    TypeParameter = "τ",
                    Unit          = "⊡",
                    Value         = "◉",
                    Variable      = "ν",
                },
            },
            completion = {
                menu = {
                    draw = {
                        columns = {
                            { "kind_icon" },
                            { "label", "label_description", gap = 1 },
                            { "kind" },
                        },
                    },
                },
            },
        },
    },
}
