#!/bin/bash

UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/manjaro_recovery"

echo "--- REPARACIÓN DE SÍMBOLOS Y LIBRERÍAS ---"

# 1. Montaje
umount -R $TARGET 2>/dev/null
mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $TARGET

# 2. Sincronizar bases de datos de pacman del Live al Disco
echo "Sincronizando repositorios..."
mkdir -p $TARGET/var/lib/pacman
rsync -a /var/lib/pacman/sync $TARGET/var/lib/pacman/

# 3. Reinstalación FORZADA desde afuera
# Usamos --root para que pacman use sus propias librerías (las del Live)
# para instalar las correctas en tu disco.
echo "Reinstalando paquetes discordantes..."
pacman --root $TARGET -S --noconfirm --overwrite "*" \
    readline bash openssl glibc ncurses

# 4. Limpieza de caché de librerías en el destino
ldconfig -r $TARGET

# 5. Montar binds necesarios
for i in dev dev/pts proc sys run; do mount --bind /$i $TARGET/$i; done

echo "--------------------------------------------------"
echo " INTENTANDO ENTRAR (MODO COMPATIBILIDAD) "
echo "--------------------------------------------------"

# Intentamos entrar con un PATH limpio
chroot $TARGET /usr/bin/env -i TERM=$TERM PATH=/usr/bin:/usr/sbin /usr/bin/bash --login
