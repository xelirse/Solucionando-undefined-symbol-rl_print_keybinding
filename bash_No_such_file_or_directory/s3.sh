#!/bin/bash

TARGET_UUID="cfb49c22-87f2-47d9-a25b-310d8d8578af"
MOUNT_POINT="/mnt/manjaro_recovery"

echo "--- Corrigiendo Estructura de Librerías (Usr-Merge) ---"

# 1. Montar el subvolumen
umount -R $MOUNT_POINT 2>/dev/null
mount -t btrfs -o subvol=@ UUID=$TARGET_UUID $MOUNT_POINT

# 2. Reparar enlaces simbólicos críticos
# Si estos enlaces son carpetas reales o no existen, el chroot fallará siempre
cd $MOUNT_POINT

echo "Verificando y reparando enlaces en la raíz..."
for link in lib lib64 sbin bin; do
    if [ -d "$link" ] && [ ! -L "$link" ]; then
        echo "Error: $link es un directorio real. Corrigiendo..."
        mv "$link" "${link}_backup"
        ln -s "usr/$link" "$link"
    elif [ ! -e "$link" ]; then
        echo "Creando enlace faltante: $link -> usr/$link"
        ln -s "usr/$link" "$link"
    else
        echo "[OK] $link ya es un enlace."
    fi
done

# 3. Montar sistemas virtuales
echo "Montando API del Kernel..."
for i in dev dev/pts proc sys run; do
    mount --bind /$i $MOUNT_POINT/$i
done

# 4. Entrar al chroot ignorando el entorno previo
echo "--- Entrando al sistema ---"
chroot $MOUNT_POINT /usr/bin/bash --login
