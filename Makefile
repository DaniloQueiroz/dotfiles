STOW = /usr/bin/stow
DEST_DIRS = bin/ .config .ssh/

.DEFAULT_GOAL := help
.PHONY: create_dirs setup remove help gsettings_snapshots

help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

.create_dirs:
	for d in $(DEST_DIRS); do\
		mkdir -p $$HOME/$$d ;\
	done

setup: .create_dirs # (re)install all the files links
	$(STOW) --restow home/
	$(STOW) --restow --target $$HOME/bin bin
	$(STOW) --restow --target $$HOME/.config/ config
	$(STOW) --restow --target $$HOME/.ssh ssh
	$(STOW) --restow --target $$HOME/.local/share/gnome-shell/ gnome/

remove: # remove all the files links
	$(STOW) --delete --target ~ home/
	$(STOW) --delete --target ~/.ssh ssh/
	$(STOW) --delete --target ~/.config/ config/
	$(STOW) --delete --target ~/bin bin/
	$(STOW) --delete --target $$HOME/.local/share/gnome-shell/ gnome/

gsettings-snapshot: # update the gnome setting snapshot backup
	dconf dump / > gnome/settings.ini

gsettings-restore: # restore the gnome setting snapshot
	dconf load / < gnome/settings.ini
