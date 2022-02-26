#!/bin/bash
#
# REMOVE FROM THIS LINE UP TO "EXIT 16"
# ================================================
#echo -e "You need to edit this file before executing it."
#echo -e "Remove 3 lines at the start of the script (2 echo and 1 exit)"
#exit 16
#
# =to-from-here===================================
#
# ================================================
# >> CHANGE VARIABLES BELOW FOR YOUR CUSTOM SYSTEM
# ================================================
hostname="arch9001"
username="username"
password="password"
timezone="Europe/Lisbon"
countryn="Portugal"      # couuntry for reflector
countrys="pt"
countryb="PT"
harddisk="sda"
#
#set -o xtrace
#
clear
echo -e ''
echo -e ''
echo -e '*********************************************************'
echo -e 'ArchLinux Lin0x scripts >>> chroot into new system script'
echo -e '*********************************************************'
echo -e ''
echo -e '* This script will install and configure the new system *'
echo -e ''
echo -e ''
#read -t 10 -p '15 seconds pause and then the script starts...'
#read -t 5  -p 'You stil have 5 seconds to cancel the script...'
#read -rp "Do you want to exit? (y/N) : " -ei "N" key;
#
x=10
while [ $x -gt 0 ]
do
    sleep 1s
    #clear
    echo "$x seconds to start the script"
    x=$(( $x - 1 ))
done
#
#timedatectl --no-ask-password set-timezone $timezone
#timedatectl --no-ask-password set-ntp 1
#timedatectl set-ntp true
#timedatectl status
#
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
pacman -S --noconfirm reflector rsync
reflector -a 48 -c $countryn -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
#echo "Server = http://192.168.122.207:8080" >  /etc/pacman.d/mirrorlist
#
pacman -Sy
#
# https://wiki.archlinux.org/title/Pacman
# https://wiki.archlinux.org/title/System_maintenance#Partial_upgrades_are_unsupported
# linux-lts linux-lts-headers
pacman --noconfirm --needed -S \
    base-devel linux linux-firmware vim nano sudo archlinux-keyring wget \
    amd-ucode grub dosfstools os-prober mtools curl wget git reflector networkmanager openssh \
    git terminus-font broot ntfs-3g libnewt util-linux acpid htop btop nfs-utils \
    netctl dialog pacman-contrib exfat-utils wpa_supplicant wireless_tools \
    bash-completion lsb-release mpv inetutils haveged jfsutils logrotate man-db man-pages \
    moreutils tcpdump iotop tlp sdparm hdparm squashfs-tools xdotool lzop simplescreenrecorder \
    archlinux-contrib go expac jq lsd diffutils kdiff3 usbutils dmidecode \
    hunspell-en_us plocate arj unrar pv testdisk ethtool syslinux tree xdg-user-dirs p7zip \
    xterm geany keepassxc ufw pacutils shfs-utils sshfs curlftpfs samba nfs-utils
#
# optional:
# pacman --noconfirm --needed -S memtest86+
#
# mlocate update / https://wiki.archlinux.org/title/List_of_applications/Utilities#File_searching
# updatedb
#
# check manjaro shared packages
# https://github.com/manjaro/manjaroiso/blob/8b6c0142424deb94d96a57b00c470fabc556c361/configs/shared/Packages
systemctl enable NetworkManager
#
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc
#
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^#pt_PT.UTF-8 UTF-8/pt_PT.UTF-8 UTF-8/' /etc/locale.gen
#echo "en_US.UTF-8 UTF-8"                 >> /etc/locale.gen
#echo $countrys'_'$countryb'.UTF-8 UTF-8' >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=pt" > /etc/vconsole.conf
locale-gen
#
echo $hostname > /etc/hostname
#
#mkinitcpio -p linux-lts 2>/dev/null
mkinitcpio -p linux 2>/dev/null
#
useradd -m -g users -G wheel -s /bin/bash $username
echo $username':'$password | chpasswd
echo 'root:'$password | chpasswd
# add user to libvirt group
# gpasswd -a $username libvirt
#
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
echo "GRUB_DISABLE_OS_PROBER=true" >> /etc/default/grub
#
grub-install --target=i386-pc --recheck /dev/$harddisk
grub-mkconfig -o /boot/grub/grub.cfg "$@"
#
cp /etc/default/grub /etc/default/grub.backup
cp /boot/grub/grub.cfg /boot/grub/grub.cfg.backup
#
swapoff -a
dd if=/dev/zero of=/swapfile bs=1M count=2038 status=progress
chmod 600 /swapfile
mkswap /swapfile
cp /etc/fstab.bak /etc/fstab
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
swapon -a
#
timedatectl set-timezone $timezone
systemctl enable systemd-timesyncd
#
#echo 'archlin0x' > /etc/hostname
hostnamectl set-hostname $hostname
#
echo '127.0.0.1 localhost' >> /etc/hosts
echo '127.0.0.1 '$hostname >> /etc/hosts
#
# change system language to $countrys
localectl set-locale LANG=$countrys'_'$countryb'.UTF-8'
# change system language to EN
localectl set-locale LANG=en_US.UTF-8
#
sync
exit 0
#
echo -e "Type umount -a and you may now reboot the machine."
#
