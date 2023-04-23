# dotfiles

My personal dotfiles and shell scripts

---

## Prerequisites

* SSH keys should already be created and configured in GitHub user settings

  ```sh
  ssh-keygen -b 4096
  ```

* Prerequisite packages

  ```sh
  sudo dnf install vim-enhanced stow git make curl
  ```

## Installation

```bash
git clone --recurse-submodules git@github.com:Notgnoshi/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
make stow
```
