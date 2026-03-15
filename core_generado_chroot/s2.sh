#!/bin/bash

pacman --root /mnt --cachedir /mnt/var/cache/pacman/pkg --dbpath /mnt/var/lib/pacman -S glibc bash readline coreutils --overwrite "*"
cp -v /usr/bin/busybox /mnt/busybox
chroot /mnt /busybox sh
