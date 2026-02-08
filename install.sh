#!/usr/bin/env bash

set -e
set -u

function installPackages() {
    cat pkglist.txt | xargs pacman -S --needed
    cat pkglist-aur.txt | xargs yay -S --needed

    sudo groupadd -f docker
    if ! groups "$USER" | grep -q "\bdocker\b"; then
        sudo usermod -aG docker "$USER"
    fi

    grep -q "informant" /etc/group || sudo groupadd informant
    id -nG "$USER" | grep -qw "informant" || sudo usermod -aG informant "$USER"

    GO_LATEST=$(curl -s 'https://go.dev/VERSION?m=text' | head -n 1)
    ARCH=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')
    curl -LO "https://go.dev/dl/${GO_LATEST}.linux-${ARCH}.tar.gz"
    sudo rm -rf /usr/local/go 
    sudo tar -C /usr/local -xzf "${GO_LATEST}.linux-${ARCH}.tar.gz"
    rm "${GO_LATEST}.linux-${ARCH}.tar.gz"

    curl -LsSf https://astral.sh/uv/install.sh | sh

    curl -Lo ~/.local/bin/curseforge-latest-linux.AppImage https://curseforge.overwolf.com/downloads/curseforge-latest-linux.AppImage
    chmod +x ~/.local/bin/curseforge-latest-linux.AppImage

    curl -Lo ~/.local/bin/warcraftlogs-v8.19.70.AppImage https://github.com/RPGLogs/Uploaders-warcraftlogs/releases/download/v8.19.70/warcraftlogs-v8.19.70.AppImage
    chmod +x ~/.local/bin/warcraftlogs-v8.19.70.AppImage
}

function downloadThemeConfigFiles() {
    # alacritty, btop, tmux, dunst, yazi themes
    # love you folke <3
    curl -Lo ./alacritty/.config/alacritty/tokyonight_storm.toml https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/heads/main/extras/alacritty/tokyonight_storm.toml

    curl -Lo ./btop/.config/btop/themes/tokyonight_storm.theme https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/heads/main/extras/btop/tokyonight_storm.theme

    curl -Lo ./tmux/.config/tmux/tokyonight_storm.tmux https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/heads/main/extras/tmux/tokyonight_storm.tmux

    curl -Lo ./dunst/.config/dunst/dunstrc.d/tokyonight_storm.conf https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/heads/main/extras/dunst/tokyonight_storm.dunstrc

    curl -Lo ./yazi/.config/yazi/theme.toml https://raw.githubusercontent.com/folke/tokyonight.nvim/refs/heads/main/extras/yazi/tokyonight_storm.toml
}

function stowApplicationConfigs() {
  dotfiles=(
      "git"
      "zsh"
      "tmux"
      "nvim"
      "dunst"
      "alacritty"
      "btop"
      "hypr"
      "gtk-3.0"
      "gtk-4.0"
      "wofi"
      "waybar"
      "yazi"
      "ptt-fix"
      "electron-flags"
      "udiskie"
      "nwg-bar"
      "qt5ct"
      "qt6ct"
      "systemd"
      "desktop-files"
  )

  for application in "${dotfiles[@]}"; do
      stow "$application"
  done
  
  sudo stow -v -t /usr/local/bin scripts
  sudo stow -v -t /usr/share/libalpm/hooks/ pacman-hooks
  sudo stow -v -t /etc etc
}

function setSystemdUnits() {
    sudo systemctl enable --now iwd.service
    sudo systemctl enable --now ufw
    sudo systemctl enable --now snapper-timeline.timer
    sudo systemctl enable --now snapper-cleanup.timer
    sudo systemctl enable --now snapper-cleanup.service
    sudo systemctl enable --now btrbk.timer
    sudo systemctl enable --now apcupsd.service
    sudo systemctl enable --now docker.socket
    sudo systemctl enable --now docker.service

    # For now, stop this daemon...
    sudo systemctl disable --now ckb-next-daemon.service

    systemctl --user enable --now hyprpolkitagent.service
    systemctl --user enable --now ptt-fix.service
    systemctl --user enable --now replacewowproxy.service
}


function installThemesAndFonts() {
    # tokyonight GTK 3/4
    git clone https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme
    ./themes/install.sh -l --tweaks storm
    # tokyonight icons
    curl -Lo /tmp/TokyoNight-SE.tar.bz2 https://github.com/ljmill/tokyo-night-icons/releases/download/v0.2.0/TokyoNight-SE.tar.bz2
    tar -xvjf /tmp/TokyoNight-SE.tar.bz2 -C ~/.icons/

    # Fonts
    curl -Lo /tmp/CaskaydiaMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CaskaydiaMono.zip
    unzip /tmp/CaskaydiaMono.zip -d ~/.local/share/fonts
    sudo fc-cache -fv

    # sddm theme
    # https://github.com/siddrs/tokyo-night-sddm ???
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"
    # TODO editing /etc/sddm.conf and fonts
}


function main() {
    installPackages
    downloadThemeConfigFiles
    stowApplicationConfigs
    setSystemdUnits
    installThemesAndFonts
}
