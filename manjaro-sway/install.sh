#!/bin/bash

# This script installs and configures my Manjaro Linux with sway setup.

#################
### Initial setup
#################

# Ask user for required information.
read -p "Enter your work company name: " company_name
# Define needed variables.
git_user_name=robin-thoene
git_author_name="Robin Thöne"
git_author_email="110201991+robin-thoene@users.noreply.github.com"
git_automation_repo_name=device-automation
git_user_dir=~/dev/$git_user_name
git_company_dir=~/dev/$company_name
automation_repo_git_url=https://github.com/$git_user_name/$git_automation_repo_name.git
# Create the directory to store git repos.
mkdir -p $git_user_dir
mkdir -p $git_company_dir

#####################
# Update and upgrade.
#####################

echo "Update installed packages..."
echo "Your password is required once for installing packages:"
sudo pacman-mirrors --fasttrack
sudo pacman -Syu --noconfirm
echo "Done."

###################################
### Apply operating system settings
###################################

echo "Applying operating system settings..."
# Install needed fonts.
sudo pacman -S ttf-jetbrains-mono-nerd --noconfirm
sudo pacman -S noto-fonts-emoji --noconfirm
sudo pacman -S pkgconf --noconfirm
# Setup applications directory.
mkdir -p ~/Applications
sudo ln -s /home/robin/Applications /usr/bin
# Remove clipboard history.
sudo pacman -R cliphist --noconfirm
echo "Done."

###############
### Install git
###############

echo "Installing and setting up git..."
sudo pacman -S git --noconfirm
git config --global credential.helper store
git config --global user.name "$git_author_name"
git config --global user.email "$git_author_email"
echo "Done."

#############################
### Clone the automation repo
#############################

cd $git_user_dir && git clone $automation_repo_git_url

###############
### Install ZSH
###############

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

############
### Security
############

# Ensure no one can use my local dev services on the network
sudo pacman -S ufw --noconfirm
sudo ufw default deny incoming
sudo systemctl enable ufw
sudo ufw enable

###########
### Utility
###########

echo "Installing utility packages..."
sudo pacman -S alacritty --noconfirm
sudo pacman -S nsxiv --noconfirm
sudo pacman -S keepassxc --noconfirm
sudo pacman -S veracrypt --noconfirm
sudo pacman -S firefox --noconfirm
sudo pacman -S fzf --noconfirm
sudo pacman -S fd --noconfirm
sudo pacman -S ripgrep --noconfirm
sudo pacman -S brightnessctl --noconfirm
sudo pacman -S gnome-keyring --noconfirm
sudo pacman -S seahorse --noconfirm
sudo pacman -S ifuse --noconfirm
sudo pacman -S macchina --noconfirm
echo "Done."

#########
### LaTeX
#########

sudo pacman -S texlive-basic --noconfirm
sudo pacman -S texlive-bin --noconfirm
sudo pacman -S texlive-binextra --noconfirm
sudo pacman -S texlive-fontsextra --noconfirm
sudo pacman -S texlive-fontsrecommended --noconfirm
sudo pacman -S texlive-langgerman --noconfirm
sudo pacman -S texlive-latex --noconfirm
sudo pacman -S texlive-latexextra --noconfirm
sudo pacman -S texlive-latexrecommended --noconfirm
sudo pacman -S texlive-pictures --noconfirm

#################
### Communication
#################

echo "Installing communication packages..."
sudo pacman -S thunderbird --noconfirm
sudo pacman -S discord --noconfirm
sudo pacman -S signal-desktop --noconfirm
sudo pacman -S teamspeak3 --noconfirm
echo "Done."

#########
### Media
#########

echo "Installing media packages..."
sudo pacman -S vlc --noconfirm
sudo pacman -S steam --noconfirm
sudo pacman -S mgba-qt --noconfirm
echo "Done."

###############
### Development
###############

echo "Installing development packages..."

# Dotnet
sudo pacman -S dotnet-sdk --noconfirm
sudo pacman -S aspnet-runtime --noconfirm
dotnet tool install --global dotnet-ef

# NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | sh
nvm install --lts

# CLI
sudo pacman -S yarn --noconfirm
sudo pacman -S pnpm --noconfirm
sudo pacman -S docker --noconfirm
sudo pacman -S docker-buildx --noconfirm
sudo pacman -S docker-compose --noconfirm
sudo pacman -S nuget --noconfirm
sudo pacman -S gitleaks --noconfirm

# Rust
sudo pacman -S rustup --noconfirm
rustup default stable

# Tools
sudo pacman -S tmux --noconfirm
sudo pacman -S mysql-workbench --noconfirm
sudo pacman -S dbeaver --noconfirm
sudo pacman -S neovim --noconfirm
sudo pacman -S tree-sitter-cli --noconfirm
sudo pacman -S gitui --noconfirm

echo "Done."

########################
### Install AUR packages
########################

echo "Installing AUR packages..."
sudo pacman -S yay --noconfirm
echo "Done."
