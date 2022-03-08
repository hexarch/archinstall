#!/bin/bash
#
set -o xtrace
#
cat /etc/pacman.d/mirrorlist
pacman -S --noconfirm reflector rsync dialog
#
hostname="arch9000"
username="lino"
password="123"
timezone="Europe/Lisbon"
countryn="Portugal"
countrys="pt"
countryb="PT"
vconsole="pt_latin1"
harddisk="vda"
mirrorsv="http://192.168.122.207:8080"
#
dialog  --begin 10 30 \
        --backtitle "System Information - version 0.1-3" \
        --title "About" \
        --msgbox "\n\
Below are the defaults for the setup.\n\
Next you will confirm one by one\n\n\n\
hostname=$hostname\n\
username=$username\n\
password=$password\n\
timezone=$timezone\n\
countryn=$countryn\n\
countrys=$countrys\n\
countryb=$countryb\n\
vconsole=$vconsole\n\
harddisk=$harddisk\n\
mirrorsv=$mirrorsv" 22 52
#
response=1
while [ $response -eq 1 ]; do
    hostname=$(dialog --inputbox "System name"          15 35 $hostname --output-fd 1)
    username=$(dialog --inputbox "Username"             15 35 $username --output-fd 1)
    password=$(dialog --inputbox "Password"             15 35 $password --output-fd 1)
    timezone=$(dialog --inputbox "Timezone"             15 35 $timezone --output-fd 1)
    countryn=$(dialog --inputbox "Country long name"    15 35 $countryn --output-fd 1)
    countrys=$(dialog --inputbox "Keyboard"             15 35 $countrys --output-fd 1)
    countryb=$(dialog --inputbox "Country code"         15 35 $countryb --output-fd 1)
    vconsole=$(dialog --inputbox "Console country keyb" 15 35 $vconsole --output-fd 1)
    harddisk=$(dialog --inputbox "HD device"            15 35 $harddisk --output-fd 1)
    mirrorsv=$(dialog --inputbox "Local mirror"         15 35 $mirrorsv --output-fd 1)
#
dialog --title "ArchLinux Lin0x scripts" \
--backtitle "Linux Shell Script Tutorial Example" \
--yesno "You happy with those?\n\n\
username=$username\n\
password=$password\n\
timezone=$timezone\n\
countryn=$countryn\n\
countrys=$countrys\n\
countryb=$countryb\n\
vconsole=$vconsole\n\
harddisk=$harddisk\n\
mirrorsv=$mirrorsv\n" 15 30
#                     |  |
# --------------------/--/ these 2 numbers are the parameter for dialog
#
    response=$?
done
#
noww=$(date '+%d/%m/%Y %H:%M:%S')
echo "ArchLinux Lin0x scripts choosen settings "$noww  > settings.txt
echo "System name ="             $hostname >> settings.txt
echo "Username ="                $username >> settings.txt
echo "Password ="                $password >> settings.txt
echo "Timezone ="                $timezone >> settings.txt
echo "Country long name ="       $countryn >> settings.txt
echo "Keyboard ="                $countrys >> settings.txt
echo "Country code ="            $countryb >> settings.txt
echo "Console country keyb ="    $vconsole >> settings.txt
echo "HD device ="               $harddisk >> settings.txt
echo "Local mirror ="            $mirrorsv >> settings.txt
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
#
#x=10
#while [ $x -gt 0 ]
#do
#    sleep 1s
#    #clear
#    echo "$x seconds to start the script"
#    x=$(( $x - 1 ))
#done
#
#timedatectl --no-ask-password set-timezone $timezone
#timedatectl --no-ask-password set-ntp 1
#timedatectl set-ntp true
#timedatectl status
#
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

if [ "$mirrorsv" = "" ]; then
    reflector -a 48 -c $countryn -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
else
	echo "Server = "$mirrorsv >  /etc/pacman.d/mirrorlist
fi
#
# https://wiki.archlinux.org/title/Pacman
# https://wiki.archlinux.org/title/System_maintenance#Partial_upgrades_are_unsupported
# https://wiki.archlinux.org/title/Pacman/Tips_and_tricks
pacman -Sy
pacman --noconfirm --needed -S - < packages.txt
#
# optional:
# pacman --noconfirm --needed -S memtest86+
#
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc
#
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
if [ "$countryb" != "US" ]; then
    sed -i 's/^#'$countrys'_'$countryb'.UTF-8 UTF-8/'$countrys'_'$countryb'.UTF-8 UTF-8/' /etc/locale.gen
fi
#
#echo "en_US.UTF-8 UTF-8"                 >> /etc/locale.gen
#echo $countrys'_'$countryb'.UTF-8 UTF-8' >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
# https://wiki.archlinux.org/title/Category:Keyboard_configuration
# https://wiki.archlinux.org/title/Linux_console/Keyboard_configuration#Persistent_configuration
echo "KEYMAP=$vconsole" > /etc/vconsole.conf
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
cp *.sh /home/$username
cp packages.txt /home/$username
# add user to libvirt group
# gpasswd -a $username libvirt
#
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
#
#echo "GRUB_DISABLE_OS_PROBER=true" >> /etc/default/grub
#
grub-install --target=i386-pc --recheck /dev/$harddisk
grub-mkconfig -o /boot/grub/grub.cfg "$@"
#
cp /etc/default/grub /etc/default/grub.backup
cp /boot/grub/grub.cfg /boot/grub/grub.cfg.backup
#
swapoff -a
dd if=/dev/zero of=/swapfile bs=1M count=2048 status=progress
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
systemctl enable NetworkManager
#
sync
#
#
exit 0
#
echo -e "Type umount -a and you may now reboot the machine."
#
