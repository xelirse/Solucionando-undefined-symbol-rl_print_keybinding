#!/bin/bash
TARGET="/mnt"
ARCH_CACHE="/var/cache/pacman/pkg"

echo "--- PROTOCOLO DE RECONSTRUCCIÓN DE ENLACES ---"

# 1. Asegurar que los directorios tengan permisos correctos
echo "[1/4] Corrigiendo permisos de sistema..."
chmod 755 "$TARGET"
chmod 755 "$TARGET/usr" "$TARGET/usr/lib" "$TARGET/usr/bin"

# 2. Re-extracción forzada de Readline
echo "[2/4] Extrayendo Readline 8.3..."
PKG_RL=$(ls -v1 $ARCH_CACHE/readline-8.3*.pkg.tar.zst | tail -n 1)
tar --zstd -xvf "$PKG_RL" -C "$TARGET" --exclude=".PK*" > /dev/null

# 3. REPARACIÓN MANUAL DE ENLACES (Crucial)
echo "[3/4] Creando enlaces simbólicos manualmente..."
cd "$TARGET/usr/lib"
# Borramos posibles archivos corruptos o enlaces rotos
rm -f libreadline.so.8 libreadline.so

# Buscamos el archivo real que extrajo el tar (debería ser libreadline.so.8.3)
REAL_FILE=$(ls libreadline.so.8.3 2>/dev/null)

if [ -z "$REAL_FILE" ]; then
    echo "ERROR: No se encontró libreadline.so.8.3 en $TARGET/usr/lib"
    exit 1
fi

ln -sf "$REAL_FILE" libreadline.so.8
ln -sf "$REAL_FILE" libreadline.so
echo "Enlazado: libreadline.so.8 -> $REAL_FILE"

# 4. Sincronizar y Probar
echo "[4/4] Sincronizando discos..."
sync
ldconfig -r "$TARGET"

echo "------------------------------------------------"
echo "Intento de entrada final:"
chroot "$TARGET" /usr/bin/bash --norc
