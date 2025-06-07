# Arch

## Summary

This is the (automated) setup process for creating a software developer machine using
[Arch Linux](https://archlinux.org/).

## Status

🟠 This setup is currently in development and should not be used on any production machine

## Installation instructions

TODO: enable secure boot

For now, the installation of Arch Linux will be done within this setup following the
[official documentation](https://wiki.archlinux.org/title/Installation_guide#).

Here are some noteworthy choices to make during the installation process:

- create partition layout
  - `/boot` = 1G
  - `/` = 100%FREE
  - use [this](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS)
    encryption setup when setting up partitions
    - use RAM size as SWAP size
    - use remaining space for root
- install this packages with pacstrap
  - `pacstrap -K /mnt base linux linux-firmware intel-ucode networkmanager iwd vim man-db man-pages texinfo lvm2`
- follow the rest of the installation process
- when reaching **Initramfs** follow [this](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#Configuring_mkinitcpio_3)
  - and be sure to enable [resume](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Configure_the_initramfs) for hibernate
- when reaching the **bootloader** section use
  - [systemd-boot](https://wiki.archlinux.org/title/Systemd-boot)
  - add kernel parameters
    - [get the UUID of cryptdevice](https://wiki.archlinux.org/title/Persistent_block_device_naming#by-uuid)
    - [needed param](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#Configuring_the_boot_loader_2)
    - [for systemd-boot](https://wiki.archlinux.org/title/Systemd-boot#Adding_loaders)
- enable the network manager service
  - `systemctl enable NetworkManager.service`
- execute the [install script](./install.sh)
- reboot and login as the created user
- execute the [post install script](./post-install.sh)
