# Neovim migration: feature checklist

Goal: replicate the vim experience in neovim, using modern nvim best-practices
(lazy.nvim, builtin LSP, treesitter, etc.) rather than porting plugin-for-plugin.

Decisions already made:

- Independent configs from vim. No shared bundle/.
- Plugin manager: lazy.nvim.
- LSP: builtin nvim LSP via nvim-lspconfig + mason.nvim. Drop ALE.
- Snippets: LuaSnip. Hand-port custom snippets from UltiSnips.
- Telescope alongside FZF. Both available; pick per use case.
- Theme deferred. Use base16 + terminal palette when ready.
- LSPs/formatters/linters installed via mason, not setup.d.

---

## Vanilla settings

Most `set` options port directly to `vim.opt.<name>` in lua. Same names,
same values. Block-port from `vimrc` to `lua/config/options.lua`.

- [ ] `enc=utf-8`
- [ ] `nocompatible` (no-op in nvim, default)
- [ ] `keywordprg=:Man`
- [ ] `grepprg=rg --vimgrep --smart-case --follow`
- [ ] `autowrite`, `autoread`, `updatetime=1000`
- [ ] `hidden`
- [ ] Tabs / indent: `tabstop=4`, `softtabstop=0`, `expandtab`, `shiftwidth=4`,
      `shiftround`, `smarttab`, `smartindent`, `autoindent`,
      `backspace=indent,eol,start`, `nojoinspaces`
- [ ] `title`, `titlestring=...`, `titleold=`, `notitle` on VimLeave
- [ ] `number`, `scrolloff=6`, `sidescrolloff=6`, `virtualedit=all`
- [ ] `wildmenu`, `lazyredraw`, `showmatch`, `showcmd`
- [ ] Search: `incsearch`, `ignorecase`, `smartcase`, `hlsearch`,
      `shortmess-=S`
- [ ] `mouse=a`
- [ ] `path+=**`
- [ ] `wildignore+=...` (.git, node_modules, target, build, etc.)
- [ ] Folding: `foldenable`, `foldlevelstart=15`, `foldnestmax=10`,
      `foldmethod=indent` (treesitter folding may replace this; see Folding)
- [ ] `cursorline`, `colorcolumn=100`, `textwidth=100`
- [ ] `display=truncate`
- [ ] `equalalways`
- [ ] Undo: `undodir=~/.local/share/nvim/undo`, `undofile`
- [ ] Spell: `spelllang=en_us`, `spellfile=~/.config/nvim/spell/en.utf-8.add`,
      `spelloptions=camel`
- [ ] viminfo/shada equivalent: `set shada=!,'500,/5000,:5000,<500,s1000,h`
      (note: `shada` replaces `viminfo` in nvim)
- [ ] `pastetoggle=<F5>` (note: deprecated in nvim 0.9+; bracketed paste
      handles this automatically. Probably drop.)
- [ ] `noshowmode` (lualine/airline shows mode)

---

## Augroups / filetype detection

