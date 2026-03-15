#!/bin/bash
# Ejecutar como sudo desde el anfitrión (Manjaro Live/Sistema principal)

TARGET="/mnt"
ARCH_CACHE="/var/cache/pacman/pkg"

echo "--- PROTOCOLO DE RESCATE ESTRUCTURAL ---"

# 1. Limpieza de enlaces de 64 bits
echo "[1/5] Corrigiendo enlaces simbólicos de 64 bits..."
rm -rf "$TARGET/lib64"
ln -s usr/lib "$TARGET/lib64"

# 2. Asegurar estructura USR Merge
echo "[2/5] Verificando USR Merge..."
for dir in bin sbin lib; do
    if [ ! -L "$TARGET/$dir" ]; then
        mv "$TARGET/$dir"/* "$TARGET/usr/$dir/" 2>/dev/null
        rm -rf "$TARGET/$dir"
        ln -s "usr/$dir" "$TARGET/$dir"
    fi
done

# 3. Inyección de emergencia de Runtime (Glibc + Readline + Bash)
echo "[3/5] Re-inyectando base con TAR (Bypass post-install)..."
for pkg in glibc readline bash coreutils; do
    PKG_PATH=$(ls -v1 $ARCH_CACHE/$pkg-*.pkg.tar.zst | tail -n 1)
    echo "Extrayendo $pkg desde $PKG_PATH..."
    tar --zstd -xpf "$PKG_PATH" -C "$TARGET" --exclude=".PK*"
done

# 4. Forzar regeneración del caché de librerías del objetivo
echo "[4/5] Regenerando ld.so.cache..."
ldconfig -r "$TARGET"

# 5. Intento de entrada usando el cargador explícito
echo "[5/5] Probando ejecución directa..."
echo "------------------------------------------------"

# Intentamos ejecutar el bash del chroot usando el cargador del chroot explícitamente
# Esto evita que se usen librerías del anfitrión que causan Segfault
LOADER=$(ls $TARGET/usr/lib/ld-linux-x86-64.so.2)
chroot "$TARGET" /usr/lib/ld-linux-x86-64.so.2 /usr/bin/bash --norc
