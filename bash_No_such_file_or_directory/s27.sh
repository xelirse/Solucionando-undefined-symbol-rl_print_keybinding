#!/bin/bash
UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/emergency_clear"

echo "--- OPERACIÓN DESCOMPRESIÓN DE BLOQUES ---"

# 1. Montaje limpio
umount -l $TARGET 2>/dev/null
mkdir -p $TARGET
mount -t btrfs -o subvol=@,rw,nodatacow UUID=$UUID_ROOT $TARGET

# 2. BORRADO FÍSICO (Liberar bloques de metadatos)
# Si no borramos archivos reales, Btrfs no puede regenerar el árbol de nodos
echo "[1/2] Borrando archivos de caché para liberar nodos..."
rm -rf $TARGET/var/cache/pacman/pkg/*
rm -rf $TARGET/var/log/*
rm -rf $TARGET/home/*/.cache/*

# 3. ELIMINAR LOCKS DE BASE DE DATOS
rm -f $TARGET/var/lib/pacman/db.lck
rm -rf $TARGET/etc/pacman.d/gnupg/S.gpg-agent*

# 4. BALANCEO CRÍTICO (ESTO ES LO QUE PUEDE SALVARTE)
# Intentamos decirle a Btrfs que reorganice los pedazos vacíos
echo "[2/2] Intentando balanceo de metadatos (puede tardar)..."
btrfs balance start -musage=0 $TARGET

echo "--------------------------------------------------"
echo " Espacio después de la purga: "
df -h $TARGET
echo "--------------------------------------------------"
umount $TARGET
