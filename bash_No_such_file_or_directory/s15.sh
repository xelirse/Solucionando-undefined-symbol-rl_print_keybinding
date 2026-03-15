#!/bin/bash

UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/manjaro_recovery"

echo "--- OPERACIÓN RESCATE ESTÁTICO (BUSYBOX) ---"

# 1. Montaje
umount -R $TARGET 2>/dev/null
mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $TARGET

# 2. Copiar Busybox (Binario estático, no usa librerías)
echo "Copiando Busybox para bypass de librerías..."
cp /usr/bin/busybox $TARGET/usr/bin/busybox_rescue

# 3. Limpiar archivos de bloqueo de Pacman por si acaso
rm -f $TARGET/var/lib/pacman/db.lck

# 4. Binds de sistema
for i in dev dev/pts proc sys run; do mount --bind /$i $TARGET/$i; done

echo "--------------------------------------------------"
echo " INTENTANDO ENTRAR CON BUSYBOX (SHELL ESTÁTICO) "
echo " Si entras, tendrás un shell básico (#). "
echo " Ejecuta: /usr/bin/busybox_rescue sh "
echo "--------------------------------------------------"

# Intentamos entrar directamente al shell de busybox
chroot $TARGET /usr/bin/busybox_rescue sh
