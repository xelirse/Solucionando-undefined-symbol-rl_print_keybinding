#!/bin/bash

TARGET_UUID="cfb49c22-87f2-47d9-a25b-310d8d8578af"
MOUNT_POINT="/mnt/manjaro_recovery"

echo "--- Iniciando Diagnóstico Profundo Btrfs ---"

# 1. Limpieza y Montaje
umount -R $MOUNT_POINT 2>/dev/null
mkdir -p $MOUNT_POINT
mount -t btrfs -o subvol=@ UUID=$TARGET_UUID $MOUNT_POINT

# 2. Verificación de estructura Usr-Merge
echo "Verificando integridad de directorios..."
if [ -L "$MOUNT_POINT/bin" ]; then
    echo "[OK] /bin es un enlace simbólico."
else
    echo "[!] ADVERTENCIA: /bin no es un enlace. Esto puede causar el error."
fi

# 3. Forzar el uso del cargador dinámico y el shell
# A veces el problema es que no encuentra las librerías (ld-linux)
echo "Contenido de /usr/bin/bash en el destino:"
ls -lh "$MOUNT_POINT/usr/bin/bash" || echo "!!! BASH NO EXISTE EN /usr/bin/bash !!!"

# 4. Montaje Bind robusto
echo "Montando interfaces del kernel..."
for i in dev dev/pts proc sys run; do
    mount --bind /$i $MOUNT_POINT/$i
done

# 5. Intento de Chroot con PATH explícito
echo "--- Intentando Chroot con PATH forzado ---"
# Intentamos usar /bin/sh como fallback si bash falla
chroot $MOUNT_POINT /usr/bin/env -i HOME=/root TERM=$TERM /usr/bin/bash --login
