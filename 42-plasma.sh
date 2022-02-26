#!/bin/bash
#
set -o xtrace
#
# https://wiki.archlinux.org/title/Desktop_environment
#
pacman --noconfirm --needed  -S xorg xorg-server mesa \
    plasma kde-applications sddm
systemctl enable sddm -f
sync
# check display manager
file /etc/systemd/system/display-manager.service
