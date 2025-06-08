# Arch

## Summary

This is the (automated) setup process for creating a software developer machine using
[Arch Linux](https://archlinux.org/).

## Status

🟠 This setup is currently in development and should not be used on any production machine

## Installation instructions

### 1. Manual Arch installation

At the start is the official, manual Arch installation process as documented
[here](https://wiki.archlinux.org/title/Installation_guide#).

The following steps describe certain options to pick or steps to take:

1. Partitioning
   1. create the following **layout**
      1. /boot = 1G
      2. / (root) = 100% of left space
   2. setup **LVM on LUKS** as described [here](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS)
      1. use RAM size as **swap**
      2. use remaining space as **root**
      3. use **ext4** for the **root** file system
      4. use **fat -F32** for **boot** file system
2. Install essential packages
   1. command: `pacstrap -K /mnt base linux linux-firmware intel-ucode networkmanager iwd vim man-db man-pages texinfo lvm2`
3. Initramfs
   1. edit the config using `vim /etc/mkinitcpio.conf`
   2. add **encrypt** and **lvm2** to the HOOKS as described [here](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#Configuring_mkinitcpio_3)
   3. enable [resume](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Configure_the_initramfs) for hibernate
   4. regenerate config using `mkinitcpio -P`
4. Boot loader
   1. install **systemd-boot** as described [here](https://wiki.archlinux.org/title/Systemd-boot)
   2. add kernel parameters
      1. get the UUID of your encrypted partition (cryptdevice) as described [here](https://wiki.archlinux.org/title/Persistent_block_device_naming#by-uuid)
      2. create a new loader entry as described [here](https://wiki.archlinux.org/title/Systemd-boot#Adding_loaders)
      3. add the kernel parameters to the new loader entry as described [here](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#Configuring_the_boot_loader_2)
5. Enable network service
   1. command: `systemctl enable NetworkManager.service`

### 2. Arch chroot

This script is meant to be run after you finalized the manual Arch install, but before you rebooted.

1. download the [install script](./install.sh)
2. execute the script
3. reboot and login as the newly created user

### 3. User installation

1. setup wifi connection with **iwctl** as described [here](https://wiki.archlinux.org/title/Iwd#Connect_to_a_network)
2. get the [post install script](./post_install.sh)
3. execute the script
4. restore the personal [dotfiles](https://github.com/robin-thoene/dotfiles)
5. execute `~/dev/robin-thoene/device-automation/arch/theme_toggle.sh`
6. reboot

### 4. Secure boot

TODO: enable secure boot, try using [sbctl](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#Assisted_process_with_sbctl)
