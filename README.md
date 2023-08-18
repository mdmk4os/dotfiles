# Dotfiles sway tiling manager

> [!IMPORTANT]
> these configuration files and arch installation script are made for my VM

# Pré-install
> ### Run arch.iso and configure your keyboard, network and reset/format disks

### To enable brazilian keyboard
```
# loadkeys=br-abnt2
```
### Configure WIFI, arch-iso comes with daemon wireless **iwd**: try `systemctl status iwd`
```
# iwctl station <device> connect <SSID>
```
> [!NOTE]
> if you're in wired connection: try `systemctl status dhcpcd`

<!-- Pré- install 
  - rodar a iso e configurar o acesso ao teclado e internet
  - formatar e configurar discos, partições LVM
-->
## [Teste](#teste2)
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
