#!/bin/bash

UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/manjaro_recovery"

echo "--- LIMPIEZA QUIRÚRGICA DE BINARIOS Y LIBRERÍAS ---"

# 1. Montaje limpio
umount -R $TARGET 2>/dev/null
mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $TARGET

# 2. BORRADO MANUAL (Lo que pacman no está logrando limpiar bien)
echo "Borrando binarios y librerías base para evitar conflictos de símbolos..."
rm -f $TARGET/usr/bin/bash
rm -f $TARGET/usr/bin/sh
rm -f $TARGET/usr/lib/libreadline.so*
rm -f $TARGET/usr/lib/libhistory.so*
rm -f $TARGET/usr/lib/libssl.so*
rm -f $TARGET/usr/lib/libcrypto.so*

# 3. REINSTALACIÓN EXTERNA (Desde el Live USB al Disco)
echo "Reinstalando paquetes base (Modo Root)..."
pacman --root $TARGET -Sy --noconfirm --overwrite "*" \
    bash readline openssl glibc ncurses coreutils

# 4. TRASPLANTE DE SEGURIDAD
# Copiamos el bash del Live USB al disco para asegurar que el primer arranque sea posible
echo "Instalando binario de respaldo..."
cp /usr/bin/bash $TARGET/usr/bin/bash

# 5. RECONSTRUCCIÓN DE ENLACES
ldconfig -r $TARGET

# 6. Montar sistemas virtuales
for i in dev dev/pts proc sys run; do mount --bind /$i $TARGET/$i; done

echo "--------------------------------------------------"
echo " INTENTO DE ENTRADA CON BASH REEMPLAZADO "
echo "--------------------------------------------------"
chroot $TARGET /usr/bin/bash --login
