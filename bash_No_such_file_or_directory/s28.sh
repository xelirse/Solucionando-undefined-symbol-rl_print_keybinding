# 1. Asegurate de que NADA esté montado
umount -l /mnt/emergency_clear 2>/dev/null
umount -l /mnt 2>/dev/null

# 2. Limpiar el log de transacciones (Esto puede destrabar el Segfault)
# Reemplaza /dev/sda1 si tu partición es distinta
btrfs rescue zero-log /dev/sda1

# 3. Intentar montaje con descarte de bloques (Discard) para forzar liberación
mount -t btrfs -o subvol=@,discard,rw /dev/sda1 /mnt

# 4. Verificar si ahora existe /mnt/proc
ls -la /mnt
