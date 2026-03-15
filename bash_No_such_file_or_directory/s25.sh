#!/bin/bash
UUID_ROOT="cfb49c22-87f2-47d9-a25b-310d8d8578af"
DEV="/dev/sda1" # Verifica si es sda1 o nvme0n1p1 con lsblk

echo "--- DIAGNÓSTICO PROFUNDO DE BTRFS ---"

# 1. Desmontar todo para chequear
umount -l /mnt/manjaro_recovery 2>/dev/null

# 2. Verificación de errores de suma (Checksum errors)
echo "[1/3] Buscando errores de integridad en el dispositivo..."
btrfs check --readonly $DEV

# 3. Verificación de salud física (S.M.A.R.T.)
echo "[2/3] Verificando salud física del disco..."
smartctl -H $DEV

# 4. Intento de recuperación de archivos críticos
echo "[3/3] Intentando montar en modo recuperación (read-only)..."
mkdir -p /mnt/rescue
mount -t btrfs -o subvol=@,ro,usebackuproot,nologreplay $DEV /mnt/rescue

if [ $? -eq 0 ]; then
    echo "¡ÉXITO! El disco se montó en modo RECOVERY (Solo lectura)."
    echo "Aprovechá para copiar tus proyectos YA."
    df -h /mnt/rescue
else
    echo "FALLO CRÍTICO: El sistema de archivos no puede ni siquiera montarse en modo rescate."
fi
