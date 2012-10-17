#! /bin/bash

files='.bashrc .byobu/* .vimrc .gitconfig .xchat2/xchat.conf .xchat2/keybindings.conf .ackrc'

function wrong_usage() {
    printf "wrong usage: you should use 'home' or 'repo' as parameter:\n"
    printf "'home' means copy the dotfiles to your home dir;\n"
    printf "'repo' means copy the dotfiles from your home to the repo dir.\n"
    exit 42
}

function show_diff() {
    for file in $files; do
        cmp $file ~/$file > /dev/null
        if [ $? -ne 0 ]; then
            echo ">>> Diff for file $file"
            diff $file ~/$file
            echo 
        fi
    done

}

function home() {
    for file in $files; do
        rsync -crbv --suffix=.bak $file ~/$file
    done
}

function repo() {
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
    'diff')
        show_diff
        ;;
    *)
        wrong_usage
        ;;
esac

