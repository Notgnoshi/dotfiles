vim.opt.termguicolors = false

-- Doxygen comment recognition in C/C++. Disable doxygen's own colors so the links below take effect.
vim.g.load_doxygen_syntax = 1
vim.g.doxygen_enhanced_color = 0

local function apply_highlights()
    -- Comment / String style.
    vim.api.nvim_set_hl(0, "Comment", { italic = true, ctermfg = 243 })
    vim.api.nvim_set_hl(0, "String", { italic = true })

    -- Match-paren and selection.
    vim.api.nvim_set_hl(0, "MatchParen", { ctermfg = 0, ctermbg = 6 })
    vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = 237 })
    vim.api.nvim_set_hl(0, "Visual", { ctermbg = 237 })

    -- Spell suggestions.
    vim.api.nvim_set_hl(0, "SpellBad", { ctermfg = 0, ctermbg = 1 })
    vim.api.nvim_set_hl(0, "SpellRare", { ctermfg = 8, ctermbg = 3 })
    vim.api.nvim_set_hl(0, "SpellCap", { ctermfg = 8, ctermbg = 2 })
    vim.api.nvim_set_hl(0, "SpellLocal", { ctermfg = 8 })

    -- Copilot ghost text.
    vim.api.nvim_set_hl(0, "CopilotSuggestion", { italic = true, ctermfg = 3 })

    -- Custom doxygen comment style; link doxygen captures to it.
    vim.api.nvim_set_hl(0, "CustomDoxyComment", { italic = true, ctermfg = 243 })
    vim.api.nvim_set_hl(0, "doxygenComment", { link = "CustomDoxyComment" })
    vim.api.nvim_set_hl(0, "doxygenBrief", { link = "CustomDoxyComment" })
    vim.api.nvim_set_hl(0, "doxygenSpecialOnelineDesc", { link = "CustomDoxyComment" })
    vim.api.nvim_set_hl(0, "doxygenCommentL", { link = "SpecialComment" })
    vim.api.nvim_set_hl(0, "doxygenSpecialTypeOnelineDesc", { link = "SpecialComment" })
    vim.api.nvim_set_hl(0, "doxygenSpecialHeading", { link = "SpecialComment" })

    -- Unified TODO/FIXME/etc. highlight.
    vim.api.nvim_set_hl(0, "MyTodo", { link = "SpellRare" })
    vim.api.nvim_set_hl(0, "Todo", { link = "MyTodo" })
    -- Treesitter captures for languages with @comment.* support.
    vim.api.nvim_set_hl(0, "@comment.todo", { link = "MyTodo" })
    vim.api.nvim_set_hl(0, "@comment.note", { link = "MyTodo" })
    vim.api.nvim_set_hl(0, "@comment.warning", { link = "MyTodo" })
    vim.api.nvim_set_hl(0, "@comment.error", { link = "MyTodo" })

    -- Strip backgrounds so terminal opacity passes through.
    local transparent = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "EndOfBuffer",
        "SignColumn",
        "LineNr",
        "CursorLineNr",
        "FloatBorder",
        "VertSplit",
        "WinSeparator",
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",
        "TabLineSel",
        "Pmenu",
        "PmenuSbar",
        "PmenuThumb",
    }
    for _, group in ipairs(transparent) do
        vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
    end
end

-- Reapply on ColorScheme so theme switches don't clobber our overrides.
vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("custom_highlights", { clear = true }),
    callback = apply_highlights,
})

vim.cmd.colorscheme("habamax")
