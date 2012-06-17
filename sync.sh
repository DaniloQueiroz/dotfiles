#! /bin/bash

files='.bashrc .byobu .vimrc'

function wrong_usage() {
    printf "wrong usage: you should use 'home' or 'repo' as parameter:\n"
    printf "'home' means copy the dotfiles to your home dir;\n"
    printf "'repo' means copy the dotfiles from your home to the repo dir.\n"
    exit 42
}

function home(){
    rsync -crbv --suffix=.bak $files ~
}

function repo(){
    rsync -crv ~/$files .
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

