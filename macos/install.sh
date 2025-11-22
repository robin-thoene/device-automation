#!/bin/bash

# This script installs and configures my macOS setup for working environments.

#################
### Initial setup
#################

# Ask for sudo upfront.
echo "Some operations need sudo privileges. Please enter your password."
sudo -v
# Ask user for required information.
read -p "Enter your work company name: " company_name
# Define needed variables.
git_user_name=robin-thoene
git_automation_repo_name=device-automation
git_user_dir=~/dev/$git_user_name
git_company_dir=~/dev/$company_name
# Create the directory to store git repos.
mkdir -p $git_user_dir
mkdir -p $git_company_dir

###################################
### Apply operating system settings
###################################

echo "Setting up operating system settings..."
defaults write .GlobalPreferences com.apple.mouse.scaling -1
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1
defaults write com.apple.dock tilesize -integer 20
killall Dock
echo "Done."

###########################
### Install package manager
###########################

echo "Installing brew..."
xcode-select --install
which -s brew
if [[ $? != 0 ]]; then
    yes '' | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>/Users/$USER/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    brew update
fi
echo "Done."

##############################
### Install blocking packages.
##############################

echo "Installing blocking packages please stay here and enter credentials as needed..."
brew install --cask dotnet-sdk
brew install --cask microsoft-teams
echo "Done. You can now go and let the script install the rest."

################
### Install git.
################

echo "Installing git..."
brew install git
echo "Done."

###############
### Install ZSH
###############

echo "Installing Zsh and Oh My Zsh..."
# Zsh
if ! brew list zsh &>/dev/null; then
    # Install Zsh.
    brew install zsh
    # Install Oh My Zsh.
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
echo "Done."

###########
### Browser
###########

echo "Installing browsers..."
brew install --cask firefox
brew install --cask google-chrome
echo "Done."

###########
### Utility
###########

echo "Installing utility packages..."
brew install logitech-options
brew install fzf
brew install fd
brew install ripgrep
echo "Done."

###############
### Development
###############

echo "Installing development packages..."
# CLI
brew install --cask powershell
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
# Install latest LTS version of node.
nvm install --lts
brew install yarn
brew install docker
brew install azure-cli
brew install gitleaks
brew install watchexec
brew install gitui

# SDK
dotnet tool install --global dotnet-ef
dotnet tool install --global dotnet-outdated-tool

# IDE / Editor
brew install --cask font-jetbrains-mono-nerd-font
brew install neovim

# GUI Tools
brew install --cask microsoft-azure-storage-explorer
brew install --cask azure-data-studio
brew install --cask redisinsight
echo "Done."

##############
# Manual steps
##############

read -p "Get the dotfiles"
read -p "Ensure the company mail is set in gitconfig if needed!"
