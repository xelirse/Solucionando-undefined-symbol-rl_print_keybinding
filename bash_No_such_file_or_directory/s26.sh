#!/bin/bash

UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/manjaro_recovery"

echo "--- INICIANDO RECONSTRUCCIÓN ATÓMICA (LAST CHANCE) ---"

# 1. Limpieza absoluta de montajes previos
umount -l $TARGET/dev{/pts,} $TARGET/{proc,sys,run,usr/lib,usr/bin} 2>/dev/null
umount -l $TARGET 2>/dev/null

# 2. Montaje manual con opciones de recuperación
mkdir -p $TARGET
mount -t btrfs -o subvol=@,rw,space_cache=v2 UUID=$UUID_ROOT $TARGET

# 3. Forzar creación de estructura (Si manjaro-chroot no veía /proc, nosotros la creamos)
echo "[1/4] Forzando creación de nodos de montaje..."
mkdir -p $TARGET/{dev,proc,sys,run,usr/bin,usr/lib,var/lib/pacman}

# 4. Inyección de entorno de ejecución externo (Bypass de librerías corruptas)
echo "[2/4] Inyectando binarios sanos del Live USB..."
mount --bind /usr/lib $TARGET/usr/lib
mount --bind /usr/bin $TARGET/usr/bin
for i in dev dev/pts proc sys run; do mount --bind /$i $TARGET/$i; done

# 5. Reparación de Pacman y reconstrucción de Bash
echo "[3/4] Intentando reparación de base de datos y paquetes core..."
# Borramos locks y reparamos el motor GPG que daba error
rm -f $TARGET/var/lib/pacman/db.lck
gpg --homedir $TARGET/etc/pacman.d/gnupg --refresh-keys

# Reinstalar los 3 pilares: glibc, bash y readline
chroot $TARGET /usr/bin/pacman -Sy --noconfirm --overwrite "*" glibc bash readline ncurses coreutils

# 6. Sincronización de cargador dinámico
echo "[4/4] Sincronizando ldconfig y regenerando enlaces..."
chroot $TARGET /usr/bin/ldconfig
sync

echo "--------------------------------------------------"
echo " INTENTO DE ACCESO FINAL "
echo " Si entras, ejecuta 'pacman -Syu' inmediatamente. "
echo "--------------------------------------------------"

chroot $TARGET /usr/bin/bash --login

# Al salir, limpieza
umount -l $TARGET/usr/lib
umount -l $TARGET/usr/bin
umount -R $TARGET
