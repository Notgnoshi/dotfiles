vim.opt.termguicolors = true

-- Doxygen comment recognition in C/C++. Disable doxygen's own colors so the links below take effect.
vim.g.load_doxygen_syntax = 1
vim.g.doxygen_enhanced_color = 0

local function apply_highlights()
    -- Comment / String style.
    vim.api.nvim_set_hl(0, "Comment", { italic = true, fg = "#767676" })
    vim.api.nvim_set_hl(0, "String", { italic = true })

    -- Match-paren and selection.
    vim.api.nvim_set_hl(0, "MatchParen", { fg = "#000000", bg = "#008080" })
    -- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3a3a3a" })
    -- vim.api.nvim_set_hl(0, "Visual", { bg = "#3a3a3a" })

    -- Spell suggestions.
    vim.api.nvim_set_hl(0, "SpellBad", { fg = "#000000", bg = "#800000" })
    vim.api.nvim_set_hl(0, "SpellRare", { fg = "#808080", bg = "#808000" })
    vim.api.nvim_set_hl(0, "SpellCap", { fg = "#808080", bg = "#008000" })
    vim.api.nvim_set_hl(0, "SpellLocal", { fg = "#808080" })

    -- Copilot ghost text.
    vim.api.nvim_set_hl(0, "CopilotSuggestion", { italic = true, fg = "#808000" })

    -- Custom doxygen comment style; link doxygen captures to it.
    vim.api.nvim_set_hl(0, "CustomDoxyComment", { italic = true, fg = "#767676" })
    vim.api.nvim_set_hl(0, "doxygenComment", { link = "CustomDoxyComment" })
    vim.api.nvim_set_hl(0, "doxygenBrief", { link = "CustomDoxyComment" })
    vim.api.nvim_set_hl(0, "doxygenSpecialOnelineDesc", { link = "CustomDoxyComment" })
    vim.api.nvim_set_hl(0, "doxygenCommentL", { link = "SpecialComment" })
    vim.api.nvim_set_hl(0, "doxygenSpecialTypeOnelineDesc", { link = "SpecialComment" })
    vim.api.nvim_set_hl(0, "doxygenSpecialHeading", { link = "SpecialComment" })

    -- Telescope panels follow the active theme's float colors instead of kanagawa's transparent override.
    vim.api.nvim_set_hl(0, "TelescopeNormal", { link = "NormalFloat" })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "TelescopePromptNormal", { link = "NormalFloat" })
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { link = "NormalFloat" })
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { link = "NormalFloat" })
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { link = "FloatBorder" })

    -- Unified TODO/FIXME/etc. highlight.
    vim.api.nvim_set_hl(0, "MyTodo", { link = "SpellRare" })
    vim.api.nvim_set_hl(0, "Todo", { link = "MyTodo" })
    -- Treesitter captures for languages with @comment.* support.
    vim.api.nvim_set_hl(0, "@comment.todo", { link = "MyTodo" })
    vim.api.nvim_set_hl(0, "@comment.note", { link = "MyTodo" })
    vim.api.nvim_set_hl(0, "@comment.warning", { link = "MyTodo" })
    vim.api.nvim_set_hl(0, "@comment.error", { link = "MyTodo" })

    -- Strip backgrounds so terminal opacity passes through; preserve fg on each group
    local transparent = {
        "CursorLineNr",
        "DiagnosticSignError",
        "DiagnosticSignHint",
        "DiagnosticSignInfo",
        "DiagnosticSignOk",
        "DiagnosticSignWarn",
        "EndOfBuffer",
        "GitSignsAdd",
        "GitSignsChange",
        "GitSignsChangedelete",
        "GitSignsDelete",
        "GitSignsTopdelete",
        "GitSignsUntracked",
        "LineNr",
        "Normal",
        "NormalNC",
        "Pmenu",
        "PmenuSbar",
        "PmenuThumb",
        "SignColumn",
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",
        "TabLineSel",
        "VertSplit",
        "WinSeparator",
    }
    for _, group in ipairs(transparent) do
        local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
        hl.bg = "none"
        hl.ctermbg = "none"
        vim.api.nvim_set_hl(0, group, hl)
    end
end

-- Reapply on ColorScheme so theme switches don't clobber our overrides.
vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("custom_highlights", { clear = true }),
    callback = apply_highlights,
})
