#!/bin/bash

# This script installs and configures Arch Linux after the initial setup process following
# this general post installation recommendations that are relevant for this setup
# https://wiki.archlinux.org/title/General_recommendations

# System administration

packages=(
	posix
	zsh
)
pacman -Syyu
pacman -S ${packages[@]} --noconfirm
chsh -s /bin/zsh
echo "Changed default shell to 'zsh'"

## Users and groups

user_name=robin
useradd -m -G wheel -s /bin/zsh $user_name
echo "Created user '$user_name'"
echo "Set the password for the user '$user_name'"
passwd $user_name
pacman -S sudo --noconfirm
read -p "Edit the 'sudoers' file and allow the 'wheel' group"
visudo
read -p "Changing to user '$user_name'"
su - $user_name
sudo passwd -l root
echo "Disabled 'root' login"

## Security

packages=(
	apparmor
	keepassxc
	ufw
	veracrypt
)

sudo pacman -S ${packages[@]} --noconfirm

sudo ufw default deny incoming
sudo systemctl enable --now ufw
echo "Firewall is set up"

# see: https://wiki.archlinux.org/title/AppArmor#Installation
sudo systemctl enable --now apparmor
read -p "Add apparmor kernel params"
sudo vi /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo "Generated updated GRUB conf"

# Package management

## Mirrors

sudo pacman -S reflector --noconfirm
sudo systemctl enable --now reflector.timer
echo "--country Germany,France" | sudo tee -a /etc/xdg/reflector/reflector.conf
echo "Enabled regular mirror list check"

## Arch User Repository

packages=(
	base-devel
	git
)

sudo pacman -S ${packages[@]} --noconfirm
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd .. && rm -rf yay
echo "Installed AUR helper"

# Graphical user interface

## Display drivers

packages=(
	mesa
	vulkan-intel
)

sudo pacman -S ${packages[@]} --noconfirm
echo "Installed graphic drivers"

## Window managers or compositors

packages=(
	alacritty
	autotiling-rs
	bemenu-wayland
	sway
	swaybg
	swayidle
	swaylock
	waybar
)

sudo pacman -S ${packages[@]} --noconfirm
echo "Set up compositor and it's dependencies"
# TODO: rewrite sway config from scratch

## Display manager

sudo pacman -S lemurs --noconfirm
sudo systemctl enable lemurs.service

## User directories

sudo pacman -S xdg-user-dirs --noconfirm
xdg-user-dirs-update

# Power management

## ACPI events

### TODO

## CPU frequency scaling

### TODO

## Laptops

### TODO

## Suspend and hibernate

### TODO

# Multimedia

## Sound system

### TODO

# Networking

## DNS security

### TODO

## Setting up a firewall

### TODO

## Network shares

### TODO

# Input devices

## Keyboard layouts

### TODO

## Mouse buttons

### TODO

## Laptop touchpads

### TODO

## TrackPoints

### TODO

# Optimization

## Benchmarking

### TODO

## Improving performance

### TODO

## Solid state drives

### TODO

# System services

## File index and search

### TODO

## Local mail delivery

### TODO

## Printing

### TODO

# Appearance

## Fonts

### TODO

## GTK and Qt themes

### TODO

# Console improvements

echo "Installing Zsh and Oh My Zsh..."
if [ -d ~/.oh-my-zsh ]; then
	echo "ZSH is already installed, skipping installation steps."
else
	# Install zsh and oh my zsh and set it as default.
	sudo pacman -S zsh --noconfirm
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	echo "Your password is required to change the default shell to zsh:"
	chsh -s $(which zsh)
fi
echo "Done."

## Tab-completion enhancements

### TODO

## Aliases

### TODO

## Alternative shells

### TODO

## Bash additions

### TODO

## Colored output

### TODO

## Compressed files

### TODO

## Console prompt

### TODO

## Emacs shell

### TODO

## Mouse support

### TODO

## Session management

### TODO
