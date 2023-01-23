STOW = /usr/bin/stow
DEST_DIRS = bin/ .config .ssh/

create_dirs:
	for d in $(DEST_DIRS); do\
		mkdir -p $$HOME/$$d ;\
	done

setup: create_dirs
	$(STOW) --restow home/
	$(STOW) --restow --target $$HOME/bin bin
	$(STOW) --target $$HOME/.config/ config
	$(STOW) --restow --target $$HOME/.ssh ssh

remove:
	$(STOW) --delete --target ~ home/
	$(STOW) --delete --target ~/.ssh ssh/
	$(STOW) --delete --target ~/.config/ config/
	$(STOW) --delete --target ~/bin bin/
