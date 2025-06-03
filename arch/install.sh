#!/bin/bash

packages=(
	sudo
	posix
	zsh
	neovim
)

read -p "Enable the multilib repository"
vim /etc/pacman.conf
pacman -Syyu --noconfirm
pacman -S ${packages[@]} --noconfirm
chsh -s /bin/zsh
echo "Changed default shell to 'zsh'"

echo -e "[device]\nwifi.backend=iwd" >>/etc/NetworkManager/conf.d/wifi_backend.conf
echo "Set iwd as wifi backend for the NetworkManager"

user_name=robin
useradd -m -G wheel -s /bin/zsh $user_name
echo "Created user '$user_name'"
echo "Set the password for the user '$user_name'"
passwd $user_name

read -p "Edit the 'sudoers' file and allow the 'wheel' group"
visudo

read -p "Changing to user '$user_name'"
su - $user_name

sudo passwd -l root
echo "Disabled 'root' login"
