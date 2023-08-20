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

echo -e "\nPreparing the system to configure..."

echo "echo -e '\nConfigure system:\n'" >> /mnt/root/configure.sh
echo "ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime" >> /mnt/root/configure.sh
echo "echo LANG=pt_BR.UTF-8 > /etc/locale.conf" >> /mnt/root/configure.sh
echo "echo KEYMAP=br-abnt2 > /etc/vconsole.conf" >> /mnt/root/configure.sh
echo "echo cobaia > /etc/hostname" >> /mnt/root/configure.sh
echo "echo -e "127.0.0.1    localhost\n::1    localhost\n127.0.1.1    cobaia.localdomain    cobaia" >> /etc/hosts" >> /mnt/root/configure.sh

echo "echo -e '\nSet password of root:\n'" >> /mnt/root/configure.sh
echo "passwd" >> /mnt/root/configure.sh

echo "echo -e '\nNow, making uefi grub!\n'" >> /mnt/root/configure.sh
echo "pacman -S grub efibootmgr" >> /mnt/root/configure.sh
echo "grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=[UEFI]Grub-arch --recheck" >> /mnt/root/configure.sh
echo "grub-mkconfig -o /boot/grub/grub.cfg" >> /mnt/root/configure.sh

echo "echo -e '\nBefore reboot, we enable services for use network after reboot\n'" >> /mnt/root/configure.sh
echo "systemctl enable iwd.service" >> /mnt/root/configure.sh
echo "systemctl enable dhcpcd.service" >> /mnt/root/configure.sh
echo "systemctl enable systemd-networkd.service" >> /mnt/root/configure.sh
echo "systemctl enable systemd-resolved.service" >> /mnt/root/configure.sh

echo "echo -e 'bash ~/pos-reboot.sh' >  /root/.bash_profile" >> /mnt/root/configure.sh

echo "echo -e '\nComplete!! Now we can reboot in your new system\n'" >> /mnt/root/configure.sh

echo -e "\nComplete.\n\nConfiguring the system!!\n"
arch-chroot /mnt bash /root/configure.sh
