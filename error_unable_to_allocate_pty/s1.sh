#!/bin/bash

# 1. Copia de seguridad del pacman.conf original
cp /etc/pacman.conf /etc/pacman.conf.bak

echo "--- 1. Desactivando verificación de firmas temporalmente ---"
# Cambia todos los SigLevel a Never para poder saltar el error de GPGME
sed -i 's/SigLevel    = .*/SigLevel = Never/g' /etc/pacman.conf

echo "--- 2. Forzando actualización de glibc y librerías base ---"
# Intentamos actualizar solo lo crítico primero
pacman -Sy --noconfirm glibc lib32-glibc gcc-libs

echo "--- 3. Intentando actualización completa del sistema ---"
pacman -Su --noconfirm

echo "--- 4. Restaurando configuración de seguridad ---"
mv /etc/pacman.conf.bak /etc/pacman.conf

echo "--- 5. Reintentando inicializar el llavero ahora que glibc debería funcionar ---"
rm -rf /etc/pacman.d/gnupg
pacman-key --init
pacman-key --populate archlinux

echo "--- Proceso completado. Prueba a instalar algo ahora. ---"
