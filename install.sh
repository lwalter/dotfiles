#!/bin/bash

sudo apt-get install zsh i3 feh lxappearance i3blocks cmake build-essential python-dev python3-dev tmux curl

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


# install go
curl https://golang.org/dl/go1.16.7.linux-amd64.tar.gz --output go1.16.7.linux-amd64.tar.gz
rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.16.7.linux-amd64.tar.gz

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash


dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files=".tmux.conf .vimrc .zshrc .config/i3/config .config/i3/i3blocks.conf wallpaper.jpg"

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

source ~/.zshrc
nvm install node

# cd ~/.vim/bundle/YouCompleteMe
# python3 install.py --all

# install docker
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
