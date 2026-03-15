#!/bin/bash

# 1. Definir la ruta de montaje
TARGET="/mnt"

echo "--- Iniciando reparación de emergencia en $TARGET ---"

# 2. Montar sistemas de archivos críticos del kernel
# Usamos un bucle para asegurar que la API del kernel esté disponible
for dir in proc sys dev dev/pts run; do
    if ! mountpoint -q "$TARGET/$dir"; then
        mount --bind /$dir "$TARGET/$dir"
        echo "Montado: $dir"
    fi
done

# 3. Reparación de paquetes críticos (Fuerza Bruta)
# Usamos el pacman del sistema Live para instalar HACIA /mnt.
# Esto evita ejecutar los scripts de post-instalación internos que están fallando.
echo "--- Reinstalando glibc, bash y readline desde el exterior ---"
pacman --root "$TARGET" --cachedir "$TARGET/var/cache/pacman/pkg" \
       --dbpath "$TARGET/var/lib/pacman" -S --noconfirm \
       glibc bash readline coreutils --overwrite "*"

# 4. Limpiar caché de librerías dinámicas
echo "--- Refrescando ld.so.cache ---"
ldconfig -r "$TARGET"

# 5. Intento de entrada segura
echo "--- Intentando entrar al entorno ---"
echo "Si bash sigue fallando, intentaremos con el shell estático busybox."

# Intentar entrar limpiando el entorno previo
chroot "$TARGET" /usr/bin/env -i TERM=$TERM PATH=/usr/bin:/usr/local/bin /bin/bash -i
