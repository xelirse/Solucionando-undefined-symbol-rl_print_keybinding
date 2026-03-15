#!/bin/bash

UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/manjaro_recovery"

echo "--- OPERACIÓN TRASPLANTE: ESTABILIZACIÓN DE LIBRERÍAS ---"

# 1. Montaje
umount -R $TARGET 2>/dev/null
mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $TARGET

# 2. LIMPIEZA RADICAL DE LIBRERÍAS CORRUPTAS
# Borramos los archivos que están causando el conflicto de símbolos y el error de ldconfig
echo "Eliminando librerías conflictivas del disco..."
rm -f $TARGET/usr/lib/libreadline.so*
rm -f $TARGET/usr/lib/libhistory.so*
rm -f $TARGET/usr/lib/libssl.so*
rm -f $TARGET/usr/lib/libcrypto.so*

# 3. TRASPLANTE DESDE EL LIVE USB
# Copiamos las versiones del Live USB (que sí funcionan) al disco.
# Usamos -d para preservar enlaces simbólicos.
echo "Inyectando librerías sanas desde el Live USB..."
cp -d /usr/lib/libreadline.so* $TARGET/usr/lib/
cp -d /usr/lib/libhistory.so* $TARGET/usr/lib/
cp -d /usr/lib/libssl.so* $TARGET/usr/lib/
cp -d /usr/lib/libcrypto.so* $TARGET/usr/lib/
cp -d /usr/lib/libncursesw.so* $TARGET/usr/lib/

# 4. RECONSTRUCCIÓN DE ENLACES DE RAÍZ
# Aseguramos que /lib64 y /bin apunten a donde deben
echo "Reparando estructura Usr-Merge..."
cd $TARGET
for i in bin lib lib64 sbin; do
    rm -f $i 2>/dev/null
    ln -s usr/$i $i
done
cd - > /dev/null

# 5. ACTUALIZAR CACHÉ DE LIBRERÍAS
ldconfig -r $TARGET

# 6. Binds de sistema
for i in dev dev/pts proc sys run; do mount --bind /$i $TARGET/$i; done

echo "--------------------------------------------------"
echo " INTENTANDO ACCESO DE EMERGENCIA "
echo "--------------------------------------------------"

# Intentamos entrar. El error de símbolos DEBERÍA haber desaparecido.
chroot $TARGET /usr/bin/bash --login
