#!/bin/bash

UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/manjaro_recovery"

echo "--- REPARACIÓN DEFINITIVA: KEYRING + LIBRERÍAS ---"

# 1. Montaje y limpieza de archivos conflictivos
umount -R $TARGET 2>/dev/null
mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $TARGET

echo "Eliminando archivos que bloquean ldconfig..."
rm -f $TARGET/usr/lib/libssl.so.3
rm -f $TARGET/usr/lib/libcrypto.so.3

# 2. Actualizar llaves del Live USB (esto evita el error de Frederik Schwan)
echo "Actualizando llaves de Manjaro/Arch..."
pacman -Sy --noconfirm archlinux-keyring manjaro-keyring

# 3. Instalación Forzada (Ignorando chequeo de llaves si es necesario)
# Usamos --dbpath para asegurarnos de que pacman vea lo que hay en el disco
echo "Reinstalando base crítica con bypass de seguridad..."
pacman --root $TARGET -S --noconfirm --overwrite "*" \
    --siglevel PackageRequired bash readline openssl glibc ncurses

# 4. Reconstrucción de enlaces
echo "Reconstruyendo base de datos de librerías..."
ldconfig -r $TARGET

# 5. Binds de sistema
for i in dev dev/pts proc sys run; do mount --bind /$i $TARGET/$i; done

echo "--------------------------------------------------"
echo " INTENTANDO ENTRAR AL CHROOT "
echo "--------------------------------------------------"

# Intentamos entrar. Si el error de 'symbol lookup' persiste,
# inyectaremos la librería de forma directa antes del chroot.
if ! chroot $TARGET /usr/bin/bash --login; then
    echo "Error de símbolos detectado. Aplicando parche de emergencia..."
    cp -d /usr/lib/libreadline.so.8* $TARGET/usr/lib/
    chroot $TARGET /usr/bin/bash --login
fi
