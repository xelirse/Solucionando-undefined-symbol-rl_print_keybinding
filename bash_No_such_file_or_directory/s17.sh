#!/bin/bash

UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/manjaro_recovery"

echo "--- OPERACIÓN ESTABILIZACIÓN: SELLADO DE SISTEMA ---"

# 1. Limpieza de montajes previos (para evitar recursividad)
echo "[1/5] Limpiando montajes de emergencia..."
umount -l $TARGET/usr/lib 2>/dev/null
umount -R $TARGET 2>/dev/null

# 2. Montaje limpio del subvolumen @
mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $TARGET

# 3. Liberar espacio (Vital por ese 95% de uso)
echo "[2/5] Liberando espacio en el disco (Caché de Pacman)..."
rm -rf $TARGET/var/cache/pacman/pkg/*

# 4. Reinstalación "Ciega" (Reemplaza los trasplantes por archivos oficiales)
echo "[3/5] Reinstalando paquetes base de forma nativa..."
# Usamos --root para que el pacman del Live escriba la versión oficial sobre tus archivos
pacman --root $TARGET -Sy --noconfirm --overwrite "*" \
    bash readline openssl glibc ncurses coreutils pcre2 zlib libcap

# 5. Reconstrucción de la configuración de arranque
echo "[4/5] Preparando entorno para regeneración de Kernel..."
for i in dev dev/pts proc sys run; do mount --bind /$i $TARGET/$i; done

# Ejecutamos mkinitcpio y ldconfig desde fuera
chroot $TARGET ldconfig
echo "Regenerando initramfs (puede tardar)..."
chroot $TARGET mkinitcpio -P

echo "[5/5] Finalizando..."
echo "--------------------------------------------------"
echo " SISTEMA ESTABILIZADO "
echo " Si quieres verificar antes de reiniciar, "
echo " puedes entrar ahora. Si no, escribe 'exit'. "
echo "--------------------------------------------------"

chroot $TARGET /usr/bin/bash --login

# Desmontar al terminar
umount -R $TARGET
echo "Listo. Intenta reiniciar el sistema normalmente."
