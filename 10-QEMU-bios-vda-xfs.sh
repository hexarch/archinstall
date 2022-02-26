#!/bin/bash
#
# REMOVE FROM THIS LINE UP TO "EXIT 16"
# ================================================
#echo -e "You need to edit this file before executing it."
#echo -e "Remove 3 lines at the start of the script (2 echo and 1 exit)"
#exit 16
#
#set -o xtrace
#
countryn="Portugal"
harddisk="vda"
#
clear
echo -e ''
echo -e ''
echo -e '***********************************************'
echo -e 'ArchLinux Lin0x scripts - BIOS/XFS  base script'
echo -e '***********************************************'
echo -e ''
echo -e 'This script will FORMAT hard disk '$harddisk' and configure mirrors for '$countryn
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
timedatectl set-ntp true
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
pacman -S --noconfirm reflector rsync
reflector -a 48 -c $countryn -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist
#
# This is for darkhttp server for local packages cache
# echo "Server = http://192.168.122.207:8080" >  /etc/pacman.d/mirrorlist
#
umount /dev/$harddisk'1' -f -l
dd bs=1M if=/dev/zero of=/dev/$harddisk count=500
sgdisk -Z /dev/$harddisk
echo 'type=83' | sudo sfdisk /dev/$harddisk -f
partx -u /dev/$harddisk
mkfs.xfs  /dev/$harddisk'1' -f
#
mount /dev/$harddisk'1' /mnt
cp -R *.sh /mnt
#
pacman -Sy
pacstrap /mnt base vim nano xfsprogs
genfstab -U /mnt >> /mnt/etc/fstab
cp /mnt/etc/fstab /mnt/etc/fstab.bak
#
cp -R *.sh /mnt
#
echo -e '// NOTE:'
echo -e '// If you need to repeat the base install script, you do need to reboot and download'
echo -e '// the script again'
echo -e '//'
echo -e '// ================='
echo -e '// LIN0X BASE SCRIPT'
echo -e '// ================='
echo -e '// If you need to configure something before chrooting on the new system, do it now."'
echo -e '// Then to continue the configuration, type "arch-chroot /mnt" and proceed with next'
echo -e '// scripts.'
echo -e '//'
echo -e '// next command: arch-chroot /mnt'
echo -e '// next command: bash 40.sh'
echo -e '//'
echo -e '//  >>> If you need to start over, please reboot and execute "bash 10.sh" again <<<'
echo -e '//'
#
exit 0
