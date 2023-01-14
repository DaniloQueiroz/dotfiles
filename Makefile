install:
	mkdir -p ~/{bin,.ssh,.config}
	stow -vR -t ~ home/
	stow -vR -t ~/.ssh ssh/
	stow -vR -t ~/.config/ config/
	stow -vR -t ~/bin bin/

uninstall:
	stow -vD -t ~ home/
	stow -vD -t ~/.ssh ssh/
	stow -vD -t ~/.config/ config/
	stow -vD -t ~/bin bin/
