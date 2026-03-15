#!/bin/bash

TARGET="/mnt"
ARCH_CACHE="/var/cache/pacman/pkg"

echo "--- INICIANDO PROTOCOLO DE REPARACIÓN TOTAL ---"

# 1. Asegurar que /lib sea un link a /usr/lib (Estructura Arch/Manjaro)
echo "[1/5] Corrigiendo estructura de directorios..."
if [ ! -L "$TARGET/lib" ]; then
    echo "Aviso: /lib no es un link. Corrigiendo..."
    # Si /lib existe como carpeta, movemos contenido y enlazamos
    mv "$TARGET/lib"/* "$TARGET/usr/lib/" 2>/dev/null
    rm -rf "$TARGET/lib"
    ln -s usr/lib "$TARGET/lib"
fi

# 2. Limpieza agresiva de Readline
echo "[2/5] Purgando librerías Readline viejas..."
find "$TARGET/usr/lib" -name "libreadline.so*" -delete

# 3. Inyección manual desde caché
echo "[3/5] Re-inyectando Readline, Glibc y Bash..."
for pkg in readline glibc bash; do
    PKG_FILE=$(ls -v1 $ARCH_CACHE/$pkg-*.pkg.tar.zst | tail -n 1)
    echo "Extrayendo $PKG_FILE..."
    tar --zstd -xvf "$PKG_FILE" -C "$TARGET" --exclude=".PK*" > /dev/null
done

# 4. Forzar regeneración de enlaces simbólicos internos
echo "[4/5] Ejecutando ldconfig (vía anfitrión sobre target)..."
ldconfig -r "$TARGET"

# 5. Prueba de entrada forzada
echo "[5/5] Intentando acceso con LD_PRELOAD..."
echo "------------------------------------------------"
LD_PRELOAD="$TARGET/usr/lib/libreadline.so.8" chroot "$TARGET" /usr/bin/bash -c "echo 'LOGRÉ ENTRAR'; locale-gen; exit"

if [ $? -eq 0 ]; then
    echo "--- ÉXITO: El entorno ya es ejecutable ---"
    echo "Ahora puedes entrar normalmente con: chroot $TARGET"
else
    echo "--- FALLO CRÍTICO ---"
    echo "El binario sigue sin encontrar el símbolo. Ejecuta:"
    echo "strings $TARGET/usr/lib/libreadline.so.8 | grep rl_print_keybinding"
fi
