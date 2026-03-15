#!/bin/bash

UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/manjaro_recovery"

echo "--- OPERACIÓN BYPASS: USANDO LIBRERÍAS DEL LIVE ---"

# 1. Montaje limpio
umount -R $TARGET 2>/dev/null
mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $TARGET

# 2. PUENTE DE LIBRERÍAS (Shadowing)
# Montamos las librerías del Live USB sobre las del disco de forma temporal.
# Esto garantiza que NADA del disco cause un Symbol Lookup Error.
mount --bind /usr/lib $TARGET/usr/lib
mount --bind /usr/bin $TARGET/usr/bin

# 3. Binds de sistema
for i in dev dev/pts proc sys run; do mount --bind /$i $TARGET/$i; done

echo "--------------------------------------------------"
echo " ENTRANDO EN MODO PUENTE (ESTABLE) "
echo "--------------------------------------------------"

# Ahora el chroot usará el Bash y las Libs del Live USB, pero
# operando sobre la base de datos de pacman de tu disco.
chroot $TARGET /usr/bin/bash --login
