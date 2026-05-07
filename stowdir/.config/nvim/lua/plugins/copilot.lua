return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept_word = "<M-Right>",
                    dismiss = "<C-]>",
                },
            },
            panel = { enabled = false },
            filetypes = {
                ["*"] = true,
                text = false,
            },
            should_attach = function(_, source)
                local name = vim.fs.basename(source.bufname or vim.api.nvim_buf_get_name(0))
                local secret_patterns = {
                    "%.env$",
                    "%.env%.",
                    "%.pem$",
                    "%.key$",
                    "^id_rsa",
                    "^id_ed25519",
                    "^id_ecdsa",
                    "credentials",
                }
                for _, pat in ipairs(secret_patterns) do
                    if name:match(pat) then
                        return false
                    end
                end
                return true
            end,
        },
    },
}
