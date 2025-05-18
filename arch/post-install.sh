#!/bin/bash

# This script installs and configures Arch Linux after the initial setup process following
# this general post installation recommendations that are relevant for this setup
# https://wiki.archlinux.org/title/General_recommendations

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

sudo systemctl enable --now apparmor
read -p "Add apparmor kernel params: https://wiki.archlinux.org/title/AppArmor#Installation"
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
echo "Installing Oh My Zsh..."
if [ -d $ZDOTDIR/oh-my-zsh ]; then
	echo "Oh My Zsh is already installed, skipping installation steps."
else
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
echo "Done."

# Old install script content (manjaro-sway)

## setting up git stuff

git_user_name=robin-thoene
git_user_dir=~/dev/$git_user_name
git_automation_repo_name=device-automation
automation_repo_git_url=https://github.com/$git_user_name/$git_automation_repo_name.git
mkdir -p $git_user_dir
git config --global credential.helper store

## ensure this repo is always available

cd $git_user_dir && git clone $automation_repo_git_url

## Setup applications directory.

mkdir -p ~/Applications
sudo ln -s /home/robin/Applications /usr/bin

## utility

packages=(
	nsxiv
	firefox
	fzf
	fd
	ripgrep
	ifuse
	macchina
)

sudo pacman -S ${packages[@]} --noconfirm

## LaTeX

packages=(
	texlive-basic
	texlive-bin
	texlive-binextra
	texlive-fontsextra
	texlive-fontsrecommended
	texlive-langgerman
	texlive-latex
	texlive-latexextra
	texlive-latexrecommended
	texlive-pictures
)

sudo pacman -S ${packages[@]} --noconfirm

## Communication

packages=(
	thunderbird
	discord
	signal-desktop
)

sudo pacman -S ${packages[@]} --noconfirm

## Entertainment

packages=(
	vlc
	steam
	mgba-qt
)

sudo pacman -S ${packages[@]} --noconfirm

## Development

echo "Installing development packages..."

packages=(
	dotnet-sdk
	aspnet-runtime
	yarn
	pnpm
	docker
	docker-buildx
	docker-compose
	nuget
	gitleaks
	rustup
	mysql-workbench
	dbeaver
	tree-sitter-cli
	gitui
)

sudo pacman -S ${packages[@]} --noconfirm

echo "Done."

### Dotnet
dotnet tool install --global dotnet-ef

### NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | sh

### Rust
rustup default stable

### Docker
sudo systemctl enable --now docker
