#! /bin/bash

files='.bashrc .byobu/* .vimrc .gitconfig .xchat2/xchat.conf .xchat2/keybindings.conf'

function wrong_usage() {
    printf "wrong usage: you should use 'home' or 'repo' as parameter:\n"
    printf "'home' means copy the dotfiles to your home dir;\n"
    printf "'repo' means copy the dotfiles from your home to the repo dir.\n"
    exit 42
}

function home(){
    for file in $files; do
        rsync -crbv --suffix=.bak $file ~/$file
    done
}

function repo(){
    for file in $files; do
        rsync -crv ~/$file ./$file
    done
}

case $1 in
    'repo')
        repo
        ;;
    'home')
        home
        ;;
    *)
        wrong_usage
        ;;
esac

