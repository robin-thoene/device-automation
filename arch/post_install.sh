#!/bin/bash

sudo passwd -l root
echo "disabled 'root' login"

#####################
# Installing packages
#####################

echo "[START] - installing packages ..."
packages=(
	# Base
	base-devel
	git
	reflector
	systemd-resolvconf
	# Security
	apparmor
	keepassxc
	sbctl
	ufw
	veracrypt
	# Graphical user interface
	## Display drivers
	intel-media-driver
	mesa
	vulkan-intel
	## Window managers or compositors
	autotiling-rs
	bluez
	brightnessctl
	capitaine-cursors
	fuzzel
	grim
	mako
	qt5-wayland
	qt6-wayland
	slurp
	waybar
	xdg-desktop-portal
	xdg-desktop-portal-gtk
	xorg-xwayland
	## sway
	sway
	swaybg
	swayidle
	swaylock
	## hyprland
	hypridle
	hyprland
	hyprlock
	hyprpaper
	xdg-desktop-portal-hyprland
	## Display manager
	lemurs
	## User directories
	xdg-user-dirs
	# Multimedia
	## Sound system
	pipewire
	pipewire-audio
	pipewire-alsa
	pipewire-pulse
	wireplumber
	# Appearance
	## Fonts
	noto-fonts-emoji
	ttf-font-awesome
	ttf-jetbrains-mono
	ttf-jetbrains-mono-nerd
	ttf-roboto
	# Console improvements
	alacritty
	tmux
	# User applications
	## utility
	android-file-transfer
	bluetui
	exfatprogs
	fd
	firefox
	flac
	fzf
	htop
	ifuse
	impala
	iw
	jq
	macchina
	nmap
	nsxiv
	openssh
	perl-image-exiftool
	playerctl
	pulsemixer
	qt6-tools
	ripgrep
	unzip
	whipper
	wireguard-tools
	wl-clipboard
	yazi
	zathura
	zathura-pdf-poppler
	zip
	## Office
	libreoffice-still
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
	## Communication
	discord
	signal-desktop
	teamspeak3
	thunderbird
	## Entertainment
	mgba-qt
	steam
	vlc
	vlc-plugins-extra
	## Development
	aspnet-runtime
	dbeaver
	cargo-deny
	cargo-edit
	cargo-nextest
	docker
	docker-buildx
	docker-compose
	dotnet-sdk
	gitleaks
	gitui
	go
	hyperfine
	npm
	nuget
	pnpm
	rustup
	tree-sitter-cli
	watchexec
	yarn
	# GrapheneOS (mobile)
	android-tools
	android-udev
)
sudo pacman -S ${packages[@]} --noconfirm --needed
echo "[DONE] - finished installing packages"

############
# Networking
############

sudo systemctl enable systemd-resolved.service

##########
# Security
##########

echo "[START] - configuring security related settings ..."

echo "setting up a firewall ..."
sudo ufw default deny incoming
sudo ufw enable
sudo systemctl enable ufw
echo "done"

echo "setting up apparmor ..."
sudo systemctl enable apparmor
read -p "add apparmor kernel params: https://wiki.archlinux.org/title/AppArmor#Installation"
sudo vim /boot/loader/entries/arch.conf
sudo bootctl update
echo "generated updated boot conf"
echo "done"

echo "[DONE] - configuring security"

####################
# Package management
####################

echo "[START] - configuring package managers ..."

echo "setting up reflector ..."
echo "--country Germany,France" | sudo tee -a /etc/xdg/reflector/reflector.conf
sudo systemctl enable reflector.timer
echo "done"

echo "installing AUR helper ..."
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd ..
echo "done"

echo "[DONE] - configuring package managers"

###################
# Setup environment
###################

echo "[START] - configuring environment ..."

echo "enabling necessary services ..."
sudo systemctl enable bluetooth.service
sudo systemctl enable lemurs.service
echo "done"

# This creates the standard user home directories
echo "creating home directories ..."
xdg-user-dirs-update
echo "done"

# Ensure that all locales are definitely set up
echo "generate locales ..."
sudo locale-gen
echo "done"

# tmux plugin manager
echo "setting up plugin manager for tmux ..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "done"

# oh my zsh installation
export ZDOTDIR=~/.config/zsh
echo "installing oh-my-zsh ..."
if [ -d $ZDOTDIR/oh-my-zsh ]; then
	echo "Oh My Zsh is already installed, skipping installation steps."
else
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi
echo "done"

# Clone the automation repository, containing helper shell scripts
echo "cloning device-automation repositories ..."
git_user_name=robin-thoene
git_user_dir=~/dev/$git_user_name
git_automation_repo_name=device-automation
automation_repo_git_url=https://github.com/$git_user_name/$git_automation_repo_name.git
mkdir -p $git_user_dir
git config --global credential.helper store
cd $git_user_dir && git clone $automation_repo_git_url
echo "done"

# ensure all themes are set initially
echo "setting up application themes ..."
$git_user_dir/$git_automation_repo_name/arch/theme_toggle.sh
echo "done"

# Setup applications directory.
echo "creating application dir ..."
mkdir -p ~/Applications
sudo ln -s /home/robin/Applications/** /usr/bin
echo "done"

# Setup development tools
echo "setting up dev tools ..."
## Dotnet
dotnet tool install --global dotnet-ef
dotnet tool install --global dotnet-outdated-tool
## NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | sh
nvm install --lts
## Rust
rustup default stable
## Docker
sudo systemctl enable docker
sudo usermod -a -G docker robin
echo "done"

echo "[DONE] - configuring environment"
