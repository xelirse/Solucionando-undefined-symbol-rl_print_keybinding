#!/bin/bash

pacman --sysroot /mnt -Sy --noconfirm glibc gcc-libs lib32-glibc
pacman --sysroot /mnt -Su

chroot /mnt
pacman-key --init
pacman-key --populate archlinux manjaro
# Si usas Chaotic-AUR:
pacman-key --populate chaotic
exit

pacman --sysroot /mnt -Sy --noconfirm --gpgdir /etc/pacman.d/gnupg glibc gcc-libs lib32-glibc
