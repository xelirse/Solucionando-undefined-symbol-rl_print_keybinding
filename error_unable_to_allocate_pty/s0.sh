#!/bin/bash

# Comprobar si se ejecuta como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, corre el script con sudo."
  exit
fi

echo "--- 1. Limpiando archivos de base de datos corruptos ---"
rm -f /var/lib/pacman/sync/*.db

echo "--- 2. Eliminando el llavero de GPG actual ---"
rm -rf /etc/pacman.d/gnupg

echo "--- 3. Inicializando nuevo llavero ---"
pacman-key --init

echo "--- 4. Cargando llaves oficiales de Arch Linux ---"
pacman-key --populate archlinux

# Opcional: Si usas Chaotic-AUR u otros, podrías necesitar cargarlos también
# pacman-key --populate chaotic

echo "--- 5. Refrescando las llaves (esto puede tardar) ---"
pacman-key --refresh-keys

echo "--- 6. Sincronizando y actualizando el sistema ---"
pacman -Syu

echo "--- ¡Proceso finalizado! Intenta instalar glibc ahora ---"
