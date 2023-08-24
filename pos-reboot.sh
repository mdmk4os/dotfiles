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
fi

<<POSREBOOT
checkar conectividade com a rede e os serviços ativos
instalar pacotes necessários para rodar o sistema tilling manager
adicionar usuario principal e configurar o sudo
configurar desktop
POSREBOOT

#installing packages neededs to run your desktop
echo -e "\nConfiguring your user:\n"

####INSTALL: desktop; tools like panel, terminal, menu, browser and file-explorer; modules of audio and brightness; and fonts
#this pac use light and mako
#PACKAGES="sudo sway polkit swayidle swaylock waybar wofi git pulseaudio pulseaudio-alsa alsa-utils light mako chromium thunar"
PACKAGES="sway polkit swaybg swayidle swaylock waybar wofi kitty chromium thunar git pulseaudio pulseaudio-alsa alsa-utils brightnessctl nerd-fonts ttf-font-awesome"
pacman -S --needed $PACKAGES

#ohmyzsh - after make other adjusts
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#Configuring user and sudo
USERNAME="k90s"
USERHOME="/home/$USERNAME"
useradd -m -G wheel,power,audio,storage,video -U $USERNAME
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
passwd $USERNAME

#configuring desktop with dotfiles and adjusts
echo "cd $USERHOME" >> $USERHOME/conf-desk.sh
echo "git clone https://github.com/mdmk4os/dotfiles.git" >> $USERHOME/conf-desk.sh
echo "mkdir -p $USERHOME/.config/" >> $USERHOME/conf-desk.sh
#if u want it to replace, remove the -n
echo "mv -n $USERHOME/dotfiles/.config/* $USERHOME/.config/" >> $USERHOME/conf-desk.sh
echo "echo -e '\nThis is ur new setup\n'" >> $USERHOME/conf-desk.sh
echo "ls $USERHOME/.config/" >> $USERHOME/conf-desk.sh

echo -e "\nConfiguring your desktop\n"
su k90s -c sh -c "$($USERHOME/conf-desk.sh)"

echo -e "\nSetting to start sway on login.\n"
mv $USERHOME/.bash_profile $USERHOME/.bash_profile.bkp
echo -e "if [[ -z \$DISPLAY ]] && [[ $(tty) = /dev/tty1 ]];then\n    XKB_DEFAULT_LAYOUT=br exec sway\nfi" > $USERHOME/.bash_profile

echo -e "\nRemoving temp files\n"
rm -rf $USERHOME/dotfiles
rm -rf $USERHOME/.bash_profile.bkp

echo -e "\n!! Complete !!\n"
