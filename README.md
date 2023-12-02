My dotfiles

The files are managed using [GNU Stow](https://www.gnu.org/software/stow/) to link the files in this folder to their expected locations.

Use the `make <setup/remove>` to create/remove the links.

For the gnome settings, it provides two targets (`make gsettings-snapshot/gsettings-restore`) to take a snapshot of the gnome settings or restore the current settings using the latest snapshot respectively.

