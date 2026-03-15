#!/bin/bash

# Asegúrate de estar como root en el Live USB
if [ "$EUID" -ne 0 ]; then echo "Corre con sudo"; exit; fi

echo "--- 1. Eliminando rastros de librerías ajenas (Debian/Ubuntu) ---"
# Esto es lo que está causando el conflicto de versiones
rm -rf /mnt/lib/x86_64-linux-gnu
rm -rf /mnt/usr/lib/x86_64-linux-gnu

echo "--- 2. Reinstalando glibc y gpgme desde el exterior ---"
# Forzamos la reinstalación para asegurar que los enlaces simbólicos sean correctos
pacman --sysroot /mnt -Sy --noconfirm glibc gcc-libs gpgme

echo "--- 3. Reparando el llavero GPG desde el exterior ---"
# En lugar de usar chroot, operamos sobre la ruta de /mnt directamente
rm -rf /mnt/etc/pacman.d/gnupg
pacman-key --gpgdir /mnt/etc/pacman.d/gnupg --init
pacman-key --gpgdir /mnt/etc/pacman.d/gnupg --populate archlinux manjaro

echo "--- 4. Verificando integridad crítica ---"
# Aseguramos que /lib sea un enlace a /usr/lib (estándar de Arch)
if [ ! -L /mnt/lib ]; then
    echo "Corrigiendo enlace simbólico de /lib..."
    mv /mnt/lib/* /mnt/usr/lib/ 2>/dev/null
    rm -rf /mnt/lib
    ln -s usr/lib /mnt/lib
fi

echo "--- 5. Sincronización final ---"
pacman --sysroot /mnt -Syu

echo "Proceso terminado. Intenta reiniciar ahora."
