#!/bin/bash

# Configuración
TARGET="/mnt"
PKGS=("readline" "glibc" "bash" "coreutils")
ARCH_CACHE="/var/cache/pacman/pkg"

echo "--- Iniciando reparación de emergencia de $TARGET ---"

# 1. Asegurar montajes críticos
echo "[1/4] Verificando montajes de API del kernel..."
for dir in dev proc sys run; do
    if ! mountpoint -q "$TARGET/$dir"; then
        echo "Montando /$dir..."
        mount --bind "/$dir" "$TARGET/$dir"
    fi
done

# 2. Reparar /dev/null (visto como archivo regular en strace)
echo "[2/4] Corrigiendo nodos de dispositivo críticos..."
rm -f "$TARGET/dev/null"
mknod -m 666 "$TARGET/dev/null" c 1 3
echo "Dispositivo /dev/null restaurado."

# 3. Inyección manual de paquetes (bypass de pacman hooks)
echo "[3/4] Extrayendo paquetes base manualmente para resolver symbol errors..."
for pkg in "${PKGS[@]}"; do
    # Buscamos el paquete más reciente en el caché
    PKG_FILE=$(ls -v1 $ARCH_CACHE/$pkg-*.pkg.tar.zst 2>/dev/null | tail -n 1)

    if [ -z "$PKG_FILE" ]; then
        echo "Error: No se encontró el paquete $pkg en $ARCH_CACHE. Intentando descargar..."
        pacman -Sw --noconfirm "$pkg"
        PKG_FILE=$(ls -v1 $ARCH_CACHE/$pkg-*.pkg.tar.zst | tail -n 1)
    fi

    echo "Extrayendo $pkg..."
    tar --zstd -xvf "$PKG_FILE" -C "$TARGET" --exclude=".PKGINFO" --exclude=".INSTALL" --exclude=".MTREE" --exclude=".BUILDINFO" > /dev/null
done

# 4. Sincronizar y regenerar locales
echo "[4/4] Intentando regenerar base de datos de librerías y locales..."
ldconfig -r "$TARGET"
LC_ALL=C chroot "$TARGET" locale-gen 2>/dev/null || echo "Aviso: No se pudo ejecutar locale-gen todavía."

echo "--- Proceso finalizado ---"
echo "Intentá entrar con: LC_ALL=C chroot $TARGET /usr/bin/bash --norc"
