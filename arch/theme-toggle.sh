#!/bin/bash

alacritty_conf_dir=~/.config/alacritty
current=$(gsettings get org.gnome.desktop.interface color-scheme)
light_colors=$alacritty_conf_dir/catppuccin-latte.toml
dark_colors=$alacritty_conf_dir/catppuccin-mocha.toml
alacritty_colors_conf=$alacritty_conf_dir/colors.toml

echo "$current"

if [[ "$current" == "'prefer-dark'" ]]; then
	echo "$light_colors"
	echo "$alacritty_colors_conf"

	ln -sf $light_colors $alacritty_colors_conf
	gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
else
	ln -sf $dark_colors $alacritty_colors_conf
	gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
fi

swaymsg reload
