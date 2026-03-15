#!/bin/bash

UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/manjaro_recovery"

echo "--- INICIANDO RECONSTRUCCIÓN MANUAL DE ESTRUCTURA ---"

# 1. Limpieza absoluta de montajes previos
umount -l $TARGET/dev{/pts,} $TARGET/{proc,sys,run,usr/lib,usr/bin} 2>/dev/null
umount -l $TARGET 2>/dev/null

# 2. Montaje manual del subvolumen raíz
mkdir -p $TARGET
mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $TARGET

# 3. VERIFICACIÓN DE ESTRUCTURA (Crear carpetas si Btrfs las "perdió")
echo "[1/4] Verificando integridad de directorios base..."
for dir in dev proc sys run bin lib usr/bin usr/lib; do
    mkdir -p $TARGET/$dir
done

# 4. PUENTE DE EMERGENCIA (Librerías del Live sobre el Disco)
echo "[2/4] Inyectando entorno de ejecución sano..."
mount --bind /usr/lib $TARGET/usr/lib
mount --bind /usr/bin $TARGET/usr/bin
for i in dev dev/pts proc sys run; do mount --bind /$i $TARGET/$i; done

# 5. EJECUCIÓN DE REPARACIÓN (Sin entrar al chroot interactivamente)
echo "[3/4] Forzando limpieza de espacio y reinstalación..."
# Borramos el lock de pacman por si acaso
rm -f $TARGET/var/lib/pacman/db.lck

# Intentamos limpiar caché y reinstalar base
chroot $TARGET /usr/bin/pacman -Scc --noconfirm
chroot $TARGET /usr/bin/pacman -Sy --noconfirm --overwrite "*" \
    glibc bash readline ncurses coreutils openssl

# 6. SELLO Y CIERRE
echo "[4/4] Sincronizando metadatos del sistema de archivos..."
chroot $TARGET /usr/bin/ldconfig
sync

echo "--------------------------------------------------"
echo " INTENTO DE ACCESO FINAL "
echo " Si esto falla con Segfault, el disco requiere 'btrfs check'. "
echo "--------------------------------------------------"

chroot $TARGET /usr/bin/bash --login

# Al salir, desmontar todo
umount -l $TARGET/usr/lib
umount -l $TARGET/usr/bin
umount -R $TARGET