- [ ] gitcommit `colorcolumn=72`
- [ ] disable shada for gitcommit and gitrebase (current: viminfo=)
- [ ] nginx detection (*.nginx, /etc/nginx/*, /usr/local/nginx/conf/*,
      nginx.conf, nginx/*.conf)
- [ ] dotenv detection (*.env, *.env.*)
- [ ] yaml override `ts=4 sts=4 sw=4 expandtab`
- [ ] commentary settings (`commentstring` for c/cpp/nginx/qmake)
- [ ] Override rust gdb to `rust-gdb`
- [ ] Exit vim if quickfix is the last open window
- [ ] Exit vim if netrw is the last open window
- [ ] Spellfile sort/compile augroups (see Spelling)
- [ ] `paste_toggled` foldexpr workaround (probably drop with
      `pastetoggle=<F5>` removal)

---

## Theming / highlights

Theme itself deferred to polish stage (use base16 + terminal palette).
These are the structural highlights independent of theme choice:

- [ ] `Comment` italic + dim (currently `cterm=italic ctermfg=243`)
- [ ] `String` italic
- [ ] `CursorLine ctermbg=237`, `Visual ctermbg=237`
- [ ] `MatchParen ctermfg=0 ctermbg=6`
- [ ] `Spell{Bad,Rare,Cap,Local}` colors
- [ ] `CopilotSuggestion` italic + ctermfg=3
- [ ] `MyTodo` augroup that highlights TODO/FIXME/BUG/NOTE/XXX/IMPORTANT
      in comments. Treesitter has `@comment.todo`, `@comment.note`,
      `@comment.warning` capture groups; can map highlights there instead
      of using a vim regex match.
- [ ] `<Leader>ss` mapping that echoes syntax group under cursor
      (treesitter equivalent: `:Inspect` is builtin in nvim 0.9+)

Doxygen: `g:load_doxygen_syntax`, `doxygen_enhanced_color`, the doxygen
highlight links. Treesitter does not have a dedicated doxygen parser;
nvim still loads vim's doxygen.vim syntax. Probably keep these settings
verbatim.

---

## Statusline / tabline

Current: vim-airline + airline-themes, with tabline showing splits but
not buffers, ascii symbols, custom colnr/linenr labels.

- [ ] Statusline (mode, file, position, diagnostics).
      Hypothesis: lualine.nvim. Or keep vim-airline (works in nvim).
- [ ] Tabline showing splits only, not buffers. (Per user preference,
      "no modern editor tab.")
      Hypothesis: lualine has a tabline option. Or just `set showtabline=0`
      and skip the feature.
- [ ] ascii symbols (no powerline glyphs)

---

## File / buffer navigation

Current: FZF + fzf.vim with `<C-f>` prefix family.

- [ ] `<C-f><C-b>` Buffers
- [ ] `<C-f><C-t>` Files
- [ ] `<C-f><C-g>` GFiles --cached --others --exclude-standard
- [ ] `<C-f><C-r>` History:
- [ ] `<C-f><C-f>` History/
- [ ] `<C-f><C-h>` History (file)
- [ ] `<C-f><C-j>` Jumps
- [ ] `<C-f><C-m>` Marks
- [ ] `<C-f><C-s>` Snippets
- [ ] `<C-x><C-f>` insert-mode path completion (fzf-complete-path)

Hypothesis: keep FZF + fzf.vim verbatim. Add telescope alongside for
features it does notably better (live_grep with preview, lsp_references,
diagnostics).

---

## Search / grep

- [ ] `:grep` uses ripgrep (`grepprg`)
- [ ] Live grep with preview.
      Hypothesis: telescope live_grep.
- [ ] Search history navigation
      (already covered by `<C-f><C-r>`/`<C-f><C-f>`)

---

## LSP-like features (ALE replacement)

Current: ALE provides linting, fixing, completion, hover, definition,
rename, references, all unified.

Hypothesis: nvim builtin LSP (nvim-lspconfig) + mason for installs.
Diagnostics UI (`vim.diagnostic.config`) tuned to match ALE's look.

Servers needed (by current language):

- [ ] clangd (C, C++) with custom flags:
      `--background-index --header-insertion=iwyu --pch-storage=memory
       --completion-style=bundled --compute-dead --query-driver=...
       -j=4 --clang-tidy`
- [ ] rust-analyzer with custom config:
      `cargo.cfgs=['test'], features='all', procMacro.enable=true,
       check.command='clippy', diagnostics.disabled=['unresolved-proc-macro']`
- [ ] ruff (Python lint + format)
- [ ] basedpyright or pyright (Python types)
- [ ] typescript-language-server
- [ ] eslint-language-server
- [ ] cmake-language-server (cmake_lint replacement)
- [ ] texlab (LaTeX)
- [ ] bash-language-server
- [ ] marksman (Markdown)

Keybinds (currently ALE):

- [ ] `<F1>` run all fixers (current: ALEFix)
      Hypothesis: conform.nvim `format()`
- [ ] `<F2>` rename symbol
      Hypothesis: `vim.lsp.buf.rename`
- [ ] `<F3>` find references in quickfix
      Hypothesis: `vim.lsp.buf.references` or telescope `lsp_references`
- [ ] `<F4>` toggle header/source (CurtineIncSw, kept verbatim)
- [ ] `gd` go to definition
      Hypothesis: `vim.lsp.buf.definition`
- [ ] `gD` go to type definition
      Hypothesis: `vim.lsp.buf.type_definition`
- [ ] `K` hover (already builtin in nvim 0.10+)
- [ ] `]p` / `[p` next/previous problem
      Hypothesis: `vim.diagnostic.jump({count=1})` etc. Note: `]d`/`[d`
      are now builtin defaults; can rebind to `]p`/`[p` for muscle memory.
- [ ] `]q` / `[q` quickfix navigation (cnext/cprev, already in vim)

Diagnostic UI (currently ALE):

- [ ] virtual text shown only on current line (`virtualtext_cursor='current'`)
- [ ] virtual text starts at column 80, max column 120
- [ ] floating preview for hover/details (no border)
- [ ] sign column always shown
- [ ] format `[severity][linter][code] message`

Hypothesis: `vim.diagnostic.config({virtual_text=..., float=...,
underline=..., signs=...})` plus a `CursorMoved` autocmd for
current-line-only virtual text behavior.

---

## Formatting

Current ALE fixers, by filetype:

- [ ] `*` remove_trailing_lines + trim_whitespace
- [ ] c clang-format
- [ ] cmake cmakeformat
- [ ] cpp clangtidy + clang-format
- [ ] css prettier
- [ ] html prettier (with `--print-width 120 --prose-wrap always
      --tab-width 4 --html-whitespace-sensitivity css`)
- [ ] javascript prettier
- [ ] json jq (`--indent 4`)
- [ ] markdown dprint
- [ ] python ruff_format (`--line-length=100`)
- [ ] rust rustfmt
      (`--config group_imports=StdExternalCrate,imports_granularity=Module
       --style-edition=2024`)
- [ ] sh shfmt (`--indent 4`)
- [ ] tex latexindent (`--yaml="defaultIndent:'    '"`)
- [ ] toml dprint
- [ ] vimwiki dprint

Hypothesis: conform.nvim. Each language gets a `formatters_by_ft` entry,
custom args via `formatters` table.

---

## Linting (non-LSP)

ALE linters not covered by LSP:

- [ ] cmake_lint (will be covered by cmake-language-server LSP, drop)
- [ ] chktex (LaTeX style)
- [ ] hadolint (Dockerfile, with `g:ale_dockerfile_hadolint_use_docker = 'yes'`)
- [ ] eslint (covered by eslint-language-server LSP)

Hypothesis: nvim-lint for chktex and hadolint. Let LSPs cover the rest.

---

## Completion

Current: ALE completion, omnicompletion via `<C-n>`/`<C-p>`,
`<CR>` accepts when popup is open, `<C-x><C-f>` for path via fzf.

- [ ] `<C-n>` triggers completion
- [ ] `<CR>` accepts the selected completion
- [ ] `<C-x><C-f>` path completion (kept via fzf, see File/buffer)
- [ ] LSP-driven completion sources
- [ ] Buffer completion source
- [ ] Path completion source
- [ ] Snippet completion source
- [ ] `completeopt=menu,menuone,popup`

Hypothesis: blink.cmp (modern, fast). nvim-cmp is the older alternative.

---

## Snippets

Current: UltiSnips with `~/.vim/snips/*.snippets`, custom triggers,
Python interpolation, regex triggers.

- [ ] `<Tab>` expand snippet / jump forward
- [ ] `<S-Tab>` jump backward
- [ ] Snippet picker (currently `<C-f><C-s>`)
- [ ] Port `all.snippets`: copyright, date, datetime, uuid, box
      (uuid uses Python; box uses Python)
- [ ] Port `c.snippets`: main
- [ ] Port `cpp.snippets`: class (basename-derived), using, namespace (regex)
- [ ] Port `html.snippets`
- [ ] Port `make.snippets`
- [ ] Port `markdown.snippets`
- [ ] Port `python.snippets`
- [ ] Port `sh.snippets`
- [ ] Port `snippets.snippets` (meta)
- [ ] Port `vimwiki.snippets`

Hypothesis: LuaSnip for engine. friendly-snippets for community pack.
Custom snippets with Python interpolation rewritten as lua snippets.
Snippet picker via telescope (`:Telescope luasnip`) or via blink.cmp's
list.

---

## Git integration

- [ ] Hunk signs in sign column
      Hypothesis: gitsigns.nvim (replaces vim-gitgutter)
- [ ] `]c` / `[c` next/previous hunk
- [ ] Hunk preview / stage / undo
- [ ] Line blame
- [ ] `:G`, `:Gdiff`, `:Gblame`, etc.
      Hypothesis: vim-fugitive, kept verbatim
- [ ] gitcommit `colorcolumn=72` (already listed in Augroups)
- [ ] Mark colors driven by gitgutter (`SignatureMark{er}TextHLDynamic`)
      Hypothesis: replicate via gitsigns + vim-signature

---

## Editing helpers

All vimscript, all work in nvim. Keep verbatim.

- [ ] commentary (gcc, gc{motion})
- [ ] vim-surround (cs/ds/ys)
- [ ] vim-repeat
- [ ] vim-unimpaired (`]q`, `[q`, `]b`, `[b`, etc.)
- [ ] vim-eunuch (`:Move`, `:Rename`, `:Chmod`, `:SudoWrite`)
- [ ] vim-indent-object (`ai`, `ii`)
- [ ] vim-textobj-comment + vim-textobj-user (`ac`, `ic`)
- [ ] quick-scope (highlights unique chars on f/F/t/T)
- [ ] vim-tmux-navigator (`<C-h/j/k/l>` between tmux + vim panes)

---

## Custom keybinds

- [ ] `<CR>` clears search highlight
- [ ] `<` and `>` in visual reselect after indent
- [ ] System clipboard via `clip` script:
  - [ ] `<C-S-p>` paste in i/v/n
  - [ ] `<C-y>` copy in i/v/n
- [ ] `<space>` toggles fold
- [ ] `j`/`k` move by visual line
- [ ] `i#` doesn't bring comment to col 0
- [ ] `<C-t>` open new empty buffer
- [ ] `:bd` doesn't close window (cnoreabbrev workaround)

---

## Folding

- [ ] enabled, level 15, max nest 10
- [ ] `foldmethod=indent` (currently chosen for cpp speed)
- [ ] `<space>` toggles fold
- [ ] vimwiki uses syntax folding (`g:vimwiki_folding = 'syntax'`)

Hypothesis: treesitter folding (`foldexpr=v:lua.vim.treesitter.foldexpr()`)
is faster than indent. Try it on large C++ files.

---

## Spelling

- [ ] `<F7>` toggle spell
- [ ] custom `~/.vim/spell/en.utf-8.add` -> port location
- [ ] SetupSpellfile() function: rebuild .spl from .add when stale
- [ ] SortSpellfile() function: sort+dedupe .add on VimLeave

Hypothesis: same lua function in `lua/config/spelling.lua`.

---

## Undo

- [ ] persistent undo (`undofile`) in `~/.local/share/nvim/undo`
- [ ] undo tree visualization
      Hypothesis: vim-mundo (kept) or undotree.vim

---

## Mark display

- [ ] vim-signature (kept). Marks shown in sign column with gitgutter
      driving the color.

---

## Manpager

- [ ] vim used as MANPAGER (`man -P 'vim ...'` use case)
      Hypothesis: nvim has builtin man support. `:Man` works out of the box.
      Use `MANPAGER='nvim +Man\!'` env var. Drop vim-manpager.
- [ ] after/ftplugin/man.vim customization (port to ftplugin/man.lua
      or remove if defaults are fine)

---

## Local vimrc

- [ ] `g:localvimrc_ask=0` (auto-source per-project .lvimrc)
      Hypothesis: vim-localvimrc kept verbatim. nvim's `vim.secure.read`
      is narrower in scope.

---

## ANSI escape rendering

- [ ] AnsiEsc plugin to render ANSI color codes in buffer.
      Hypothesis: vim-plugin-AnsiEsc kept verbatim. (No nvim-native peer.)

---

## Debugging

Current: vimspector with debugpy, vscode-cpptools, CodeLLDB.

- [ ] `<F8>` toggle breakpoint
- [ ] `<F9>` continue
- [ ] `<F10>` pause
- [ ] `<Leader>du/dd` up/down frame
- [ ] `<Leader>db` breakpoints
- [ ] `<Leader>ds/dn/df` step into/over/out
- [ ] `<Leader>dc` run to cursor
- [ ] `]d`/`[d` jump to next/prev breakpoint
      Note: collides with new `]d`/`[d` LSP diagnostic builtin.
- [ ] `<Leader>di` inspect (n/v)
- [ ] custom process picker via fzf

Hypothesis: vimspector kept verbatim. Reassess vs nvim-dap if vimspector
falls short.

---

## Filetypes / language plugins

Plugins kept (no nvim-native peer or treesitter parser):

- [ ] vim-bitbake
- [ ] vim-flatbuffers
- [ ] vim-ps1

Treesitter parsers (replace highlight plugins):

- [ ] cpp (replaces vim-cpp-enhanced-highlight; preserve
      `cpp_class_scope_highlight`, `cpp_posix_standard` settings via
      treesitter equivalents if possible)
- [ ] c, rust, python, javascript, typescript, json, html, css,
      markdown, toml, yaml, bash, lua, vimdoc, vim, latex,
      cmake, gitcommit, diff

Drop:

- [ ] rust.vim (treesitter + rust-analyzer cover everything used)
- [ ] vim-toml (treesitter has toml)
- [ ] vim-systemd-syntax (builtin)
- [ ] vim-cpp-enhanced-highlight (treesitter)

---

## Copilot

- [ ] copilot.vim (kept verbatim; officially supported on nvim)
- [ ] `g:copilot_filetypes` config (disable on text, dotenv)
- [ ] `<C-]>` dismiss
- [ ] `<M-Right>` accept next word
- [ ] `CopilotSuggestion` highlight (already in Highlights)

---

## Vimwiki

- [ ] vimwiki kept verbatim
- [ ] All `g:vimwiki_*` settings: path, ext, syntax, auto_tags,
      automatic_nested_syntaxes, nested_syntaxes, auto_toc,
      folding=syntax, key_mappings.table_mappings=0, conceallevel=0
- [ ] mundo preview width (`g:mundo_preview_bottom`)

---

## Testing (vim-test)

- [ ] vim-test kept verbatim
- [ ] strategy = "dispatch"

---

## Drop entirely

- [ ] vim-altscreen (nvim handles altscreen natively; remove `SetAltScreen()`
      calls in vimrc)
- [ ] vim-autoread (use builtin `set autoread` + CursorHold `:checktime`
      autocmd; or keep if 1000ms polling is missed)
- [ ] vim-manpager (nvim builtin replaces it)
- [ ] rust.vim
- [ ] vim-toml
- [ ] vim-systemd-syntax
- [ ] vim-cpp-enhanced-highlight
- [ ] vis (was for visual-block `:S` substitutions; user confirmed drop)

---

## Hugefile alternate vimrc

- [ ] vimrc.hugefile equivalent for editing huge files
      (no plugins, no autoread, etc.)
      Hypothesis: separate `init-hugefile.lua` invoked via
      `nvim -u ~/.config/nvim/init-hugefile.lua`.

---

## Open questions

1. Treesitter folding vs indent folding for large C++. Compare in practice.
2. blink.cmp vs nvim-cmp. blink is newer, nvim-cmp is more battle-tested.
3. Whether to keep vim-airline or move to lualine. Lualine is more modern
   but airline already works.
4. `]d`/`[d` collision: nvim's new builtin diagnostic jumps vs your
   current vimspector breakpoint jumps. Pick one.
5. Whether to keep custom MyTodo augroup or use treesitter
   `@comment.todo` capture group.
6. Whether `pastetoggle=<F5>` and the FastPaste augroup are still useful
   given nvim's bracketed paste handling.
