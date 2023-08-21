#!/bin/bash

echo -e "WELLCOME BACK!! Now we configure your system for u!"
#install sudoers and configure ur user
echo -e "Checking connection...\n"
if [[ $(ping -c1 google.com) ]]; then
    echo -e "Connection OK!\n"
else
    echo -e "Not working! Check your connection and run this again\n"
    exit
fi

#making new user and configure your desktop
echo -e "\nConfiguring your user:\n"
pacman -S --needed sudo sway polkit swayidle swaylock waybar wofi git pulseaudio pulseaudio-alsa alsa-utils light mako chromium thunar
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#Configuring user and sudo
useradd -m -G wheel,power,audio,storage,video -U k90s
sed -i '/s/# %wheel ALL(ALL:ALL) ALL/ %wheel ALL(ALL:ALL) ALL/' /etc/passwd

echo -e "\nConfiguring your desktop\n"
su k90s
cd ~
git clone https://github.com/mdmk4os/dotfiles.git
cd dotfiles
mv * ~/.config/
rm -rf ~/dotfiles
#echo -e "\nInstalling ohmyzsh\n"
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo -e "\nSetting to start sway on login.\n"
mv ~/.bash_profile ~/.bash_profile.bkp
echo -e "if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]];then\n    XKB_DEFAULT_LAYOUT=br exec sway\nfi" > ~/.bash_profile
