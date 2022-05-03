install:
	mkdir -p ~/tools/utils
	stow -vR -t ~ home/
	stow -vR -t ~/.ssh ssh/
	stow -vR -t ~/.config/ config
	stow -vR -t ~/tools/utils utils

uninstall:
	stow -vD -t ~ home/
	stow -vD -t ~/.ssh ssh/
	stow -vD -t ~/.config/ config
	stow -vD -t ~/tools/utils utils
