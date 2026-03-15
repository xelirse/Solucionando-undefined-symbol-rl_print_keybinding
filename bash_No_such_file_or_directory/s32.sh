#!/bin/bash
# REPARADOR DE EMERGENCIA PARA SISTEMAS CON SEGFAULT

TARGET="/mnt" # Asegurate de que tu disco esté montado en /mnt
USB_LIB="/usr/lib"
USB_BIN="/usr/bin"

echo "--- PASO 1: Inyección de librerías de ejecución sanas ---"
# Intentamos copiar librerías críticas del USB al disco para pisar la corrupción
# Usamos 'cp' directamente porque pacman falla por el Segfault
cp -v /usr/lib/libc.so.6 $TARGET/usr/lib/
cp -v /usr/lib/libreadline.so.8 $TARGET/usr/lib/
cp -v /usr/lib/libncursesw.so.6 $TARGET/usr/lib/
cp -v /usr/bin/bash $TARGET/usr/bin/bash

echo "--- PASO 2: Limpieza de locales (donde strace mostró el fallo) ---"
# Movemos los locales corruptos para que bash no intente cargarlos
mv $TARGET/usr/lib/locale/locale-archive $TARGET/usr/lib/locale/locale-archive.bak 2>/dev/null

echo "--- PASO 3: Intento de entrada mínima ---"
# Entramos sin cargar el entorno (evita leer archivos de config corruptos)
chroot $TARGET /usr/bin/bash --noprofile --norc
