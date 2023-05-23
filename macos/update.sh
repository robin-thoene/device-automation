#!/bin/zsh

# Update all packages installed using brew.
brew upgrade
# Source shells.
source ~/.zshrc
source ~/.bashrc
# Install the latest version of node.
nvm install --lts
# Get all globally installed dotnet tool packages.
package_ids=$(dotnet tool list --global | awk 'NR > 2 { print $1 }')
# Update all globally installed dotnet tool packages one by one.
for package_id in $package_ids; do
    dotnet tool update --global $package_id
done
# Update all app store packages.
mas upgrade
