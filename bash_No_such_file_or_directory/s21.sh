#!/bin/bash

UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/manjaro_recovery"

echo "--- OPERACIÓN SELLADO DEFINITIVO ---"

# 1. Limpieza de montajes previos y montaje limpio
echo "[1/6] Preparando puntos de montaje..."
umount -R $TARGET 2>/dev/null
mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $TARGET

# 2. Aplicar el PUENTE (Bind) para tener un entorno estable
# Esto nos permite usar el software del Live USB sobre tus datos
echo "[2/6] Aplicando puente de librerías del Live USB..."
mount --bind /usr/lib $TARGET/usr/lib
mount --bind /usr/bin $TARGET/usr/bin
for i in dev dev/pts proc sys run; do mount --bind /$i $TARGET/$i; done

# 3. Liberar espacio (Crítico para Btrfs al 95%)
echo "[3/6] Liberando espacio en disco..."
chroot $TARGET /usr/bin/pacman -Scc --noconfirm

# 4. Reinstalación Nativa Forzada
# Aquí es donde pacman escribe los archivos correctos en tu disco
echo "[4/6] Reinstalando base del sistema (sobreescribiendo corruptos)..."
chroot $TARGET /usr/bin/pacman -Sy --noconfirm --overwrite "*" \
    bash readline openssl glibc ncurses coreutils pcre2 zlib libcap

# 5. Sincronizar el arranque (Kernel y GRUB)
echo "[5/6] Regenerando initramfs y actualizando GRUB..."
chroot $TARGET /usr/bin/ldconfig
chroot $TARGET /usr/bin/mkinitcpio -P
chroot $TARGET /usr/bin/update-grub

# 6. Desmontar los puentes para validar la reparación
echo "[6/6] Desmontando puentes para validación final..."
umount -l $TARGET/usr/lib
umount -l $TARGET/usr/bin

echo "--------------------------------------------------"
echo " SISTEMA REPARADO "
echo " Se ha intentado estabilizar todo. Entrando para verificar. "
echo " Si el prompt carga sin errores de símbolos, ¡LO LOGRAMOS! "
echo " Escribí 'exit' y reiniciá la PC. "
echo "--------------------------------------------------"

# Intento de entrada final ya sin el puente de librerías (usando las del disco)
chroot $TARGET /usr/bin/bash --login
