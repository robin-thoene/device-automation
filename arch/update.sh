#!/bin/bash

# Update all packages.
sudo pacman -Syu --noconfirm
# Get all globally installed dotnet tool packages.
package_ids=$(dotnet tool list --global | awk 'NR > 2 { print $1 }')
# Update all globally installed dotnet tool packages one by one.
for package_id in $package_ids; do
	dotnet tool update --global $package_id
done
# Update Rust toolchain.
rustup update
# Update nvim.
nvim --headless +"lua require('lazy').sync()" +qa
