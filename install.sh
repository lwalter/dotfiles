#!/usr/bin/env bash

set -e
set -u

function installPackages() {
    grep -v '^#' pkglist.txt | xargs -r sudo pacman -S --needed --noconfirm
    grep -v '^#' pkglist-aur.txt | xargs -r yay -S --needed --noconfirm

    sudo groupadd -f docker
    sudo usermod -aG docker "$USER"

    sudo groupadd -f informant
    sudo usermod -aG informant "$USER"

    GO_LATEST=$(curl -s 'https://go.dev/VERSION?m=text' | head -n 1)
    if [ ! -d "/usr/local/go" ] || [ "$(cat /usr/local/go/VERSION 2>/dev/null)" != "$GO_LATEST" ]; then
        ARCH=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')
        curl -LO "https://go.dev/dl/${GO_LATEST}.linux-${ARCH}.tar.gz"
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf "${GO_LATEST}.linux-${ARCH}.tar.gz"
        rm "${GO_LATEST}.linux-${ARCH}.tar.gz"
    fi

    if ! command -v uv >/dev/null 2>&1; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi

    mkdir -p ~/.local/bin
    curl -Lo ~/.local/bin/curseforge-latest-linux.AppImage -z ~/.local/bin/curseforge-latest-linux.AppImage https://curseforge.overwolf.com/downloads/curseforge-latest-linux.AppImage
    chmod +x ~/.local/bin/curseforge-latest-linux.AppImage

    curl -Lo ~/.local/bin/warcraftlogs-v8.19.70.AppImage -z ~/.local/bin/warcraftlogs-v8.19.70.AppImage https://github.com/RPGLogs/Uploaders-warcraftlogs/releases/download/v8.19.70/warcraftlogs-v8.19.70.AppImage
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
        stow -R "$application"
    done

    sudo stow -R -v -t /usr/local/bin scripts
    sudo stow -R -v -t /usr/share/libalpm/hooks/ pacman-hooks
    sudo stow -R -v -t /etc etc
    sudo stow -R -v -t /usr usr
}

function setSystemdUnits() {
    units=(iwd.service ufw snapper-timeline.timer snapper-cleanup.timer snapper-cleanup.service btrbk.timer apcupsd.service docker.socket docker.service)
    for unit in "${units[@]}"; do
        sudo systemctl enable --now "$unit"
    done

    sudo systemctl disable --now ckb-next-daemon.service

    user_units=(hyprpolkitagent.service ptt-fix.service replacewowproxy.service)
    for unit in "${user_units[@]}"; do
        systemctl --user enable --now "$unit"
    done
}

function installThemesAndFonts() {
    if [ ! -d "$HOME/Tokyonight-GTK-Theme" ]; then
        git clone https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme "$HOME/Tokyonight-GTK-Theme"
    else
        cd "$HOME/Tokyonight-GTK-Theme" && git pull && cd ..
    fi
    ./Tokyonight-GTK-Theme/install.sh -l --tweaks storm

    if [ ! -d "$HOME/.icons/TokyoNight-SE" ]; then
        curl -Lo /tmp/TokyoNight-SE.tar.bz2 https://github.com/ljmill/tokyo-night-icons/releases/download/v0.2.0/TokyoNight-SE.tar.bz2
        mkdir -p ~/.icons
        tar -xvjf /tmp/TokyoNight-SE.tar.bz2 -C ~/.icons/
    fi

    if [ ! -d "$HOME/.local/share/fonts/CaskaydiaMono" ]; then
        curl -Lo /tmp/CaskaydiaMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CaskaydiaMono.zip
        unzip -o /tmp/CaskaydiaMono.zip -d ~/.local/share/fonts/CaskaydiaMono
        fc-cache -f
    fi

    if [ ! -d "/usr/share/sddm/themes/astronaut" ]; then
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"
    fi
}

function main() {
    if [[ $EUID -eq 0 ]]; then
        echo "Error: Please do not run this script as root/sudo directly."
        echo "It will prompt for your password when needed."
        exit 1
    fi

    installPackages
    downloadThemeConfigFiles
    installThemesAndFonts
    stowApplicationConfigs
    setSystemdUnits
}

main "@"
