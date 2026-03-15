#!/bin/sh

#!/bin/bash

# Definir la ruta del punto de montaje
TARGET="/mnt"

echo "--- Preparando entorno chroot en $TARGET ---"

# 1. Verificar si busybox existe en el sistema anfitrión
BUSYBOX_PATH=$(which busybox)

if [ -z "$BUSYBOX_PATH" ]; then
    echo "Error: busybox no está instalado en el sistema anfitrión."
    exit 1
fi

# 2. Crear directorios básicos en el destino si no existen
mkdir -p $TARGET/bin $TARGET/usr/bin $TARGET/sbin $TARGET/proc $TARGET/sys $TARGET/dev $TARGET/run

# 3. Copiar busybox al entorno chroot (usamos la versión estática si es posible)
# Lo ideal es copiarlo a /bin/busybox dentro del chroot
cp "$BUSYBOX_PATH" "$TARGET/bin/busybox"
chmod +x "$TARGET/bin/busybox"

# 4. Montar sistemas de archivos necesarios para que el entorno sea funcional
echo "Montando sistemas de archivos virtuales..."
mount --bind /dev $TARGET/dev
mount --bind /dev/pts $TARGET/dev/pts
mount --proc proc $TARGET/proc
mount --bind /sys $TARGET/sys
mount --bind /run $TARGET/run

# 5. Ejecutar el chroot
echo "Entrando al chroot..."
chroot $TARGET /bin/busybox ash

# 6. Al salir, intentar desmontar (opcional, para limpieza)
echo "Saliendo del chroot. Desmontando..."
umount $TARGET/dev/pts 2>/dev/null
umount $TARGET/dev 2>/dev/null
umount $TARGET/proc 2>/dev/null
umount $TARGET/sys 2>/dev/null
umount $TARGET/run 2>/dev/null
