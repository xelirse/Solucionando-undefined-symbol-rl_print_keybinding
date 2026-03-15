#!/bin/bash
UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
TARGET="/mnt/manjaro_recovery"

echo "--- OPERACIÓN DESCOMPRESIÓN: LIBERANDO METADATOS ---"

# 1. Montaje
umount -R $TARGET 2>/dev/null
mount -t btrfs -o subvol=@ UUID=$UUID_ROOT $TARGET

# 2. LIMPIEZA RADICAL DE ESPACIO (Desde afuera del chroot)
echo "Borrando basura acumulada para liberar bloques de metadatos..."
rm -rf $TARGET/var/cache/pacman/pkg/*
rm -rf $TARGET/var/log/*
rm -rf $TARGET/tmp/*
rm -rf $TARGET/home/*/.cache/*

# 3. ELIMINAR EL CACHÉ DE LIBRERÍAS CORRUPTO (Causa de los Segfaults)
rm -f $TARGET/etc/ld.so.cache

# 4. VERIFICACIÓN DE ESTADO LÓGICO
echo "Estado de errores en el dispositivo:"
btrfs device stats $TARGET

echo "--------------------------------------------------"
echo " ESPACIO LIBERADO. SI EL SEGFAULT PERSISTE, "
echo " EL SISTEMA DE ARCHIVOS ESTÁ CORRUPTO. "
echo "--------------------------------------------------"
df -h $TARGET
