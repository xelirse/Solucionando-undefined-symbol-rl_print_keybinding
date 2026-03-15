#!/bin/bash

# Definir variables
TARGET_UUID="cfb49c22-87f2-47d9-a25b-310d8d8578af"
MOUNT_POINT="/mnt/manjaro_recovery"

echo "--- Iniciando recuperación de Manjaro ---"

# 1. Crear punto de montaje si no existe
mkdir -p $MOUNT_POINT

# 2. Montar el subvolumen raíz (@)
echo "Montando subvolumen raíz..."
mount -t btrfs -o subvol@ UUID=$TARGET_UUID $MOUNT_POINT

# 3. Verificar si /bin/sh existe en el destino
if [ ! -f "$MOUNT_POINT/bin/sh" ]; then
    echo "Error: No se encuentra /bin/sh en $MOUNT_POINT. Verificando /usr/bin/sh..."
    if [ -f "$MOUNT_POINT/usr/bin/sh" ]; then
        echo "Estructura /usr encontrada. Continuando..."
    else
        echo "Error crítico: No se encuentra un shell válido. Revisa si la partición es correcta."
        exit 1
    fi
fi

# 4. Montar sistemas de archivos temporales necesarios
echo "Montando sistemas de archivos virtuales (proc, sys, dev)..."
mount --bind /dev $MOUNT_POINT/dev
mount --bind /proc $MOUNT_POINT/proc
mount --bind /sys $MOUNT_POINT/sys
mount --bind /run $MOUNT_POINT/run

# 5. Intentar entrar al chroot
echo "--- Entrando al entorno chroot ---"
echo "Escribe 'exit' para salir y el script desmontará todo automáticamente."
chroot $MOUNT_POINT /bin/bash

# 6. Limpieza al salir
echo "Desmontando directorios..."
umount -R $MOUNT_POINT
echo "Listo. El sistema se ha limpiado."
