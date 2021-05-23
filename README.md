# dotfiles

My personal dotfiles and shell scripts

---

## Installation

**Important:** SSH keys for GitHub should already be set up before cloning this repository.

```bash
git clone --recurse-submodules git@github.com:Notgnoshi/dotfiles.git ~/.config/dotfiles
~/.config/dotfiles/deploy.py ~
# Will prompt for each set of configurations, but note that there are undocumented dependencies between them.
~/.local/bin/configure.sh
source ~/.bashrc
```

## Vim Plugins

Each plugin is a submodule in `.vim/bundle/`, and is loaded by [Pathogen](https://github.com/tpope/vim-pathogen).

* [ALE](https://github.com/dense-analysis/ale) - linting, formatting, and completion
* [colorschemes](https://github.com/flazz/vim-colorschemes) - I use a customized base16 theme with the particular colors set from the Tilix options.
* [commentary](https://github.com/tpope/vim-commentary) - toggle comments with `gc`
* [CurtineIncSw.vim](https://github.com/ericcurtin/CurtineIncSw.vim) - a robust script to toggle between C/C++ headers and sources. Bound to `<F4>` because that's the Qt Creator keybind
* [fzf](https://github.com/junegunn/fzf) and [fzf.vim](https://github.com/junegunn/fzf.vim) - gives me warm fuzzies
* [qmake-syntax-vim](https://github.com/artoj/qmake-syntax-vim) - QMake `.pri` and `.pro` syntax support
* [sensible](https://github.com/tpope/vim-sensible) - a set of "sensible" vim defaults
* [UltiSnips](https://github.com/SirVer/ultisnips) - snippets
* [vim-airline](https://github.com/vim-airline/vim-airline) and [vim-airline-themes](https://github.com/vim-airline/vim-airline-themes) - a better status line
* [vim-autoread](https://github.com/djoshea/vim-autoread) - watch open files for changes
* [vim-cpp-enhanced-highlight](https://github.com/octol/vim-cpp-enhanced-highlight) - vastly improved C++ syntax highlighting
* [vim-eunuch](https://github.com/tpope/vim-eunuch) - Vim sugar for common unix commands
* [vim-fugitive](https://github.com/tpope/vim-fugitive) - awesome git integration. Nicely wraps most git commands with `:Git <command>`
* [vim-gitgutter](https://github.com/airblade/vim-gitgutter) - git diff markers in the gutter. Also allows staging hunks
* [vim-mundo](https://github.com/simnalamburt/vim-mundo) - visualize and browse Vim's undo tree
* [vim-qml](https://github.com/peterhoeg/vim-qml) - QML syntax support
* [vim-repeat](https://github.com/tpope/vim-repeat) - allow plugins to tap into the power of `.`
* [vim-signature](https://github.com/kshenoy/vim-signature) - display marks in the gutter
* [vim-surround](https://github.com/tpope/vim-surround) - surround things in HTML tags, parentheses, quotes, etc
* [vim-systemd-syntax](https://github.com/Matt-Deacalion/vim-systemd-syntax) - syntax and ftdetect for systemd service files
* [vim-toml](https://github.com/cespare/vim-toml) - syntax for TOML files
* [vimwiki](https://github.com/vimwiki/vimwiki) - personal knowledge base in vim. Also good as a markdown plugin
