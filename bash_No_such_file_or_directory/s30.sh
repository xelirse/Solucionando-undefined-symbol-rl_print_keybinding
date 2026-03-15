#!/bin/bash

# Configuramos variables manualmente para saltar la detección automática que falla
CHROOTDIR="/run/media/manjaro/cfb49c22-87f2-47d9-a25b-310d8d8578af/@"
RUN_ARGS="/usr/bin/bash"

echo "--- INTENTO DE CHROOT QUIRÚRGICO (SIN UNSHARE) ---"

# 1. Función de montaje forzado (reemplaza a chroot_api_efi_mount)
mount_api() {
    echo "[1/3] Montando sistemas de archivos de API..."
    for i in dev dev/pts proc sys run; do
        mkdir -p "${CHROOTDIR}/$i"
        mount --point --bind "/$i" "${CHROOTDIR}/$i"
    done
}

# 2. Inyección de librerías del Live (para evitar el Segfault de binarios locales)
inject_libs() {
    echo "[2/3] Inyectando entorno de ejecución sano..."
    mount --point --bind /usr/lib "${CHROOTDIR}/usr/lib"
    mount --point --bind /usr/bin "${CHROOTDIR}/usr/bin"
}

# Ejecución
mount_api
inject_libs

echo "[3/3] Intentando entrada directa vía chroot estándar..."
echo "Si esto falla, el Kernel está bloqueando el acceso al Inodo Raíz del disco."
echo "--------------------------------------------------------------"

# Eliminamos 'unshare' y 'fork'. Usamos el chroot más básico posible.
chroot "${CHROOTDIR}" /usr/bin/bash --login

# Limpieza al salir
echo "Desmontando..."
umount -l "${CHROOTDIR}/usr/lib"
umount -l "${CHROOTDIR}/usr/bin"
umount -R "${CHROOTDIR}"
