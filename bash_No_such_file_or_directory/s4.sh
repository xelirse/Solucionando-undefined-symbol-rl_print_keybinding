#!/bin/bash

# Configuración
UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
MOUNT_DIR="/mnt/manjaro_recovery"

echo "=================================================="
echo "   REPARADOR INTEGRAL DE ENTORNO CHROOT (BTRFS)   "
echo "=================================================="

# 1. Preparación de limpieza
echo "[1/5] Limpiando montajes previos..."
umount -R $MOUNT_DIR 2>/dev/null
mkdir -p $MOUNT_DIR

# 2. Montaje de subvolumen @
echo "[2/5] Montando subvolumen raíz (@)..."
if ! mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $MOUNT_DIR; then
    echo "ERROR: No se pudo montar la partición. Verifica el UUID."
    exit 1
fi

# 3. Reparación de estructura Usr-Merge (Enlaces Críticos)
echo "[3/5] Verificando enlaces simbólicos de la raíz..."
cd $MOUNT_DIR
for link in bin lib lib64 sbin; do
    if [ -L "$link" ]; then
        echo "  -> $link ya es un enlace [OK]"
    else
        echo "  -> Corrigiendo $link (no es un enlace o no existe)..."
        rm -rf "$link" 2>/dev/null
        ln -s "usr/$link" "$link"
    fi
done
cd - > /dev/null

# 4. Reparación externa vía Pacman (La solución definitiva)
echo "[4/5] Reinstalando paquetes base desde el Live USB (Pacman --sysroot)..."
# Esto repara el cargador dinámico y los binarios de bash/coreutils
pacman --sysroot $MOUNT_DIR -S --noconfirm --overwrite "*" bash coreutils glibc libreadline ncurses

if [ $? -eq 0 ]; then
    echo "  -> Reinstalación exitosa."
else
    echo "  -> Advertencia: Pacman tuvo problemas. Intentando continuar..."
fi

# 5. Montaje de sistemas de archivos virtuales y entrada
echo "[5/5] Preparando API del Kernel y entrando..."
for i in dev dev/pts proc sys run; do
    mount --bind /$i $MOUNT_DIR/$i
done

# Generar ldconfig para asegurar que las librerías se reconozcan
ldconfig -r $MOUNT_DIR

echo "--------------------------------------------------"
echo " INTENTANDO ACCESO FINAL AL CHROOT "
echo " Si entras con éxito, ejecuta: pacman -Syu "
echo "--------------------------------------------------"

chroot $MOUNT_DIR /usr/bin/bash --login

# Limpieza al salir
echo ""
echo "Saliendo del chroot... Desmontando todo."
umount -R $MOUNT_DIR
echo "Hecho."
