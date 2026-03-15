#!/bin/bash

UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/manjaro_recovery"

echo "--- BUSCANDO BINARIO DE EMERGENCIA EN LIVE USB ---"

# 1. Montaje
umount -R $TARGET 2>/dev/null
mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $TARGET

# 2. Localizar un shell que funcione en el Live USB
# Intentamos buscar el binario de zsh o sh del Live USB
RESCUE_SHELL=""
for s in /usr/bin/zsh /bin/sh /usr/bin/sh; do
    if [ -f "$s" ]; then
        RESCUE_SHELL=$s
        break
    fi
done

echo "Usando $RESCUE_SHELL como salvavidas..."
cp "$RESCUE_SHELL" $TARGET/rescue_shell
chmod +x $TARGET/rescue_shell

# 3. Limpiar el PATH y forzar librerías del LIVE USB dentro del chroot
# Esto es un truco sucio: montamos las librerías del Live USB encima de las del disco
echo "Montaje preventivo de librerías del Live USB sobre el disco..."
mount --bind /usr/lib $TARGET/usr/lib

# 4. Binds de sistema
for i in dev dev/pts proc sys run; do mount --bind /$i $TARGET/$i; done

echo "--------------------------------------------------"
echo " INTENTO DE ENTRADA CON SHELL TRANSPLANTADO "
echo "--------------------------------------------------"
chroot $TARGET /rescue_shell
