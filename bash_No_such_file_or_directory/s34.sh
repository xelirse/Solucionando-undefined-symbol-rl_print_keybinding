# 1. Limpieza de librerías duplicadas/viejas
echo "Limpiando enlaces de readline antiguos..."
rm -f /mnt/usr/lib/libreadline.so.8*
rm -f /mnt/lib/libreadline.so.8*

# 2. Re-extracción limpia (Solo Readline)
echo "Re-inyectando Readline limpio..."
PKG_READLINE=$(ls -v1 /var/cache/pacman/pkg/readline-*.pkg.tar.zst | tail -n 1)
tar --zstd -xvf "$PKG_READLINE" -C /mnt --exclude=".PKGINFO" > /dev/null

# 3. Forzar el enlace simbólico correcto
# Bash suele buscar libreadline.so.8.2 o similar
cd /mnt/usr/lib/
REAL_LIB=$(ls libreadline.so.8.* | head -n 1)
ln -sf "$REAL_LIB" libreadline.so.8
ln -sf "$REAL_LIB" libreadline.so

# 4. Actualizar el caché de librerías del chroot desde afuera
ldconfig -r /mnt
