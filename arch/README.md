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
  - and be sure to enable [resume](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Configure_the_initramfs) for hibernate
- install this packages with pacstrap
  - `pacstrap -K /mnt base linux linux-firmware intel-ucode networkmanager neovim man-db man-pages texinfo lvm2 grub efibootmgr`
- follow the rest of the installation process
- when reaching **Initramfs** follow [this](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#Configuring_mkinitcpio_3)
- when reaching the **bootloader** section use
  - [GRUB](https://wiki.archlinux.org/title/GRUB)
  - add kernel parameters [see here](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#Configuring_the_boot_loader_2)
- enable the network manager service
  - `systemctl enable NetworkManager.service`
  - `systemctl start NetworkManager.service`

Execute the following commands to finish the initial installation:

```shell
packages=(
	posix
	zsh
)

pacman -Syyu --noconfirm
pacman -S ${packages[@]} --noconfirm
chsh -s /bin/zsh
echo "Changed default shell to 'zsh'"

user_name=robin
useradd -m -G wheel -s /bin/zsh $user_name
echo "Created user '$user_name'"
echo "Set the password for the user '$user_name'"
passwd $user_name
pacman -S sudo --noconfirm
read -p "Edit the 'sudoers' file and allow the 'wheel' group"
visudo
read -p "Changing to user '$user_name'"
su - $user_name
sudo passwd -l root
echo "Disabled 'root' login"
```
