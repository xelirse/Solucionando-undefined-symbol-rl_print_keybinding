#!/bin/bash

# --- CONFIGURACIÓN ---
DEV="/dev/sda1"
UUID="cfb49c22-87f2-47d9-a25b-310d8d8578af"
MNT="/mnt/recovery_root"

echo "--- INICIANDO REPARACIÓN NIVEL KERNEL ---"

# 1. Asegurar que el disco no esté ocupado y limpiar logs de Btrfs
umount -l $MNT 2>/dev/null
btrfs rescue zero-log $DEV

# 2. Montaje con bypass de escritura (nodatacow es clave aquí)
mkdir -p $MNT
mount -t btrfs -o subvol=@,rw,nodatacow,space_cache=v2 UUID=$UUID $MNT

if [ $? -ne 0 ]; then
    echo "ERROR: El Kernel se niega a montar el disco en modo RW."
    exit 1
fi

# 3. Montaje de API Systems (Manual, sin unshare)
echo "Sincronizando sistemas virtuales..."
for i in dev dev/pts proc sys run; do
    mount --bind /$i $MNT/$i
done

# 4. Inyección de entorno de ejecución externo (Evita el Segfault del Bash local)
echo "Bypasseando librerías corruptas del disco..."
mount --bind /usr/lib $MNT/usr/lib
mount --bind /usr/bin $MNT/usr/bin

# 5. Operación Quirúrgica con Pacman
echo "Reinstalando librerías base (glibc) y limpiando base de datos..."
# Eliminamos el lock de pacman si existe
rm -f $MNT/var/lib/pacman/db.lck

# Ejecutamos pacman desde el exterior pero apuntando a la raíz del disco
# Esto evita usar el binario 'chroot' que está dando Segfault
pacman --sysroot $MNT -Sy --noconfirm --overwrite "*" glibc bash coreutils

# 6. Reconstrucción de la caché de librerías
chroot $MNT /usr/bin/ldconfig

echo "--------------------------------------------------"
echo " INTENTO DE REPARACIÓN FINALIZADO "
echo " Intentaré entrar al sistema ahora (sin unshare)..."
echo "--------------------------------------------------"

# Entramos con el chroot más básico posible
chroot $MNT /usr/bin/bash --login

# Al salir, desmontamos todo
echo "Limpiando montajes..."
umount -l $MNT/usr/lib
umount -l $MNT/usr/bin
umount -R $MNT
