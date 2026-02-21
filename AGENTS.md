This project is a collection of shell scripts and Linux dotfiles used on Fedora 42+ and Ubuntu 24.04+.

There's a `setup` script that's used to setup the dotfiles, which it does so primarily with GNU
Stow, deploying `stowdir/*` as symlinks into my home directory, along with different ad-hoc scripts
for setup and package installation in `setup.d/`.

The most important things to know about the stowdir is:

* The scripts in `stowdir/.local/bin/`
* The `stowdir/.bashrc` file, which sources files from `bashrc.d/`
* The `stowdir/.vim/vimrc` vim config file
* The `stowdir/.tmux.conf` tmux config file
