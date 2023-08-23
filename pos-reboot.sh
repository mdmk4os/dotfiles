#!/bin/bash

echo -e "WELLCOME BACK!! Now we configure your system for u!"
#install sudoers and configure ur user
echo -e "Checking connection...\n"
if [[ $(ping -c1 archlinux.org) ]]; then
    echo -e "Connection OK!\n"
else
    #echo -e "Not working! Check your connection and run this again\n"
    echo -e "Trying connect the last connection"
    iwctl station wlan0 connect luwifi
    exit
fi

''' instalação
rodar iso e configurar acesso ao teclado e internet
zerar e configurar discos
formatar e montar partiçoes
instalar o sistema base com literalmente o básico para o computador funcionar e conversar com a internet
configurações extras e pessoais, futuramente vou ativar escolhas
configurar home/senha root
instalar grub e aqruivos de inicialização
ativar serviços de rede e alguns extras para o pos reboot

reiniciar

checkar conectividade com a rede e os serviços ativos
instalar pacotes necessários para rodar o sistema tilling manager
adicionar usuario principal e configurar o sudo
configurar desktop
'''

#installing packages neededs to run your desktop
echo -e "\nConfiguring your user:\n"
#this pac use light and mako
#pacman -S --needed sudo sway polkit swayidle swaylock waybar wofi git pulseaudio pulseaudio-alsa alsa-utils light mako chromium thunar

#install: desktop; tools like panel, terminal, menu, browser and file-explorer; modules of audio and brightness; and fonts
pacman -S --needed sway polkit swaybg swayidle swaylock waybar wofi kitty chromium thunar git pulseaudio pulseaudio-alsa alsa-utils brigthnessctl nerd-fonts ttf-font-awesome

#ohmyzsh - after make other adjusts
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#Configuring user and sudo
USERNAME="k90s"
useradd -m -G wheel,power,audio,storage,video -U $USERNAME
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

#configuring desktop with dotfiles and adjusts
echo "cd ~" >> $USERNAME/conf-desk.sh
echo "git clone https://github.com/mdmk4os/dotfiles.git" >> $USERNAME/conf-desk.sh
echo "mkdir -p ~/.config/" >> $USERNAME/conf-desk.sh
#if u want it to replace, remove the -n
echo "mv -n ~/dotfiles/.config/* ~/.config/" >> $USERNAME/conf-desk.sh
echo "echo -e '\nThis is ur new setup\n'" >> $USERNAME/conf-desk.sh
echo "ls ~/.config/" >> $USERNAME/conf-desk.sh

echo -e "\nConfiguring your desktop\n"
su k90s -c bash $USERNAME/conf-desk.sh

echo -e "\nSetting to start sway on login.\n"
mv ~/.bash_profile ~/.bash_profile.bkp
echo -e "if [[ -z \$DISPLAY ]] && [[ $(tty) = /dev/tty1 ]];then\n    XKB_DEFAULT_LAYOUT=br exec sway\nfi" > $USERNAME/.bash_profile

echo -e "\nRemoving temp files\n"
rm -rf $USERNAME/dotfiles
rm -rf $USERNAME/.bash_profile.bkp

echo -e "\n!! Complete !!\n"
