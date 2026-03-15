#!/bin/bash

# Verificar que somos root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, corre el script como root (sudo)."
  exit
fi

TARGET="/mnt"

echo "--- Preparando entorno para chroot en $TARGET ---"

# 1. Montajes críticos de la API del Kernel
for dir in proc sys dev dev/pts run; do
    if ! mountpoint -q "$TARGET/$dir"; then
        mount --bind /$dir "$TARGET/$dir"
        echo "Montado: $dir"
    fi
done

# 2. Copiar DNS para tener internet dentro
cp /etc/resolv.conf "$TARGET/etc/resolv.conf"

echo "--- Intentando entrar al entorno ---"
echo "Si bash falla, intentaremos con /bin/sh..."

# 3. Intento de chroot dinámico
# Usamos env -i para limpiar variables de entorno que puedan causar conflictos con las locales
chroot "$TARGET" /usr/bin/env -i TERM=$TERM PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /bin/bash

if [ $? -ne 0 ]; then
    echo "¡BASH FALLÓ! Intentando con un shell mínimo (sh)..."
    chroot "$TARGET" /bin/sh
fi
