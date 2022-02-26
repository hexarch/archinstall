#!/bin/bash
#
#set -o xtrace
#
# https://wiki.archlinux.org/title/Desktop_environment
#
pacman --noconfirm --needed  -S xorg xorg-server mesa \
    xfce4 xfce4-goodies lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
systemctl enable lightdm.service -f
sync
# check display manager
file /etc/systemd/system/display-manager.service
