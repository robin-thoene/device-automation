#!/bin/sh

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
git_dracula_dir=~/dev/dracula
automation_repo_git_url=https://github.com/$git_user_name/$git_automation_repo_name.git
# Create the directory to store git repos.
mkdir -p $git_user_dir
mkdir -p $git_company_dir
mkdir -p $git_dracula_dir

#####################
# Update and upgrade.
#####################

echo "Update installed packages..."
apt-get -y update && apt-get -y upgrade
echo "Done."

###################################
### Apply operating system settings
###################################

echo "Setting up operating system settings..."
# Mouse
gsettings set org.gnome.desktop.peripherals.mouse natural-scroll true
gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'
# Keyboard
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 10
gsettings set org.gnome.desktop.peripherals.keyboard delay 120
# Dock
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 22
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.shell.extensions.dash-to-dock multi-monitor true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
# Color scheme
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
# Wallpaper
cd $git_dracula_dir && git clone https://github.com/dracula/wallpaper.git
cd $git_dracula_dir/wallpaper/first-collection
wallpaper_path=$(pwd)
gsettings set org.gnome.desktop.background picture-uri "file://$wallpaper_path/ubuntu-1.png"
# GTK dracula theme
wget -O ~/Downloads/Dracula.zip https://github.com/dracula/gtk/archive/master.zip
unzip ~/Downloads/Dracula.zip -d ~/Downloads/
mv ~/Downloads/gtk-master /usr/share/themes/Dracula
rm ~/Downloads/Dracula.zip
gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
gsettings set org.gnome.desktop.wm.preferences theme "Dracula"
# GTK dracula icons
wget -O ~/Downloads/Dracula-Icons.zip https://github.com/dracula/gtk/files/5214870/Dracula.zip
unzip ~/Downloads/Dracula-Icons.zip -d ~/Downloads/
mv ~/Downloads/Dracula /usr/share/icons/Dracula
rm ~/Downloads/Dracula-Icons.zip
gsettings set org.gnome.desktop.interface icon-theme "Dracula"
echo "Done."

################
### Install git.
################

echo "Installing and setting up git..."
apt-get install -y git
git config --global credential.helper store
git config --global user.name "$git_author_name"
git config --global user.email "$git_author_email"
echo "Done."

#################################
# Dracula theme for the terminal.
#################################

echo "Configure Dracula theme for the terminal..."
apt-get install -y dconf-cli
cd $git_dracula_dir && git clone https://github.com/dracula/gnome-terminal && cd gnome-terminal
./install.sh -s Dracula --skip-dircolors
echo "Done."

#############################
### Clone the automation repo
#############################

cd $git_user_dir && git clone $automation_repo_git_url

###############
### Install ZSH
###############

echo "Installing Zsh and Oh My Zsh..."
if zsh --version >/dev/null; then
    echo "ZSH is already installed, skipping installation steps."
else
    # Install zsh and oh my zsh and set it as default.
    apt-get install -y zsh
    sh -c "$(wget https://raw.githubusercontent.ohmyzsh/com/ohmyzsh/master/tools/install.sh -O -)"
    chsh -s $(which zsh)
    # Install the dracula theme.
    c git clone https://github.com/dracula/zsh.git
    ln -s $git_dracula_dir/zsh/dracula.zsh-theme ~/.oh-my-zsh/themes/dracula.zsh-theme
    # Activate the dracula theme.
    sed -i 's/robbyrussell/dracula/g' ~/.zshrc
    echo 'export DRACULA_DISPLAY_NEW_LINE=1' >>~/.zshrc
fi
echo "Done."

###############
### Set aliases
###############

echo 'alias gfc="git fetch && git checkout"' >>~/.zshrc
echo 'alias startdev="podman machine start && podman start storage-dev redis-dev mssql-dev"' >>~/.zshrc
echo 'alias stopdev="podman stop storage-dev redis-dev mssql-dev && podman machine stop"' >>~/.zshrc
echo 'alias update_all="~/dev/'"$git_user_name"'/'"$git_automation_repo_name"'/ubuntu/update.sh"' >>~/.zshrc

###########
### Utility
###########

echo "Installing utility packages..."
apt-get install -y keepassx
add-apt-repository -y ppa:unit193/encryption
apt-get install -y veracrypt
echo "Done."

###############
### Development
###############

echo "Installing development packages..."
# Dotnet
apt-get install -y dotnet-sdk-7.0
dotnet tool install --global dotnet-ef

# NVM
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
echo "export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"" >>~/.zshrc
source ~/.zshrc
nvm install --lts

# CLI
npm install --global yarn
apt-get install -y podman
wget -qO- https://aka.ms/InstallAzureCLIDeb | bash
apt-get install -y nuget
snap install --classic powershell

# IDE / Editor
snap install --classic code
snap install --classic rider

# Tools
snap install storage-explorer
snap connect storage-explorer:password-manager-service :password-manager-service
snap install postman
snap install mysql-workbench-community
snap connect mysql-workbench-community:password-manager-service
echo "Done."

#################
### Communication
#################

echo "Installing communication packages..."
apt-get install -y thunderbird
snap install discord
snap connect discord:system-observe
snap install signal-desktop
echo "Done."

#########
### Media
#########

echo "Installing media packages..."
apt-get install -y vlc
echo "Done."

##############
# Manual steps
##############

# Prepare manual installation processes.
apt-get install -y libfuse2
# Install clock extension.
read -p "Install and setup Frippery Move Clock extension."
# Install and setup logseq.
read -p "Install logseq from here: https://logseq.com/"
read -p "Open logseq and install the Dracula theme."
# Install azure data studio.
read -p "Download azure data studio from here: https://learn.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver16&tabs=ubuntu-install%2Credhat-uninstall#install-azure-data-studio"
azuredatastudio_deb_name=$(ls ~/Downloads | grep azuredatastudio-linux-)
dpkg -i ~/Downloads/$azuredatastudio_deb_name
rm ~/Downloads/$azuredatastudio_deb_name
# MySQL Workbench
read -p "Download MySQL Workbench from here: https://dev.mysql.com/downloads/workbench/"
mysql_workbench_deb_name=$(ls ~/Downloads | grep mysql-workbench-community)
dpkg -i ~/Downloads/$mysql_workbench_deb_name
