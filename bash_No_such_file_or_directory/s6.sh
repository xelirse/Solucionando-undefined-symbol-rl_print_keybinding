#!/bin/bash

UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
MOUNT_DIR="/mnt/manjaro_recovery"

echo "--- INYECCIÓN DE EMERGENCIA L0 ---"

# 1. Montaje limpio
umount -R $MOUNT_DIR 2>/dev/null
mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $MOUNT_DIR

# 2. El problema son estos archivos que NO son enlaces. Los borramos a la fuerza.
echo "Limpiando librerías corruptas..."
rm -f $MOUNT_DIR/usr/lib/libssl.so.3
rm -f $MOUNT_DIR/usr/lib/libcrypto.so.3
rm -f $MOUNT_DIR/usr/lib/libssl.so
rm -f $MOUNT_DIR/usr/lib/libcrypto.so

# 3. Inyectar las librerías del LIVE USB al sistema instalado
# Esto es para que bash pueda "arrancar" aunque el sistema esté roto
echo "Inyectando librerías del Live USB..."
cp -d /usr/lib/libssl.so* $MOUNT_DIR/usr/lib/
cp -d /usr/lib/libcrypto.so* $MOUNT_DIR/usr/lib/
cp -d /usr/lib/libreadline.so* $MOUNT_DIR/usr/lib/

# 4. Asegurar que el cargador dinámico exista en todas las rutas posibles
cp -d /lib64/ld-linux-x86-64.so.2 $MOUNT_DIR/lib64/

# 5. Intentar reconstruir los enlaces simbólicos de la raíz una vez más
cd $MOUNT_DIR
for i in bin lib lib64 sbin; do
    rm -f $i 2>/dev/null
    ln -s usr/$i $i
done
cd - > /dev/null

# 6. Montar binds
for i in dev dev/pts proc sys run; do mount --bind /$i $MOUNT_DIR/$i; done

# 7. Intentar entrar con un entorno MINIMALISTA
echo "--------------------------------------------------"
echo " SI LOGRAS ENTRAR, EJECUTA: ldconfig "
echo " LUEGO: pacman -S openssl readline bash "
echo "--------------------------------------------------"

chroot $MOUNT_DIR /usr/bin/bash --login
