#!/bin/bash

# Variables
TARGET_UUID="cfb49c22-87f2-47d9-a25b-310d8d8578af"
MOUNT_POINT="/mnt/manjaro_recovery"

echo "--- Iniciando recuperación de Manjaro (Btrfs) ---"

# 1. Limpieza previa y creación de punto de montaje
umount -R $MOUNT_POINT 2>/dev/null
mkdir -p $MOUNT_POINT

# 2. Intentar montar la raíz de la partición para ver subvolúmenes
# Esto nos permite verificar si el subvolumen se llama @ u otra cosa
mount UUID=$TARGET_UUID /mnt -o subvolid=5 2>/dev/null

echo "Subvolúmenes detectados en la partición:"
btrfs subvolume list /mnt | awk '{print $NF}'
umount /mnt

# 3. Montar el subvolumen raíz (Corregido: subvol=@)
echo "Intentando montar el subvolumen raíz (@)..."
mount -t btrfs -o subvol=@ UUID=$TARGET_UUID $MOUNT_POINT

if [ $? -ne 0 ]; then
    echo "Error: No se pudo montar con subvol=@. Intentando montaje directo..."
    mount UUID=$TARGET_UUID $MOUNT_POINT
fi

# 4. Verificación de seguridad del Shell
# En Arch/Manjaro, /bin suele ser un enlace simbólico a /usr/bin
if [ ! -f "$MOUNT_POINT/usr/bin/bash" ]; then
    echo "ERROR CRÍTICO: No se encuentra /usr/bin/bash en $MOUNT_POINT"
    echo "Asegúrate de que el UUID $TARGET_UUID sea el correcto."
    exit 1
fi

# 5. Montar sistemas de archivos virtuales
echo "Preparando entorno de dispositivos..."
for i in /dev /dev/pts /proc /sys /run; do
    mount --bind $i $MOUNT_POINT$i
done

# 6. Entrar al chroot usando la ruta absoluta de Bash
echo "--- Entorno Preparado ---"
echo "Ejecutando: chroot $MOUNT_POINT /usr/bin/bash"
chroot $MOUNT_POINT /usr/bin/bash

# 7. Desmontar al salir
echo "Saliendo y limpiando montajes..."
umount -R $MOUNT_POINT
