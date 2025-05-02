# Arch

## Summary

This is the (automated) setup process for creating a software developer machine using
[Arch Linux](https://archlinux.org/).

## Status

🟠 This setup is currently in development and should not be used on any production machine

## Installation instructions

For now, the installation of Arch Linux will be done within this setup following the
[official documentation](https://wiki.archlinux.org/title/Installation_guide#).

Here are some noteworthy choices to make during the installation process:

- create a standard partition layout
  - `/boot`
  - `[SWAP]`
  - `/`
  - use [this](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS)
    encryption setup when setting up partitions
- install this packages with pacstrap
  - `pacstrap -K /mnt base linux linux-firmware intel-ucode networkmanager neovim man-db man-pages texinfo lvm2 grub efibootmgr`
- follow the rest of the installation process
- when reaching **Initramfs** follow [this](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#Configuring_mkinitcpio_3)
- when reaching the **bootloader** section use
  - [GRUB](https://wiki.archlinux.org/title/GRUB)
  - add kernel parameters [see here](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#Configuring_the_boot_loader_2)
