#!/bin/bash

packages=(
	sudo
	posix
	zsh
	neovim
)

read -p "enable the multilib repository"
vim /etc/pacman.conf
pacman -Syyu --noconfirm
pacman -S ${packages[@]} --noconfirm
chsh -s /bin/zsh
echo "changed default shell to 'zsh'"

echo -e "[device]\nwifi.backend=iwd" >>/etc/NetworkManager/conf.d/wifi_backend.conf
echo "set iwd as wifi backend for the NetworkManager"

echo -e "[DriverQuirks]\nPowerSaveDisable=*" >>/etc/iwd/main.conf
echo "disabled wifi powersave globally"

user_name=robin
useradd -m -G wheel -s /bin/zsh $user_name
echo "created user '$user_name'"
echo "set the password for the user '$user_name'"
passwd $user_name

read -p "edit the 'sudoers' file and allow the 'wheel' group"
visudo

read -p "changing to user '$user_name'"
su - $user_name
