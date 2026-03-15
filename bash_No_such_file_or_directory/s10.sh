#!/bin/bash

UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/manjaro_recovery"

echo "--- OPERACIÓN STEAMROLLER: REINSTALACIÓN EXTERNA ---"

# 1. Montaje
umount -R $TARGET 2>/dev/null
mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $TARGET

# 2. Limpieza de librerías que bloquean ldconfig
rm -f $TARGET/usr/lib/libssl.so.3 $TARGET/usr/lib/libcrypto.so.3

# 3. Forzar actualización de base de datos y paquetes críticos
# Usamos --root para operar desde el Live USB sobre el disco
# Usamos --nodeps para asegurar que bash y readline se instalen sí o sí
echo "Reinstalando paquetes base (esto puede tardar unos minutos)..."
pacman --root $TARGET -Sy --noconfirm --overwrite "*" \
    bash readline glibc openssl ncurses coreutils

# 4. Sincronizar librerías del sistema
ldconfig -r $TARGET

# 5. Parche de compatibilidad (Solo si ldconfig no fue suficiente)
# Copiamos TODOS los archivos de readline para asegurar coincidencia de símbolos
cp -d /usr/lib/libreadline.so* $TARGET/usr/lib/
cp -d /usr/lib/libhistory.so* $TARGET/usr/lib/

# 6. Montar binds de sistema
for i in dev dev/pts proc sys run; do mount --bind /$i $TARGET/$i; done

echo "--------------------------------------------------"
echo " INTENTANDO ACCESO FINAL "
echo "--------------------------------------------------"

# Intentamos entrar con el Bash del sistema (ahora debería estar sincronizado)
if ! chroot $TARGET /usr/bin/bash --login; then
    echo "Fallo persistente. Intentando entrar con el Bash del Live USB (Inyectado)..."
    cp /usr/bin/bash $TARGET/usr/bin/bash_live
    chroot $TARGET /usr/bin/bash_live --login
fi
