# dotfiles

## Installation

1. Follow [arch installation guide](https://wiki.archlinux.org/title/Installation_guide)
1. Go through [general recommendations](https://wiki.archlinux.org/title/General_recommendations)
1. Follow [security steps](https://wiki.archlinux.org/title/Security) and [here](https://theprivacyguide1.github.io/linux_hardening_guide)

## General maintenance

1. Check logs in `/var/logs` and verify systemd units `$ systemctl --failed`, `journalctl -xe`
1. [See docs](https://wiki.archlinux.org/title/System_maintenance)
1. Remove orphaned packages `pacman -Rns $(pacman -Qtdq)`
