#!/bin/bash
#
# Logon in the new system, then sudo this commands:
#
systemctl enable sshd
#
ufw enable
systemctl enable --now ufw
# this ufw commands should be done after system boot
ufw logging off
ufw allow ssh
# block ping
# sed -i 's/echo-request -j ACCEPT/echo-request -j DROP/' /etc/ufw/before.rules
# sed -i 's/echo-request -j ACCEPT/echo-request -j DROP/' /etc/ufw/before6.rules
#
echo "alias ls='ls -al --color=auto'" >> .bashrc
echo "alias l='lsd -al'" >> .bashrc
#
# virtual box only
# pacman --noconfirm --needed  -S virtualbox-guest-utils xf86-video-vmware
# systemctl enable vboxservice
#
pacman -S amd-ucode
#pacman -S intel-ucode
