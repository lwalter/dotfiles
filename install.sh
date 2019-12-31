#!/bin/bash

# install zsh, i3, and vundle
#sudo apt-get install zsh i3wm feh arc-theme lxappearance papirus-icon-theme light redshift i3blocks cmake build-essential python-dev python3-dev

#git clone git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# JS, CSS, HTML, i3statusbar

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files=".tmux.conf .vimrc .zshrc .config/i3/config .config/i3/i3blocks.conf wallpaper.jpg"

echo "INSTALL ARK-DARKER FOR CHROME MANULLLY"

echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

echo "Changing to the $dir directory"
cd $dir
echo "...done"

for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -sf $dir/$file ~/$file
done

