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
  - use RAM size as SWAP size
  - use [this](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS)
    encryption setup when setting up partitions
- install this packages with pacstrap
  - `pacstrap -K /mnt base linux linux-firmware intel-ucode networkmanager vim man-db man-pages texinfo lvm2 grub efibootmgr`
- follow the rest of the installation process
- when reaching **Initramfs** follow [this](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#Configuring_mkinitcpio_3)
  - and be sure to enable [resume](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Configure_the_initramfs) for hibernate
- when reaching the **bootloader** section use
  - [GRUB](https://wiki.archlinux.org/title/GRUB)
  - add kernel parameters [see here](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#Configuring_the_boot_loader_2)
- enable the network manager service
  - `systemctl enable NetworkManager.service`
- execute the [install script](./install.sh)
- execute the [post install script](./post-install.sh)
