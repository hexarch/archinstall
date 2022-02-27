# on console:
- type passwd and set a root password like 123
- type "ip -c a" and copy the IPv4

# for BIOS + QEMU vda + XFS on an ssh session:
- type "ssh root@<ip-you-got-before>" 
- if it says key error, type "rm .ssh/know_hosts" or edit the file and remove the new IP
- type "git clone https://github.com/hexarch/archinstall"
- type "pacman -Sy"
- type "pacman -S git vim nano dialog"
- type "10-QEMU-bios-vda-xfs.sh"
- type "bash 20-new-system.sh"
  
  
  
  
old stuff  
archinstall
ArchLinux install scripts with XFS or EXT4 filesystem and virtual (QEMU/VBox) or real environments

For Virtual environments:
- boot ArchLinux ISO
- on console type "passwd" and choose "123" twice
- type "ip -c a" to see what is the IPv4 that we have now

On a terminal:
- type "ssh root@<ip-you-got-before>" 
- if it says key error, type "rm .ssh/know_hosts" or edit the file and remove the new IP
- type "git clone https://github.com/hexarch/archinstall"
- type "pacman -Sy"
- type "pacman -S git vim nano dialog"
- pick one script from the 10 or 11 categories, choosing QEMU/VB and XFS/EXT4
- type "bash 20-new-system.sh"
