#!/bin/bash

UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/manjaro_recovery"

echo "--- OPERACIÓN CABALLO DE TROYA: INYECCIÓN DE BINARIO SANO ---"

# 1. Montaje
umount -R $TARGET 2>/dev/null
mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $TARGET

# 2. Inyectar el Kit de Supervivencia (Bash + Librerías del Live USB)
echo "Copiando binario de Bash del Live USB al disco..."
cp /usr/bin/bash $TARGET/usr/bin/bash_rescue

echo "Asegurando librerías críticas en el destino..."
cp -d /usr/lib/libreadline.so* $TARGET/usr/lib/
cp -d /usr/lib/libhistory.so* $TARGET/usr/lib/
cp -d /usr/lib/libncursesw.so* $TARGET/usr/lib/
cp -d /usr/lib/libtinfo.so* $TARGET/usr/lib/
cp -d /usr/lib/libdl.so* $TARGET/usr/lib/
cp -d /usr/lib/libc.so* $TARGET/usr/lib/

# 3. Reparar enlaces de la raíz (Crucial para el cargador ld-linux)
cd $TARGET
for i in bin lib lib64 sbin; do
    rm -f $i 2>/dev/null
    ln -s usr/$i $i
done
cd - > /dev/null

# 4. Binds de sistema
for i in dev dev/pts proc sys run; do mount --bind /$i $TARGET/$i; done

echo "--------------------------------------------------"
echo " INTENTANDO CHROOT CON BINARIO DE RESCATE "
echo "--------------------------------------------------"

# Ejecutamos el chroot usando el bash de rescate que acabamos de copiar.
# Al ser el mismo binario que el del Live USB, DEBE funcionar con las librerías que copiamos.
chroot $TARGET /usr/bin/bash_rescue --login
