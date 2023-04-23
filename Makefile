stow:
	stow --verbose=1 --target=$$HOME --restow dotfiles/

unstow:
	stow --verbose=1 --target=$$HOME --delete dotfiles/
