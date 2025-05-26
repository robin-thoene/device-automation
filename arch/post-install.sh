#!/bin/bash

# This script installs and configures Arch Linux after the initial setup process following
# this general post installation recommendations that are relevant for this setup
# https://wiki.archlinux.org/title/General_recommendations

## Security

packages=(
	apparmor
	keepassxc
	qt5-wayland
	ufw
	veracrypt
)

sudo pacman -S ${packages[@]} --noconfirm --needed

sudo ufw default deny incoming
sudo ufw enable
echo "Firewall is set up"

sudo systemctl enable apparmor
read -p "Add apparmor kernel params: https://wiki.archlinux.org/title/AppArmor#Installation"
sudo vim /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo "Generated updated GRUB conf"

# Package management

## Mirrors

sudo pacman -S reflector --noconfirm --needed
sudo systemctl enable reflector.timer
echo "--country Germany,France" | sudo tee -a /etc/xdg/reflector/reflector.conf
echo "Enabled regular mirror list check"

## Arch User Repository

packages=(
	base-devel
	git
)

sudo pacman -S ${packages[@]} --noconfirm --needed
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

sudo pacman -S ${packages[@]} --noconfirm --needed
echo "Installed graphic drivers"

## Window managers or compositors

packages=(
	autotiling-rs
	fuzzel
	capitaine-cursors
	sway
	mako
	bluez
	swaybg
	swayidle
	swaylock
	waybar
)

sudo pacman -S ${packages[@]} --noconfirm --needed
sudo systemctl enable bluetooth.service
echo "Set up compositor and it's dependencies"

## Display manager

sudo pacman -S lemurs --noconfirm --needed
sudo systemctl enable lemurs.service
echo "Set display manager"

## User directories

sudo pacman -S xdg-user-dirs --noconfirm --needed
xdg-user-dirs-update
echo "Created user directories"

# Multimedia

## Sound system

packages=(
	pipewire
	wireplumber
	pipewire-audio
	pipewire-alsa
	pipewire-pulse
)

sudo pacman -S ${packages[@]} --noconfirm --needed
echo "Set up audio"

# Appearance

## Fonts

packages=(
	noto-fonts-emoji
	ttf-jetbrains-mono
	ttf-roboto
	ttf-jetbrains-mono-nerd
)

sudo pacman -S ${packages[@]} --noconfirm --needed

## Lang: Ensure all languages are generated successful
sudo locale-gen

# Checkout dotfiles (must be done before installing oh-my-zsh)
git clone --bare https://github.com/robin-thoene/dotfiles.git $HOME/dev/robin-thoene/dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/dev/robin-thoene/dotfiles --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout

# Console improvements

packages=(
	alacritty
	tmux
)

sudo pacman -S ${packages[@]} --noconfirm --needed
echo "Installing Oh My Zsh..."
if [ -d $ZDOTDIR/oh-my-zsh ]; then
	echo "Oh My Zsh is already installed, skipping installation steps."
else
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
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
	unzip
	wl-clipboard
	zathura
	zathura-pdf-poppler
	bluetui
	ranger
	htop
	pulsemixer
	wireguard-tools
)

sudo pacman -S ${packages[@]} --noconfirm --needed

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

sudo pacman -S ${packages[@]} --noconfirm --needed

## Communication

packages=(
	thunderbird
	discord
	signal-desktop
)

sudo pacman -S ${packages[@]} --noconfirm --needed

## Entertainment

packages=(
	vlc
	steam
	mgba-qt
)

sudo pacman -S ${packages[@]} --noconfirm --needed

## Development

echo "Installing development packages..."

packages=(
	dotnet-sdk
	aspnet-runtime
	npm
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

sudo pacman -S ${packages[@]} --noconfirm --needed

echo "Done."

### Dotnet
dotnet tool install --global dotnet-ef

### NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | sh
nvm install --lts

### Rust
rustup default stable

### Docker
sudo systemctl enable docker
sudo usermod -a -G docker robin

read -p "Rebooting now"
sudo reboot
