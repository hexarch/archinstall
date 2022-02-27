# ArchLinux install scripts with XFS filesystem and virtual QEMU or real environments
### easy to setup scripts for VirtualBox and EXT4
-----------------------
## on console:
- type passwd and set a root password like 123
- type "ip -c a" and copy the IPv4

## for BIOS + QEMU vda + XFS on an ssh session:
- type "ssh root@ip-you-got-before" 
- if it says key error, type "rm .ssh/know_hosts" or edit the file and remove the new IP
- optional: type "echo "Server = http://192.168.122.207:8080" > /etc/pacman.d/mirrorlist" for a custom packages cache
- type "pacman -Sy"
- type "pacman -S git vim nano dialog"
- type "git clone https://github.com/hexarch/archinstall" & cd archinstall
- type "bash 10-QEMU-bios-vda-xfs.sh"
- type "arch-chroot /mnt"
- type "bash 20-new-system.sh"
- type "exit" and "umount -a" and "reboot now"

- logon into the new system
- type "30-final-config.sh"
- use other script to install XFCE4, GNOME, PLASMA
  --------------------------
