#!/bin/bash

# Configuración
UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
MOUNT_DIR="/mnt/manjaro_recovery"

echo "=================================================="
echo "   REPARADOR INTEGRAL DE ENTORNO CHROOT V2.0    "
echo "=================================================="

# 1. Limpieza y Montaje
echo "[1/5] Preparando montajes..."
umount -R $MOUNT_DIR 2>/dev/null
mkdir -p $MOUNT_DIR
if ! mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $MOUNT_DIR; then
    echo "ERROR: No se pudo montar. Revisa el UUID."
    exit 1
fi

# 2. Reparación Quirúrgica de Librerías Críticas
echo "[2/5] Corrigiendo enlaces de librerías corruptos (SSL)..."
# Eliminamos los archivos que ldconfig reportó como "not a symbolic link"
# para que pacman los cree correctamente como enlaces.
rm -f $MOUNT_DIR/usr/lib/libssl.so.3
rm -f $MOUNT_DIR/usr/lib/libcrypto.so.3

# 3. Verificación de Enlaces de Raíz
echo "[3/5] Asegurando estructura Usr-Merge..."
cd $MOUNT_DIR
for link in bin lib lib64 sbin; do
    if [ ! -L "$link" ]; then
        rm -rf "$link" 2>/dev/null
        ln -s "usr/$link" "$link"
    fi
done
cd - > /dev/null

# 4. Pacman --sysroot con paquetes corregidos
echo "[4/5] Reinstalando base crítica vía Pacman..."
# Corregido: 'libreadline' -> 'readline' y añadimos 'openssl'
pacman --sysroot $MOUNT_DIR -S --noconfirm --overwrite "*" \
    bash coreutils glibc readline ncurses openssl

# Forzar reconstrucción de links de librerías
ldconfig -r $MOUNT_DIR

# 5. Montaje de sistemas virtuales y entrada
echo "[5/5] Preparando API del Kernel..."
for i in dev dev/pts proc sys run; do
    mount --bind /$i $MOUNT_DIR/$i
done

echo "--------------------------------------------------"
echo " INTENTANDO ACCESO AL CHROOT "
echo "--------------------------------------------------"

# Intentamos entrar. Si falla bash, intentamos con sh
if ! chroot $MOUNT_DIR /usr/bin/bash --login; then
    echo "Fallo con Bash, intentando con /bin/sh..."
    chroot $MOUNT_DIR /bin/sh
fi

# Limpieza al salir
echo -e "\nDesmontando y limpiando..."
umount -R $MOUNT_DIR
