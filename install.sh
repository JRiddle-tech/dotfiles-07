#!/bin/bash

# Ensure the script is run with root permissions at the beginning:
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

read -p "[!] Enter username: " username
home_dir='/home/'"$username"

# Add additional repositories
apt install software-properties-common -y
apt-add-repository non-free -y
apt-add-repository contrib -y
dpkg --add-architecture amd64


# Set up nvidia environment
read -p "Install Nvidia drivers? [y/n]: " nvidia_prompt
while [[ "$nvidia_prompt" != "y" && "$nvidia_prompt" != "Y" && "$nvidia_prompt" != "n" && "$nvidia_prompt" != "y" && "$nvidia_prompt" != "N" ]]
do	
	echo "Please select y/n"
	read -p "Install Nvidia drivers? [y/n]: " nvidia_prompt
done


if [[ "$nvidia_prompt" == "y" || "$nvidia_prompt" == "Y" ]]; then
	apt install linux-headers-amd64
	wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
	sudo dpkg -i cuda-keyring_1.1-1_all.deb && apt update 
	apt install cuda-toolkit-12-1 -y
	apt install nvidia-settings -y
fi

apt update
apt install xorg i3 pulseaudio alsa-utils gimp wget picom inkscape neofetch xfce4-settings yaru-theme-gtk alacritty thunar steam-devices vim git unzip celluloid gvfs-backends samba cifs-utils smbclient rofi i3blocks geeqie feh xinput maim xclip xdotool libsdl2-2.0-0 libsdl2-dev libsdl2-image-2.0-0 libsdl2-image-dev libsdl2-ttf-2.0-0 libsdl2-ttf-dev libsdl2-mixer-2.0-0 libsdl2-mixer-dev gtk2-engines-murrine gtk2-engines-pixbuf htop libavcodec-extra playerctl gnome-disk-utility rsync pavucontrol gdb flatpak thunar-archive-plugin neovim stow -y
apt install --no-install-recommends xfce4-session -y


flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.vscodium.codium -y
flatpak install flathub com.discordapp.Discord -y
flatpak install flathub com.bitwarden.desktop -y
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub com.spotify.Client -y
flatpak install flathub com.google.Chrome -y
flatpak install flathub com.valvesoftware.Steam -y


apt autoremove dmenu libreoffice-math libreoffice-draw libreoffice-draw libreoffice-impress libreoffice-base -y
apt purge --autoremove gnome-games -y

# Copy all configurations
mkdir -p "$home_dir"/.local/share/wallpapers
mkdir -p "$home_dir"/Pictures/screenshots
mkdir -p "$home_dir"/.scripts

cp -r wallpapers/ "$home_dir"/.local/share/
cp -r .fonts/ "$home_dir"/
cp -r .scripts/ "$home_dir"/.scripts
cp .bashrc "$home_dir"/
cp .vimrc "$home_dir"/

flatpak override --filesystem=xdg-data/themes
flatpak override --filesystem=xdg-data/icons
flatpak override --env=GTK_THEME=Yaru-sage-dark
flatpak override --env=ICON_THEME=Papirus-Dark	


stow i3 i3blocks rofi alacritty dunst #picom 

chown -R "$username":"$username" "$home_dir"/.local
chown -R "$username":"$username" "$home_dir"/.config
chown -R "$username":"$username" "$home_dir"/Pictures/screenshots


# Change permissions for i3blocks scripts files
find "$home_dir"/.config/i3blocks/scripts -type f ! -name '*.*' -exec chmod u+x {} \;
echo "script permissions updated"

xdg-settings set default-web-browser firefox-esr.desktop
xdg-mime default thunar.desktop inode/directory


echo "Reboot your computer to apply the changes!"




