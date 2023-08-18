# Dotfiles sway tiling manager

> [!IMPORTANT]
> These configuration files and arch installation script are made for my VM. But if you want to use it for your installation, just follow the steps

# Pré-install
> #### Run arch.iso and configure your keyboard, network and reset/format disks
To enable brazilian keyboard
```
# loadkeys=br-abnt2
```
Configure WIFI, arch-iso comes with daemon wireless **iwd**: try `systemctl status iwd`
```
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
