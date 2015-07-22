function dot-sync --description 'Sync dotfiles from ~/tools/dotfiles'
  if test -z $argv
    echo "Wrong usage. Params: [repo|home]"
    echo "  - home: synchronize dotfiles TO home folder"
    echo "  - repo: synchronize dotfiles FROM home folder"
    exit 1
  end

  set DOTFILES_DIR "$HOME/tools/dotfiles"
  ## Create/Clone dotfiles if needed
  if test ! -d $DOTFILES_DIR
    mkdir -p $DOTFILES_DIR
    git clone git@github.com:daniloqueiroz/dotfiles.git $DOTFILES_DIR
  end

  cd $DOTFILES_DIR
  switch $argv
    case home
      ./sync.sh home
    case repo
      ./sync.sh repo
  end
end
