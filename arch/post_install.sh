#!/bin/bash

#####################
# Installing packages
#####################
echo "[START] - Installing packages ..."
packages=(
	# Base
	base-devel
	git
	# Security
	apparmor
	keepassxc
	ufw
	veracrypt
	# Graphical user interface
	## Display drivers
	mesa
	vulkan-intel
	## Window managers or compositors
	autotiling-rs
	bluez
	capitaine-cursors
	fuzzel
	mako
	qt5-wayland
	sway
	swaybg
	swayidle
	swaylock
	waybar
	xdg-desktop-portal
	xdg-desktop-portal-gtk
	xdg-desktop-portal-wlr
	xorg-xwayland
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
	ttf-jetbrains-mono
	ttf-jetbrains-mono-nerd
	ttf-roboto
	# Console improvements
	alacritty
	tmux
	# User applications
	## utility
	bluetui
	fd
	firefox
	fzf
	htop
	ifuse
	jq
	macchina
	nsxiv
	pulsemixer
	ranger
	ripgrep
	unzip
	wireguard-tools
	wl-clipboard
	zathura
	zathura-pdf-poppler
	## LaTeX
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
	## Development
	aspnet-runtime
	dbeaver
	docker
	docker-buildx
	docker-compose
	dotnet-sdk
	gitleaks
	gitui
	npm
	nuget
	pnpm
	rustup
	tree-sitter-cli
	mysql-workbench
	yarn
)
sudo pacman -S ${packages[@]} --noconfirm --needed
echo "[DONE] - Finished installing packages"

##########
# Security
##########

echo "[START] - Configuring security related settings ..."

echo "Setting up a firewall ..."
sudo ufw default deny incoming
sudo ufw enable
echo "Done"

echo "Setting up apparmor ..."
sudo systemctl enable apparmor
read -p "Add apparmor kernel params: https://wiki.archlinux.org/title/AppArmor#Installation"
sudo vim /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo "Generated updated GRUB conf"
echo "Done"

echo "[DONE] - Configuring security"

####################
# Package management
####################

echo "[START] - Configuring package managers ..."

echo "Setting up reflector ..."
echo "--country Germany,France" | sudo tee -a /etc/xdg/reflector/reflector.conf
sudo systemctl enable reflector.timer
echo "Done"

echo "Installing AUR helper ..."
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd .. && rm -rf yay
echo "Done"

echo "[DONE] - Configuring package managers"

###################
# Setup environment
###################

echo "[START] - Configuring environment ..."

echo "Enabling necessary services ..."
sudo systemctl enable bluetooth.service
sudo systemctl enable lemurs.service
echo "Done"

# This creates the standard user home directories
echo "Creating home directories ..."
xdg-user-dirs-update
echo "Done"

# Ensure that all locales are definitely set up
echo "Generate locales ..."
sudo locale-gen
echo "Done"

# Restore dotfiles
echo "Restoring dotfiles ..."
git clone --bare https://github.com/robin-thoene/dotfiles.git $HOME/dev/robin-thoene/dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/dev/robin-thoene/dotfiles --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout
echo "Done"

# tmux plugin manager
echo "Setting up plugin manager for tmux ..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
echo "Done"

# oh my zsh installation
echo "Installing oh-my-zsh ..."
if [ -d $ZDOTDIR/oh-my-zsh ]; then
	echo "Oh My Zsh is already installed, skipping installation steps."
else
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi
echo "Done"

# Clone the automation repository, containing helper shell scripts
echo "Cloning device-automation repositories ..."
git_user_name=robin-thoene
git_user_dir=~/dev/$git_user_name
git_automation_repo_name=device-automation
automation_repo_git_url=https://github.com/$git_user_name/$git_automation_repo_name.git
mkdir -p $git_user_dir
git config --global credential.helper store
cd $git_user_dir && git clone $automation_repo_git_url
echo "Done"

# ensure all themes are set initially
echo "Setting up application themes ..."
$git_user_dir/$git_automation_repo_name/arch/theme_toggle.sh
echo "Done"

# Setup applications directory.
echo "Creating application dir ..."
mkdir -p ~/Applications
sudo ln -s /home/robin/Applications /usr/bin
echo "Done"

# Setup development tools
echo "Setting up dev tools ..."
## Dotnet
dotnet tool install --global dotnet-ef
## NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | sh
nvm install --lts
## Rust
rustup default stable
## Docker
sudo systemctl enable docker
sudo usermod -a -G docker robin
echo "Done"

echo "[DONE] - Configuring environment"

#####
# Fin
#####

read -p "Rebooting now"
sudo reboot
