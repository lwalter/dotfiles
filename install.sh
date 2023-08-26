#!/usr/bin/env bash

set -e
set -u

sudo apt-get install zsh i3 i3blocks feh tmux curl stow

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage ~/.local/bin/nvim

packages=(
    "zsh"
    "nvim"
    "i3"
    "tmux"
    "git"
    "desktop"
)
for package in "${packages[@]}"; do
    stow "$package"
done
