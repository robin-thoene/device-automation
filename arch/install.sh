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
# TODO: add waybar modules
# TODO: style waybar
# TODO: style sway

## Display manager

sudo pacman -S lemurs --noconfirm
sudo systemctl enable --now lemurs.service
echo "Set display manager"

## User directories

sudo pacman -S xdg-user-dirs --noconfirm
xdg-user-dirs-update
echo "Created user directories"

# Power management

## Laptops

sudo pacman -S brightnessctl --noconfirm

# Multimedia

## Sound system

packages=(
	pipewire
	wireplumber
	pipewire-audio
	pipewire-alsa
	pipewire-pulse
	pipewire-jack
)

sudo pacman -S ${packages[@]} --noconfirm
sudo systemctl enable --now pipewire-pulse.service
echo "Set up audio"

# Networking

## DNS security

# TODO: research if something really needs to be done about this after the default installation

# Appearance

## Fonts

packages=(
	ttf-jetbrains-mono
	ttf-roboto
)

sudo pacman -S ${packages[@]} --noconfirm

# Console improvements

packages=(
	alacritty
	tmux
)

sudo pacman -S ${packages[@]} --noconfirm
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
