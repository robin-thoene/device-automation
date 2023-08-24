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
echo "Your password is required once for installing packages:"
sudo pacman -Syu --noconfirm
echo "Done."

################
### Install git.
################

echo "Installing and setting up git..."
sudo pacman -S git --noconfirm
git config --global credential.helper store
git config --global user.name "$git_author_name"
git config --global user.email "$git_author_email"
echo "Done."

###########################
# Kitty with Dracula theme.
###########################

echo "Install kitty terminal and configure Dracula theme..."
sudo pacman -S kitty --noconfirm
cd $git_dracula_dir && git clone https://github.com/dracula/kitty.git
cp $git_dracula_dir/kitty/dracula.conf ~/.config/kitty/
echo "include dracula.conf" >> ~/.config/kitty/kitty.conf
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
    # Install the dracula theme.
    cd $git_dracula_dir && git clone https://github.com/dracula/zsh.git
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
echo 'alias update_all="~/dev/'"$git_user_name"'/'"$git_automation_repo_name"'/arch/update.sh"' >>~/.zshrc

###########
### Utility
###########

echo "Installing utility packages..."
sudo pacman -S keepass --noconfirm
sudo pacman -S veracrypt --noconfirm
sudo pacman -S firefox --noconfirm
sudo pacman -S fzf --noconfirm
echo "if [ -x /usr/bin/fzf  ]
        then
                source /usr/share/fzf/key-bindings.zsh
fi" >> ~/.zshrc
echo "Done."

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
echo "Done."

###############
### Development
###############

echo "Installing development packages..."

# Dotnet
sudo pacman -S dotnet-sdk --noconfirm
dotnet tool install --global dotnet-ef

# PWSH
dotnet tool install --global PowerShell

# NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | sh
source ~/.zshrc
nvm install --lts

# CLI
sudo pacman -S yarn --noconfirm
sudo pacman -S podman --noconfirm
curl -L https://aka.ms/InstallAzureCli | sh
sudo pacman -S nuget --noconfirm

# Tools
sudo pacman -S mysql-workbench --noconfirm

echo "Done."

#########################
### Install AUR packages.
#########################

echo "Installing AUR packages..."
sudo pacman -S yay --noconfirm
yay -S visual-studio-code-bin --noconfirm
yay -S postman-bin --noconfirm
yay -S logseq-desktop-bin --noconfirm
echo "Done."