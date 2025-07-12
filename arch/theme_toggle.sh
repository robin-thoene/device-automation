#!/bin/bash

# get details about the current theme
current=$(gsettings get org.gnome.desktop.interface color-scheme)

# alacritty
alacritty_conf_dir=~/.config/alacritty
alacritty_light_colors=$alacritty_conf_dir/catppuccin-latte.toml
alacritty_dark_colors=$alacritty_conf_dir/catppuccin-mocha.toml
alacritty_colors_conf=$alacritty_conf_dir/colors.toml

# sway
sway_conf_dir=~/.config/sway
sway_light_colors=$sway_conf_dir/theme/catppuccin-latte
sway_dark_colors=$sway_conf_dir/theme/catppuccin-mocha
sway_colors_conf=$sway_conf_dir/theme/colors

# hyprland
hyprland_conf_dir=~/.config/hypr
hyprland_light_colors=$hyprland_conf_dir/themes/latte.conf
hyprland_dark_colors=$hyprland_conf_dir/themes/mocha.conf
hyprland_colors_conf=$hyprland_conf_dir/themes/colors.conf

# waybar
waybar_conf_dir=~/.config/waybar
waybar_light_colors=$waybar_conf_dir/theme/catppuccin-latte.css
waybar_dark_colors=$waybar_conf_dir/theme/catppuccin-mocha.css
waybar_colors_conf=$waybar_conf_dir/theme/colors.css

# fuzzel
fuzzel_conf_dir=~/.config/fuzzel
fuzzel_light_colors=$fuzzel_conf_dir/catppuccin-latte.ini
fuzzel_dark_colors=$fuzzel_conf_dir/catppuccin-mocha.ini
fuzzel_colors_conf=$fuzzel_conf_dir/colors.ini

# mako
mako_conf_dir=~/.config/mako
mako_light_colors=$mako_conf_dir/catppuccin-latte
mako_dark_colors=$mako_conf_dir/catppuccin-mocha
mako_colors_conf=$mako_conf_dir/colors

# yazi
yazi_conf_dir=~/.config/yazi
yazi_light_colors=$yazi_conf_dir/catppuccin-latte.toml
yazi_dark_colors=$yazi_conf_dir/catppuccin-mocha.toml
yazi_colors_conf=$yazi_conf_dir/theme.toml

echo "$current"

if [[ "$current" == "'prefer-dark'" ]]; then
	ln -sf $alacritty_light_colors $alacritty_colors_conf
	ln -sf $sway_light_colors $sway_colors_conf
	ln -sf $hyprland_light_colors $hyprland_colors_conf
	ln -sf $waybar_light_colors $waybar_colors_conf
	ln -sf $fuzzel_light_colors $fuzzel_colors_conf
	ln -sf $mako_light_colors $mako_colors_conf
	ln -sf $yazi_light_colors $yazi_colors_conf

	gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
else
	ln -sf $alacritty_dark_colors $alacritty_colors_conf
	ln -sf $sway_dark_colors $sway_colors_conf
	ln -sf $hyprland_dark_colors $hyprland_colors_conf
	ln -sf $waybar_dark_colors $waybar_colors_conf
	ln -sf $fuzzel_dark_colors $fuzzel_colors_conf
	ln -sf $mako_dark_colors $mako_colors_conf
	ln -sf $yazi_dark_colors $yazi_colors_conf

	gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
fi

makoctl reload
swaymsg reload
