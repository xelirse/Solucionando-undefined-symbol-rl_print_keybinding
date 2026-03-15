#!/bin/bash

UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/manjaro_recovery"

echo "--- OPERACIÓN NUCLEAR: REINSTALACIÓN EXTERNA TOTAL ---"

# 1. Montaje limpio
umount -R $TARGET 2>/dev/null
mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $TARGET

# 2. LIMPIEZA DE CACHÉ DE LIBRERÍAS CORRUPTO
# A veces el archivo /etc/ld.so.cache dentro del disco está corrupto y causa Segfault
echo "Eliminando caché de librerías corrupto..."
rm -f $TARGET/etc/ld.so.cache
rm -f $TARGET/var/lib/pacman/db.lck

# 3. REINSTALACIÓN FORZADA (SIN CHROOT)
# Reinstalamos el corazón del sistema.
# Usamos --root para que pacman use las librerías del LIVE USB para escribir en el disco.
echo "Reinstalando paquetes críticos (glibc, bash, readline, openssl)..."
pacman --root $TARGET -Sy --noconfirm --overwrite "*" \
    glibc bash readline openssl ncurses coreutils pcre2 zlib libcap

# 4. RECONSTRUCCIÓN DEL ENTORNO DESDE EL EXTERIOR
echo "Reconstruyendo enlaces simbólicos y caché..."
ldconfig -r $TARGET

# 5. VERIFICACIÓN DE ESPACIO (Btrfs suele fallar si no hay espacio de metadatos)
echo "Estado del disco:"
df -h $TARGET

# 6. INTENTO DE ENTRADA CON BASH LIMPIO
echo "--------------------------------------------------"
echo " INTENTANDO ENTRAR DESPUÉS DE REINSTALACIÓN "
echo "--------------------------------------------------"
for i in dev dev/pts proc sys run; do mount --bind /$i $TARGET/$i; done

chroot $TARGET /usr/bin/bash --login
