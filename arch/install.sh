#!/bin/bash

packages=(
	sudo
	posix
	zsh
	neovim
)

pacman -Syyu --noconfirm
pacman -S ${packages[@]} --noconfirm
chsh -s /bin/zsh
echo "Changed default shell to 'zsh'"

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
