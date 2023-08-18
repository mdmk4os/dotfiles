# Dotfiles sway tiling manager

> [!IMPORTANT]
> These configuration files and arch installation script are made for my VM. But if you want to use it for your installation, just follow the steps

# Pré-install
> #### Run arch.iso and configure your keyboard, network and reset/format disks
To enable brazilian keyboard
```shell
# loadkeys=br-abnt2
```
Configure WIFI, arch-iso comes with daemon wireless **iwd**: try `systemctl status iwd`
```shell
# iwctl station <device> connect <SSID>
```
> [!NOTE]
> if you're in wired connection: try `systemctl status dhcpcd`

To format the disks, I will use my example VM, using `cfdisk <device>` we can reset:
```
dev/sdaX. DISK gpt 40G
          sda1. EFI partition 341M
          sda2. Swap partition 2G
          sda3. / partition 37.659GB
```
After that, we can move on to the assembly process already included in the [install script](arch-install.sh)
<!-- Pré- install 
  - rodar a iso e configurar o acesso ao teclado e internet
  - formatar e configurar discos, partições LVM
-->
# Installation 
> #### Here we will mount the partitions, configure them and install/configure the base system enough to be able to use it after reboot

For my machine we can just run the install script
```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/mdmk4os/dotfiles/main/arch-install.sh)"
```
But for those of who are installing it on your machine, let's break down the script into a step-by-step

1. #### Fs and Mount partitions
   Here we will mount the partitions according to the previous formatting
   ```
   mkfs.fat -F32 /dev/sda1 && mkswap /dev/sda2 && mkfs.btrfs -f /dev/sda3
   mount /dev/sda3 /mnt && swapon /dev/sda2 && mount --mkdir /dev/sda1 /mnt/boot/efi
   ```
   In case ur partition structure is different, just change the command.
2. #### Install kernel and app base
   Using the command `pacstrap <path/to/mount> [list of packages]` we will install the base inside our already mounted partition.
   
   We are also going to generate the fstab file, so that when restarting the machine it will recognize the partitions.
   ```shell
   pacstrap -K /mnt base linux-zen linux-zen-headers linux-firmware iproute2 nano dhcpcd iwd man
   genfstab -U /mnt >> /mnt/etc/fstab
   ```
3. #### Chroot system
   Now let's configure some personal things, like keyboard, language, hostname and root password

   First, chroot your system
   ```
   arch-chroot /mnt
   ```
   ```shell
   ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
   echo LANG=pt_BR.UTF-8 > /etc/locale.conf
   echo KEYMAP=br-abnt2 > /etc/vconsole.conf
   echo cobaia > /etc/hostname
   echo -e "127.0.0.1    localhost\n::1    localhost\n127.0.1.1    cobaia.localdomain    cobaia" >> /etc/hosts
   passwd
   ```
5. #### GRUB Install
   > [!WARNING]
   > I use the EFI boot system in my VM, if ur configuration is MBR, I suggest you replace it with the MBR boot system installation
   ```shell
   pacman -S grub efibootmgr
   grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=[UEFI]Grub-arch --recheck
   grub-mkconfig -o /boot/grub/grub.cfg
   ```
6. #### Enable services for reboot
   While we are in chroot, the system has an internet connection through the parent machine, so let's enable the necessary network services for the internet to work as soon as we restart the machine.
   ```shell
   systemctl enable iwd.service
   systemctl enable dhcpcd.service
   systemctl enable systemd-networkd.service
   systemctl enable systemd-resolved.service
   ```
<!-- Install Base 
  - Formatar e montar partiçoes
  - instalar o sistema base com literalmente o básico para o computador funcionar e conversar com a internet
  - Configurações extras e pessoais, futuramente vou ativar escolhas
  - Configurar home/senha root
  - Instalar grub e aqruivos de inicialização
  - Ativar serviços de rede e alguns extras para o pos reboot
-->
## teste2
<!-- Pós- Reboot
  - Checkar conectividade com a rede e os serviços ativos
  - instalar pacotes necessários para rodar o sistema tilling manager
  - adicionar usuario principal e configurar o sudo
  - configurar desktop
