#!/bin/bash

TARGET="/mnt"

echo "--- 1. Preparando el trasplante de emergencia ---"
# Asegurar que los directorios existen
mkdir -p "$TARGET/usr/lib"
mkdir -p "$TARGET/usr/bin"

echo "--- 2. Copiando librerías críticas (Glibc y Readline) ---"
# Copiamos el cargador dinámico y las librerías base del Live USB al disco
cp -v /usr/lib/libc.so.6 "$TARGET/usr/lib/"
cp -v /usr/lib/libreadline.so.8 "$TARGET/usr/lib/"
cp -v /usr/lib/libncursesw.so.6 "$TARGET/usr/lib/"
cp -v /usr/lib/ld-linux-x86-64.so.2 "$TARGET/usr/lib/"

echo "--- 3. Copiando binarios básicos ---"
cp -v /usr/bin/bash "$TARGET/usr/bin/"
cp -v /usr/bin/sh "$TARGET/usr/bin/"
cp -v /usr/bin/env "$TARGET/usr/bin/"

echo "--- 4. Sincronizando enlaces simbólicos ---"
# A veces /lib64 es un symlink, aseguramos que el cargador sea visible
mkdir -p "$TARGET/lib64"
ln -sf /usr/lib/ld-linux-x86-64.so.2 "$TARGET/lib64/ld-linux-x86-64.so.2"

echo "--- 5. Intentando CHROOT de rescate ---"
# Montajes necesarios
for dir in proc sys dev; do
    mount --bind /$dir "$TARGET/$dir" 2>/dev/null
done

# Intentar entrar con un entorno vacío para evitar errores de locales
chroot "$TARGET" /usr/bin/env -i PATH=/usr/bin:/usr/local/bin /usr/bin/bash --noprofile --norc
