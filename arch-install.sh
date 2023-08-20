#!/bin/bash

echo -e "\nARCH-INSTALL BASIC SYSTEM\n-------------------------\n"

echo -e "Checking connection...\n"
#cheking connection
if [[ $(ping -c1 archlinux.org) ]]; then
    echo -e "Connection OK!\n"
else
    echo -e "Connection not working!\n"
    exit
fi

#mount partitions
echo -e "\nMaking fs and mount disks...\n"
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
mkfs.btrfs -f /dev/sda3
mount /dev/sda3 /mnt
mount --mkdir /dev/sda1 /mnt/boot/efi
swapon /dev/sda2
echo -e "\nComplete! Now installing packages we need to start SO\n"

#install SO base and configure to start with partitions
echo -e "Packages:[ base, linux-zen, linux-zen-headers, linux-firmware, iproute2, nano, dhcpcd, iwd, man ]"
pacstrap -K /mnt --needed base base-devel linux-zen linux-zen-headers linux-firmware iproute2 nano dhcpcd iwd man
genfstab -U /mnt >> /mnt/etc/fstab

echo -e "\nChroot system:\n"
arch-chroot /mnt

echo -e "\nConfigure system:\n"
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
echo LANG=pt_BR.UTF-8 > /etc/locale.conf
echo KEYMAP=br-abnt2 > /etc/vconsole.conf
echo cobaia > /etc/hostname
echo -e "127.0.0.1    localhost\n::1    localhost\n127.0.1.1    cobaia.localdomain    cobaia" >> /etc/hosts

echo -e "\nSet password of root:\n"
passwd

echo -e "\nNow, making uefi grub!\n"
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=[UEFI]Grub-arch --recheck
grub-mkconfig -o /boot/grub/grub.cfg

echo -e "\nBefore reboot, we enable services for use network after reboot\n"
systemctl enable iwd.service
systemctl enable dhcpcd.service
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service

echo -e "bash ~/pos-reboot.sh" >  /root/.bash_profile

echo -e "\nComplete!! Now we can reboot in your new system\n"
