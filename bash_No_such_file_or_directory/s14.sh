#!/bin/bash

UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/manjaro_recovery"

echo "--- OPERACIÓN LIMPIEZA QUIRÚRGICA: READLINE ---"

# 1. Montaje
umount -R $TARGET 2>/dev/null
mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $TARGET

# 2. BORRADO FÍSICO DE LIBRERÍAS (Elimina rastro de versiones viejas)
echo "Borrando físicamente archivos de Readline del disco..."
# Eliminamos todo lo que empiece por libreadline y libhistory
rm -f $TARGET/usr/lib/libreadline.so*
rm -f $TARGET/usr/lib/libhistory.so*

# 3. REINSTALACIÓN EXTERNA (Ahora sin archivos que estorben)
echo "Reinstalando Readline y Bash mediante Pacman --root..."
pacman --root $TARGET -Sy --noconfirm --overwrite "*" readline bash glibc

# 4. VERIFICACIÓN DE ENLACES (IMPORTANTE)
# A veces quedan enlaces rotos en /lib que apuntan a versiones que ya no existen
echo "Sincronizando enlaces simbólicos..."
ldconfig -r $TARGET

# 5. EL PARCHE DE EMERGENCIA FINAL
# Si el bash del disco sigue fallando, vamos a SUSTITUIRLO temporalmente
# por el bash del Live USB para que al menos puedas entrar y ejecutar comandos.
echo "Aplicando parche de binario cruzado (Live -> Disco)..."
cp /usr/bin/bash $TARGET/usr/bin/bash
cp -d /usr/lib/libreadline.so.8* $TARGET/usr/lib/

# 6. Montar binds y entrar
for i in dev dev/pts proc sys run; do mount --bind /$i $TARGET/$i; done

echo "--------------------------------------------------"
echo " INTENTO DE ENTRADA CON BINARIOS SINCRONIZADOS "
echo "--------------------------------------------------"
chroot $TARGET /usr/bin/bash --login
