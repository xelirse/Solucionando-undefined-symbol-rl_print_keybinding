You asked:
----------

Has dicho

Tengo este problema, ¿Se puede solucionar?

  

   /mnt  sudo su                                                                                                      ✔  root@manjaro  

sudo: unable to allocate pty: No such device

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Ese error suele ser bastante frustrante porque te bloquea el acceso como superusuario, pero **sí, tiene solución**.

El mensaje `sudo: unable to allocate pty: No such device` ocurre generalmente porque el sistema de archivos virtual **devpts** no está montado o se ha corrompido. Este sistema es el encargado de gestionar las "pseudo-terminales" (PTY) que permiten a procesos como `sudo` interactuar con tu terminal.

Aquí tienes los pasos para recuperar el control:

* * *

1\. Solución inmediata (Montaje manual)
---------------------------------------

Intenta forzar el montaje del sistema de archivos de terminales virtuales con este comando:

Bash

    mount -t devpts devpts /dev/pts

Si esto falla porque no tienes permisos, intenta anteponer `sudo`, aunque es probable que el error persista. Si estás en una sesión donde ya eres root o tienes acceso parcial, esto debería reactivar las terminales.

2\. Verificar el archivo `/etc/fstab`
-------------------------------------

Es posible que la entrada que monta automáticamente `/dev/pts` haya desaparecido o esté comentada.

1.  Abre el archivo: `nano /etc/fstab` (o usa el editor que puedas abrir).
    
2.  Asegúrate de que exista una línea como esta:
    
    > `devpts /dev/pts devpts gid=5,mode=620 0 0`
    
3.  Si no está, añádela, guarda y reinicia.
    

3\. El "truco" si nada de lo anterior funciona
----------------------------------------------

Si estás atrapado sin poder usar `sudo` en absoluto, intenta entrar a una terminal real (TTY) presionando `Ctrl` + `Alt` + `F2` (o F3, F4...).

Desde ahí:

*   Loguéate directamente como **root**.
    
*   Ejecuta: `mount -a` para refrescar todos los puntos de montaje.
    
*   Revisa si el directorio existe: `ls -d /dev/pts`. Si no existe, créalo con `mkdir /dev/pts`.
    

* * *

¿Por qué pasó esto?
-------------------

Esto suele ocurrir en entornos de contenedores (como Docker o WSL) o después de una actualización de kernel en Manjaro/Arch donde los puntos de montaje de dispositivos no se refrescaron correctamente.

**¿Has realizado alguna actualización de sistema o cambio en las particiones recientemente?** Si me das más contexto, puedo ser más específico.

Has parado esta respuesta

---

You asked:
----------

Has dicho

Launching Dolphin (Failed)

No such file or directory

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Parece que el problema en tu Manjaro es más profundo que un simple error de terminal; si **Dolphin** (el explorador de archivos) no abre y dice que no existe el archivo o directorio, es muy probable que tu sistema de archivos se haya montado en modo **solo lectura** o que los puntos de montaje esenciales (`/dev`, `/proc`, `/sys`) estén corruptos o desaparecidos.

Esto suele pasar tras un apagado forzado o un fallo en el disco. Vamos a intentar rescatarlo paso a paso:

* * *

1\. Forzar el montaje de la raíz como escritura
-----------------------------------------------

Si el sistema cree que el disco tiene errores, a veces bloquea la escritura. Intenta esto en la terminal:

Bash

    mount -o remount,rw /

2\. Verificar si Dolphin realmente "existe"
-------------------------------------------

Es raro que desaparezca el binario, pero el error "No such file or directory" al lanzar una app suele referirse a una **librería faltante** o a que el sistema no encuentra el punto de montaje `/usr`. Prueba ejecutarlo por terminal para ver el error real:

Bash

    dolphin

_Si te da un error de "shared libraries", es que una actualización se quedó a medias._

3\. La solución "maestra": Reparar desde una Live USB
-----------------------------------------------------

Dado que no puedes usar `sudo` ni abrir aplicaciones básicas, la forma más segura de arreglar Manjaro es desde fuera:

1.  Arranca tu PC con el **USB de instalación de Manjaro**.
    
2.  Abre una terminal en el entorno Live y usa la herramienta **manjaro-chroot**:
    
    Bash
    
        manjaro-chroot -a
    
    _(Esto te meterá dentro de tu sistema instalado con privilegios de root reales)._
    
3.  Una vez dentro ("dentro" de tu disco duro), ejecuta:
    
    *   **Reparar paquetes:** `pacman -Syu`
        
    *   **Reinstalar Dolphin:** `pacman -S dolphin`
        
    *   **Asegurar puntos de montaje:** `mount -a`
        

* * *

¿Qué pudo causar esto?
----------------------

Si estás viendo estos errores en `/mnt`, ¿estás intentando ejecutar cosas desde un disco externo o una partición distinta? Si el error aparece al intentar abrir Dolphin normalmente desde el menú de inicio, lo más probable es que tu **tabla de particiones** o el archivo `/etc/fstab` tengan un error crítico.

**¿Recuerdas si estabas moviendo particiones o editando archivos del sistema antes de que esto pasara?**

Has parado esta respuesta

---

You asked:
----------

Has dicho

   /mnt  sudo su                                                                                                      ✔  root@manjaro  

sudo: unable to allocate pty: No such device

   /mnt  mount -t devpts devpts /dev/pts                                                                            1 ✘  root@manjaro  

   /mnt  mount -t devpts devpts /dev/pts                                                                          INT ✘  root@manjaro  

   /mnt  sudo su                                                                                                      ✔  root@manjaro  

\[manjaro mnt\]# mount -o remount,rw /

\[manjaro mnt\]# dolphin

Running Dolphin with sudo is discouraged. Please run “dolphin --sudo” instead.

\[manjaro mnt\]# dolphin --sudo

Running Dolphin with sudo is discouraged. Please run “dolphin --sudo” instead.

\[manjaro mnt\]# manjaro-chroot -a

ERROR: mkdir /var/lock/dmraid

\==> ERROR: No Linux partitions detected!

\[manjaro mnt\]# pacman -Syu

:: Synchronizing package databases...

core is up to date

extra is up to date

multilib is up to date

andontie-aur is up to date

archlinuxgr is up to date

archlinuxcn is up to date

extra-alucryd is up to date

arcanisrepo is up to date

chaotic-aur                                              646,6 KiB   167 KiB/s 00:04 \[#################################################\] 100%

archstrike is up to date

:: Starting full system upgrade...

warning: ttf-meslo-nerd-font-powerlevel10k: local (20230403-2) is newer than chaotic-aur (2.3.3-1.1)

warning: update-grub: local (2:2.12.r292.g73d1c959-1) is newer than chaotic-aur (0.0.1-8.1)

:: Replace vi with extra/ex-vi-compat? \[Y/n\]  

resolving dependencies...

looking for conflicting packages...

error: failed to prepare transaction (could not satisfy dependencies)

:: installing pacman (7.1.0.r9.g54d9411-1) breaks dependency 'libalpm.so=15' required by libpamac

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Esto se está complicando porque tienes un **conflicto de dependencias crítico** (el famoso error de `libalpm`) y, además, parece que estás operando desde un entorno Live (o un estado muy degradado) donde `manjaro-chroot` no detecta tus particiones.

El error de `libalpm.so=15` ocurre porque intentas actualizar `pacman`, pero `libpamac` (la base de la tienda de aplicaciones de Manjaro) aún necesita la versión vieja.

Aquí tienes la hoja de ruta para salir de este "infierno de dependencias":

* * *

1\. Detectar tu partición real
------------------------------

Como `manjaro-chroot -a` falló, debemos hacerlo manualmente. Primero identifica dónde está instalado tu Manjaro:

Bash

    lsblk

Busca la partición más grande (ej. `sda2`, `nvme0n1p2`). Supongamos que es `/dev/sdXn`.

2\. Montar manualmente y entrar (Chroot manual)
-----------------------------------------------

Si el script automático falla, hazlo a pie:

Bash

    # Monta tu sistema raíz (cambia sdXn por tu partición)
    mount /dev/sdXn /mnt
    
    # Monta los sistemas necesarios para que la terminal funcione
    mount --bind /dev /mnt/dev
    mount --bind /proc /mnt/proc
    mount --bind /sys /mnt/sys
    mount --bind /run /mnt/run
    
    # Entra al sistema
    chroot /mnt /bin/bash

3\. Solucionar el error de `libalpm` y Pacman
---------------------------------------------

Una vez dentro (verás que el prompt cambia), no puedes hacer un `-Syu` normal por el conflicto con `libpamac`. Vamos a actualizar saltándonos esa comprobación momentáneamente o eliminando el bloqueador:

**Opción A (Recomendada): Actualizar todo ignorando el paquete que rompe**

Bash

    pacman -Syu --ignore libpamac

**Opción B (Si la A falla): Forzar la actualización de la base de datos** A veces, `pamac` se queda atrás. Intenta actualizarlo primero a él si es posible, o reinstalar la librería:

Bash

    pacman -Syyu

4\. ¿Por qué Dolphin no abre?
-----------------------------

Dolphin **jamás** debe abrirse con `sudo` (por seguridad, KDE lo bloquea). Si necesitas gestionar archivos como root, una vez arreglado el sistema de archivos y las librerías, usa:

*   `SUDO_EDITOR=nano sudoedit /ruta/al/archivo` (para editar texto).
    
*   O simplemente repara el sistema y ábrelo normal. El error de "No such file or directory" desaparecerá en cuanto las librerías (`libalpm` y otras) se sincronicen.
    

* * *

Resumen del estado actual
-------------------------

Tu sistema tiene un **desajuste de versiones** entre los repositorios de Manjaro y repositorios externos que tienes activos (como `chaotic-aur`). Esto ha causado que la base de datos de paquetes se rompa.

**¿Puedes decirme qué particiones te mostró el comando `lsblk`?** Así te daré el comando exacto para montar.

Has parado esta respuesta

---

You asked:
----------

Has dicho

\[manjaro mnt\]# mount -a

\[manjaro mnt\]# lsblk

NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS

loop0    7:0    0   4,1G  1 loop /run/miso/bootmnt

loop1    7:1    0  92,6M  1 loop /run/miso/sfs/livefs

loop2    7:2    0   1,2G  1 loop /run/miso/sfs/mhwdfs

loop3    7:3    0   1,8G  1 loop /run/miso/sfs/desktopfs

loop4    7:4    0 886,9M  1 loop /run/miso/sfs/rootfs

sda      8:0    0   149G  0 disk  

└─sda1   8:1    0   149G  0 part /mnt

                                /mnt

                                /mnt

sdb      8:16   1  28,8G  0 disk  

└─sdb1   8:17   1  28,8G  0 part /run/miso/img\_dev

\[manjaro mnt\]# mount /dev/sda1 /mnt

\[manjaro mnt\]# # Monta los sistemas necesarios para que la terminal funcione

mount --bind /dev /mnt/dev

mount --bind /proc /mnt/proc

mount --bind /sys /mnt/sys

mount --bind /run /mnt/run

  

\# Entra al sistema

chroot /mnt /bin/bash

mount: /mnt/dev: mount point does not exist.

      dmesg(1) may have more information after failed mount system call.

mount: /mnt/proc: mount point does not exist.

      dmesg(1) may have more information after failed mount system call.

mount: /mnt/sys: mount point does not exist.

      dmesg(1) may have more information after failed mount system call.

mount: /mnt/run: mount point does not exist.

      dmesg(1) may have more information after failed mount system call.

chroot: failed to run command ‘/bin/bash’: No such file or directory

\[manjaro mnt\]# pacman -Syu --ignore libpamac

:: Synchronizing package databases...

core is up to date

extra is up to date

multilib is up to date

andontie-aur is up to date

archlinuxgr is up to date

archlinuxcn is up to date

extra-alucryd is up to date

arcanisrepo is up to date

chaotic-aur is up to date

archstrike is up to date

:: Starting full system upgrade...

warning: ttf-meslo-nerd-font-powerlevel10k: local (20230403-2) is newer than chaotic-aur (2.3.3-1.1)

warning: update-grub: local (2:2.12.r292.g73d1c959-1) is newer than chaotic-aur (0.0.1-8.1)

:: Replace vi with extra/ex-vi-compat? \[Y/n\]  

resolving dependencies...

looking for conflicting packages...

error: failed to prepare transaction (could not satisfy dependencies)

:: installing pacman (7.1.0.r9.g54d9411-1) breaks dependency 'libalpm.so=15' required by libpamac

\[manjaro mnt\]# pacman -Syyu

:: Synchronizing package databases...

core                                                     122,3 KiB  77,3 KiB/s 00:02 \[#################################################\] 100%

extra                                                      8,0 MiB   409 KiB/s 00:20 \[#################################################\] 100%

multilib                                                 127,6 KiB  94,5 KiB/s 00:01 \[#################################################\] 100%

andontie-aur                                             140,7 KiB   178 KiB/s 00:01 \[#################################################\] 100%

archlinuxgr                                                9,4 KiB   938   B/s 00:10 \[#################################################\] 100%

archlinuxcn                                             1342,6 KiB  67,7 KiB/s 00:20 \[#################################################\] 100%

extra-alucryd                                            231,9 KiB  12,7 KiB/s 00:18 \[#################################################\] 100%

arcanisrepo                                               49,7 KiB  5,89 KiB/s 00:08 \[#################################################\] 100%

chaotic-aur                                              646,6 KiB   133 KiB/s 00:05 \[#################################################\] 100%

archstrike.db failed to download

error: failed retrieving file 'archstrike.db' from mirror.archstrike.org : Operation too slow. Less than 1 bytes/sec transferred the last 10 s

econds

error: failed to synchronize all databases (download library error)

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Esto está ocurriendo porque hay un **conflicto circular** entre la sesión que tienes abierta (que parece ser la del Live USB o una sesión de rescate) y tu disco duro.

El motivo por el cual fallan los comandos `mount --bind` es que ya tienes `/dev/sda1` montado en `/mnt`, pero cuando intentas montar `/mnt/dev`, el sistema busca esa carpeta **dentro** de `/mnt` y no la encuentra. Esto sugiere que **tu disco duro (`sda1`) está vacío o el sistema de archivos está tan dañado que no se ve nada dentro.**

Vamos a intentar rescatar los datos y el sistema con un enfoque distinto:

* * *

1\. Comprueba si hay algo en tu disco
-------------------------------------

Ejecuta esto:

Bash

    ls /mnt

*   **Si no sale nada (está vacío):** No estás montando la partición correcta o el sistema de archivos está dañado.
    
*   **Si salen carpetas (bin, boot, etc):** Entonces el problema es de rutas.
    

2\. El problema del "Chroot" y los puntos de montaje
----------------------------------------------------

Como ya montaste `/dev/sda1` en `/mnt`, intenta crear las carpetas que faltan (si es que no aparecen) o verifica que la ruta sea correcta. Si `ls /mnt` está vacío, prueba esto:

Bash

    umount /mnt
    mount /dev/sda1 /mnt
    ls /mnt

_(Si después de esto `ls /mnt` sigue vacío, tu partición `sda1` tiene un problema serio en el sistema de archivos)._

3\. Solucionar el error de Pacman (libalpm)
-------------------------------------------

El error `installing pacman breaks dependency 'libalpm.so=15' required by libpamac` es un bloqueo clásico en Manjaro cuando los repositorios se desfasan. Para saltarlo, debes actualizar ambos al mismo tiempo o quitar el que bloquea:

**Prueba este comando (fuerza la actualización de ambos):**

Bash

    pacman -Syu pacman pamac-gtk

O, si no usas la interfaz de Pamac habitualmente, quítalo para dejar que el sistema actualice:

Bash

    pacman -R libpamac pamac-gtk
    pacman -Syu

4\. Reparar el error de descarga (Archstrike)
---------------------------------------------

El repositorio `archstrike` te está bloqueando la actualización porque el mirror está caído o va muy lento. Vamos a desactivarlo temporalmente para que puedas arreglar el resto:

1.  Edita el archivo de repositorios: `nano /etc/pacman.conf`
    
2.  Busca la sección `[archstrike]` y ponle un `#` delante a todas sus líneas.
    
3.  Guarda (`Ctrl+O`) y sal (`Ctrl+X`).
    
4.  Intenta de nuevo: `pacman -Syyu`
    

* * *

Resumen de la situación
-----------------------

Tienes una "tormenta perfecta":

1.  **Repositorios caídos** (`archstrike`).
    
2.  **Incompatibilidad de versiones** entre `pacman` y `pamac`.
    
3.  **Posible daño en el disco** (por eso los errores de "No such file or directory").
    

**¿Qué sale cuando haces `ls /mnt`?** Si no ves carpetas como `home`, `etc` o `usr`, no sigas con los comandos de pacman, porque estarás intentando arreglar el sistema del USB y no el de tu disco duro.

¿Te gustaría que te ayude a intentar reparar el sistema de archivos de `/dev/sda1` con `fsck`?

Has parado esta respuesta

---

You asked:
----------

Has dicho

\[manjaro mnt\]# ls /mnt

@  @cache  @log  ls\_usb

\[manjaro mnt\]# umount /mnt

mount /dev/sda1 /mnt

ls /mnt

@  @cache  @log  ls\_usb

\[manjaro mnt\]# pacman -Syu pacman pamac-gtk

:: Synchronizing package databases...

core is up to date

extra is up to date

multilib is up to date

andontie-aur is up to date

archlinuxgr is up to date

archlinuxcn                                             1342,6 KiB   266 KiB/s 00:05 \[#################################################\] 100%

extra-alucryd is up to date

arcanisrepo is up to date

chaotic-aur                                              646,6 KiB   139 KiB/s 00:05 \[#################################################\] 100%

archstrike is up to date

error: target not found: pamac-gtk

\[manjaro mnt\]# pacman -R libpamac pamac-gtk

pacman -Syu

error: target not found: pamac-gtk

:: Synchronizing package databases...

core is up to date

extra is up to date

multilib is up to date

andontie-aur is up to date

archlinuxgr is up to date

archlinuxcn is up to date

extra-alucryd is up to date

arcanisrepo is up to date

chaotic-aur is up to date

archstrike is up to date

:: Starting full system upgrade...

warning: ttf-meslo-nerd-font-powerlevel10k: local (20230403-2) is newer than chaotic-aur (2.3.3-1.1)

warning: update-grub: local (2:2.12.r292.g73d1c959-1) is newer than chaotic-aur (0.0.1-8.1)

:: Replace vi with extra/ex-vi-compat? \[Y/n\]  

resolving dependencies...

looking for conflicting packages...

error: failed to prepare transaction (could not satisfy dependencies)

:: installing pacman (7.1.0.r9.g54d9411-1) breaks dependency 'libalpm.so=15' required by libpamac

\[manjaro mnt\]# nano /etc/pacman.conf

\[manjaro mnt\]# pacman -Syu

:: Synchronizing package databases...

core is up to date

extra is up to date

multilib is up to date

andontie-aur is up to date

archlinuxgr is up to date

archlinuxcn is up to date

extra-alucryd is up to date

arcanisrepo is up to date

chaotic-aur is up to date

:: Starting full system upgrade...

warning: ttf-meslo-nerd-font-powerlevel10k: local (20230403-2) is newer than chaotic-aur (2.3.3-1.1)

warning: update-grub: local (2:2.12.r292.g73d1c959-1) is newer than chaotic-aur (0.0.1-8.1)

:: Replace vi with extra/ex-vi-compat? \[Y/n\]  

resolving dependencies...

looking for conflicting packages...

error: failed to prepare transaction (could not satisfy dependencies)

:: installing pacman (7.1.0.r9.g54d9411-1) breaks dependency 'libalpm.so=15' required by libpamac

\[manjaro mnt\]# pacman -Syyu

:: Synchronizing package databases...

core                                                     122,3 KiB  77,1 KiB/s 00:02 \[#################################################\] 100%

extra                                                      8,0 MiB   952 KiB/s 00:09 \[#################################################\] 100%

multilib                                                 127,6 KiB  76,9 KiB/s 00:02 \[#################################################\] 100%

andontie-aur                                             140,7 KiB   215 KiB/s 00:01 \[#################################################\] 100%

archlinuxgr                                                9,4 KiB  6,75 KiB/s 00:01 \[#################################################\] 100%

archlinuxcn                                             1342,6 KiB   226 KiB/s 00:06 \[#################################################\] 100%

extra-alucryd                                            231,9 KiB  20,8 KiB/s 00:11 \[#################################################\] 100%

arcanisrepo                                               49,7 KiB  25,5 KiB/s 00:02 \[#################################################\] 100%

chaotic-aur                                              646,6 KiB   138 KiB/s 00:05 \[#################################################\] 100%

:: Starting full system upgrade...

warning: ttf-meslo-nerd-font-powerlevel10k: local (20230403-2) is newer than chaotic-aur (2.3.3-1.1)

warning: update-grub: local (2:2.12.r292.g73d1c959-1) is newer than chaotic-aur (0.0.1-8.1)

:: Replace vi with extra/ex-vi-compat? \[Y/n\]  

resolving dependencies...

looking for conflicting packages...

error: failed to prepare transaction (could not satisfy dependencies)

:: installing pacman (7.1.0.r9.g54d9411-1) breaks dependency 'libalpm.so=15' required by libpamac

\[manjaro mnt\]# fsck

fsck from util-linux 2.41

\[manjaro mnt\]# fsck /dev/sda

fsck from util-linux 2.41

e2fsck 1.47.2 (1-Jan-2025)

/dev/sda is in use.

e2fsck: Cannot continue, aborting.

  

  

\[manjaro mnt\]# fsck /dev/sda1

fsck from util-linux 2.41

If you wish to check the consistency of a BTRFS filesystem or

repair a damaged filesystem, see btrfs(8) subcommand 'check'.

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

¡Buenas noticias! El misterio de por qué no podías entrar con `chroot` está resuelto: estás usando el sistema de archivos **Btrfs**.

En Btrfs, las carpetas reales del sistema están "escondidas" dentro de **subvolúmenes** (por eso al hacer `ls` solo veías `@`, `@cache`, etc.). El sistema real está dentro de `@`.

Vamos a arreglar esto con precisión quirúrgica:

* * *

1\. Montar los subvolúmenes correctamente
-----------------------------------------

Para poder entrar a tu sistema (chroot) y arreglar el error de `pacman`, necesitamos montar el subvolumen `@` (que es tu raíz `/` real):

Bash

    # Desmontamos lo que haya en /mnt
    umount -R /mnt
    
    # Montamos el subvolumen raíz (@) en /mnt
    mount -t btrfs -o subvol,subvol=@ /dev/sda1 /mnt
    
    # Ahora montamos los sistemas necesarios
    mount --bind /dev /mnt/dev
    mount --bind /proc /mnt/proc
    mount --bind /sys /mnt/sys
    mount --bind /run /mnt/run
    
    # ENTRAR AL SISTEMA REAL
    chroot /mnt /bin/bash

2\. Solucionar el "Rompecabezas" de Pacman (libalpm)
----------------------------------------------------

Una vez **dentro del chroot** (verás que el prompt cambia), el sistema cree que está en su entorno normal. Como el error es que `libpamac` bloquea la actualización de `pacman`, la solución más rápida es **eliminar temporalmente pamac**, actualizar, y luego reinstalarlo.

Ejecuta estos comandos **dentro del chroot**:

Bash

    # 1. Eliminar el paquete que causa el conflicto (sin borrar sus datos de configuración)
    pacman -Rdd libpamac pamac-gtk
    
    # 2. Ahora actualiza el sistema completo sin bloqueos
    pacman -Syu
    
    # 3. (Opcional) Reinstala pamac si lo necesitas, ahora ya será compatible
    pacman -S pamac-gtk

3\. ¿Por qué falló el `fsck`?
-----------------------------

Como te indicó el mensaje, Btrfs no se repara con `fsck` tradicional. Si después de actualizar el sistema sigues notando errores de archivos, el comando correcto (desde fuera del chroot) sería: `btrfs check /dev/sda1` _Pero no lo hagas a menos que el sistema siga fallando tras la actualización._

* * *

Resumen de lo que estamos haciendo
----------------------------------

Estamos "saltando" dentro de la subestructura de tu disco para que los comandos afecten a tu instalación de Manjaro y no al USB. El conflicto de `libalpm` es simplemente un desajuste de versiones que se soluciona quitando el mediador (`pamac`) un momento.

**¿Lograste entrar al `chroot` con el primer bloque de comandos?** Si es así, procede con el `pacman -Rdd`.

Has parado esta respuesta

---

You asked:
----------

Has dicho

\[manjaro mnt\]# # Desmontamos lo que haya en /mnt

umount -R /mnt

  

\# Montamos el subvolumen raíz (@) en /mnt

mount -t btrfs -o subvol,subvol=@ /dev/sda1 /mnt

  

\# Ahora montamos los sistemas necesarios

mount --bind /dev /mnt/dev

mount --bind /proc /mnt/proc

mount --bind /sys /mnt/sys

mount --bind /run /mnt/run

  

\# ENTRAR AL SISTEMA REAL

chroot /mnt /bin/bash

umount: /mnt/dev/pts: target is busy.

mount: /mnt: fsconfig() failed: btrfs: Bad value for 'subvol'.

      dmesg(1) may have more information after failed mount system call.

chroot: failed to run command ‘/bin/bash’: No such file or directory

\[manjaro mnt\]# # 1. Eliminar el paquete que causa el conflicto (sin borrar sus datos de configuración)

pacman -Rdd libpamac pamac-gtk

  

\# 2. Ahora actualiza el sistema completo sin bloqueos

pacman -Syu

  

\# 3. (Opcional) Reinstala pamac si lo necesitas, ahora ya será compatible

pacman -S pamac-gtk

error: target not found: pamac-gtk

:: Synchronizing package databases...

core is up to date

extra is up to date

multilib is up to date

andontie-aur is up to date

archlinuxgr is up to date

archlinuxcn is up to date

extra-alucryd is up to date

arcanisrepo is up to date

chaotic-aur is up to date

:: Starting full system upgrade...

warning: ttf-meslo-nerd-font-powerlevel10k: local (20230403-2) is newer than chaotic-aur (2.3.3-1.1)

warning: update-grub: local (2:2.12.r292.g73d1c959-1) is newer than chaotic-aur (0.0.1-8.1)

:: Replace vi with extra/ex-vi-compat? \[Y/n\]  

resolving dependencies...

looking for conflicting packages...

error: failed to prepare transaction (could not satisfy dependencies)

:: installing pacman (7.1.0.r9.g54d9411-1) breaks dependency 'libalpm.so=15' required by libpamac

error: target not found: pamac-gtk

\[manjaro mnt\]# pacman -Rdd

error: no targets specified (use -h for help)

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Estamos tropezando con dos muros: uno técnico con el montaje de **Btrfs** y otro de sintaxis con **pacman**.

El error `Bad value for 'subvol'` ocurrió porque repetí la palabra. Mi error. Además, el sistema te dio error con `pacman -Rdd` porque lo ejecutaste fuera del chroot (sobre el sistema del USB) y ahí no están instalados esos paquetes.

Vamos a hacerlo bien esta vez. Sigue estos pasos exactos:

1\. Corregir el montaje de Btrfs y entrar
-----------------------------------------

Ejecuta estos comandos uno a uno. Si alguno da error, para y dime qué dice:

Bash

    # Limpiamos montajes previos
    umount -l /mnt
    
    # Montamos el subvolumen @ correctamente
    mount -t btrfs -o subvol=@ /dev/sda1 /mnt
    
    # Montamos los sistemas esenciales (sin estos el chroot no funciona)
    mount --bind /dev /mnt/dev
    mount --bind /dev/pts /mnt/dev/pts
    mount --bind /proc /mnt/proc
    mount --bind /sys /mnt/sys
    mount --bind /run /mnt/run
    
    # ENTRAR AL SISTEMA (Si esto funciona, el prompt cambiará)
    chroot /mnt /bin/bash

* * *

2\. Una vez DENTRO del chroot (Paso Crítico)
--------------------------------------------

Si lograste entrar, ahora sí vamos a romper el bloqueo de `pacman`. El comando `-Rdd` sirve para "saltarse" las comprobaciones de dependencia y poder borrar el paquete que estorba.

**Ejecuta esto dentro de la nueva shell:**

Bash

    # Borramos el paquete conflictivo a la fuerza
    pacman -Rdd libpamac
    
    # Ahora actualizamos todo el sistema
    pacman -Syu

* * *

¿Qué pasa si el `chroot` sigue fallando?
----------------------------------------

Si al intentar el `chroot` te sigue diciendo `No such file or directory`, es porque no estamos apuntando al lugar correcto del disco.

Para estar 100% seguros de los subvolúmenes de tu disco, ejecuta esto **fuera del chroot**:

Bash

    btrfs subvolume list /mnt

Esto nos dirá si tu subvolumen principal se llama `@` o tiene otro nombre (como `root` o un ID numérico).

**Prueba el primer bloque de comandos (el de montaje corregido) y dime si el prompt cambia a algo como `[root@manjaro /]#`.**

Has parado esta respuesta

---

You asked:
----------

Has dicho

\[manjaro mnt\]# # Desmontamos lo que haya en /mnt

umount -R /mnt

  

\# Montamos el subvolumen raíz (@) en /mnt

mount -t btrfs -o subvol,subvol=@ /dev/sda1 /mnt

  

\# Ahora montamos los sistemas necesarios

mount --bind /dev /mnt/dev

mount --bind /proc /mnt/proc

mount --bind /sys /mnt/sys

mount --bind /run /mnt/run

  

\# ENTRAR AL SISTEMA REAL

chroot /mnt /bin/bash

umount: /mnt/dev/pts: target is busy.

mount: /mnt: fsconfig() failed: btrfs: Bad value for 'subvol'.

      dmesg(1) may have more information after failed mount system call.

chroot: failed to run command ‘/bin/bash’: No such file or directory

\[manjaro mnt\]# # 1. Eliminar el paquete que causa el conflicto (sin borrar sus datos de configuración)

pacman -Rdd libpamac pamac-gtk

  

\# 2. Ahora actualiza el sistema completo sin bloqueos

pacman -Syu

  

\# 3. (Opcional) Reinstala pamac si lo necesitas, ahora ya será compatible

pacman -S pamac-gtk

error: target not found: pamac-gtk

:: Synchronizing package databases...

core is up to date

extra is up to date

multilib is up to date

andontie-aur is up to date

archlinuxgr is up to date

archlinuxcn is up to date

extra-alucryd is up to date

arcanisrepo is up to date

chaotic-aur is up to date

:: Starting full system upgrade...

warning: ttf-meslo-nerd-font-powerlevel10k: local (20230403-2) is newer than chaotic-aur (2.3.3-1.1)

warning: update-grub: local (2:2.12.r292.g73d1c959-1) is newer than chaotic-aur (0.0.1-8.1)

:: Replace vi with extra/ex-vi-compat? \[Y/n\]  

resolving dependencies...

looking for conflicting packages...

error: failed to prepare transaction (could not satisfy dependencies)

:: installing pacman (7.1.0.r9.g54d9411-1) breaks dependency 'libalpm.so=15' required by libpamac

error: target not found: pamac-gtk

\[manjaro mnt\]# pacman -Rdd

error: no targets specified (use -h for help)

\[manjaro mnt\]# pacman -Rdd

error: no targets specified (use -h for help)

\[manjaro mnt\]# # Limpiamos montajes previos

umount -l /mnt

  

\# Montamos el subvolumen @ correctamente

mount -t btrfs -o subvol=@ /dev/sda1 /mnt

  

\# Montamos los sistemas esenciales (sin estos el chroot no funciona)

mount --bind /dev /mnt/dev

mount --bind /dev/pts /mnt/dev/pts

mount --bind /proc /mnt/proc

mount --bind /sys /mnt/sys

mount --bind /run /mnt/run

  

\# ENTRAR AL SISTEMA (Si esto funciona, el prompt cambiará)

chroot /mnt /bin/bash

chroot: failed to run command ‘/bin/bash’: No such file or directory

\[manjaro mnt\]# # Borramos el paquete conflictivo a la fuerza

pacman -Rdd libpamac

  

\# Ahora actualizamos todo el sistema

pacman -Syu

  

Packages (1) libpamac-11.7.3-5

  

Total Removed Size:  3,77 MiB

  

:: Do you want to remove these packages? \[Y/n\]  

:: Processing package changes...

(1/1) removing libpamac                                                               \[#################################################\] 100%

:: Running post-transaction hooks...

(1/4) Reloading system manager configuration...

(2/4) Arming ConditionNeedsUpdate...

(3/4) Updating the MIME type database...

(4/4) Reloading system bus configuration...

:: Synchronizing package databases...

core is up to date

extra is up to date

multilib is up to date

andontie-aur is up to date

archlinuxgr is up to date

archlinuxcn is up to date

extra-alucryd is up to date

arcanisrepo is up to date

chaotic-aur is up to date

:: Starting full system upgrade...

warning: ttf-meslo-nerd-font-powerlevel10k: local (20230403-2) is newer than chaotic-aur (2.3.3-1.1)

warning: update-grub: local (2:2.12.r292.g73d1c959-1) is newer than chaotic-aur (0.0.1-8.1)

:: Replace vi with extra/ex-vi-compat? \[Y/n\]  

resolving dependencies...

:: There are 4 providers available for libpamac:

:: Repository andontie-aur

  1) libpamac-aur  2) libpamac-full

:: Repository archlinuxcn

  3) libpamac-aur

:: Repository chaotic-aur

  4) pamac

  

Enter a number (default=1):  

looking for conflicting packages...

error: failed to prepare transaction (could not satisfy dependencies)

:: unable to satisfy dependency 'libalpm.so=15' required by libpamac-aur

\[manjaro mnt\]# btrfs subvolume list /mnt

ID 256 gen 410520 top level 5 path @

ID 259 gen 409314 top level 5 path @log

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

¡Estamos progresando! Aunque el `chroot` falló, lograste desinstalar `libpamac` del sistema Live, lo cual despejó el camino para intentar arreglar el sistema real desde "fuera".

El error de `chroot` ocurrió porque `/bin/bash` no se encuentra dentro de `/mnt` tras el montaje. Esto suele pasar si el binario está en `/usr/bin/bash` (común en Arch/Manjaro).

Vamos a forzar la actualización del sistema **apuntando directamente a tu disco duro** sin entrar al chroot, y vamos a ignorar `libpamac` para que no detenga el proceso.

* * *

1\. Preparar el montaje definitivo
----------------------------------

Asegúrate de que el disco esté montado correctamente (usaremos el subvolumen `@` que confirmaste con el comando anterior):

Bash

    umount -l /mnt
    mount -t btrfs -o subvol=@ /dev/sda1 /mnt

2\. Actualizar el disco usando el Pacman del Live USB
-----------------------------------------------------

Como no podemos entrar al `chroot`, usaremos la opción `--sysroot` de pacman para que use los archivos de tu USB pero instale todo en tu disco duro (`/mnt`).

**Ejecuta este comando exacto:**

Bash

    pacman -Syu --sysroot /mnt --ignore libpamac

> **Nota:** Si te pregunta por reemplazar `vi`, di que sí (**Y**). Si vuelve a fallar por `libpamac`, es porque aún queda algún rastro en la base de datos de tu disco.

3\. Si el paso anterior falla por dependencias
----------------------------------------------

Si sigue pidiendo `libalpm.so=15`, vamos a borrar el paquete conflictivo directamente del disco duro (no del USB):

Bash

    pacman -Rdd libpamac --sysroot /mnt

Y luego repite el comando de actualización:

Bash

    pacman -Syu --sysroot /mnt

* * *

¿Qué estamos haciendo?
----------------------

Al usar `--sysroot /mnt`, le decimos a Pacman: _"Usa tu motor y tu internet, pero trata a `/mnt` como si fuera el disco raíz (`/`)"_. Esto evita el problema de que el `chroot` no encuentre a Bash.

**¿Qué error te lanza ahora el comando `pacman -Syu --sysroot /mnt --ignore libpamac`?** Si termina con éxito, ¡tu sistema estará reparado!

Has parado esta respuesta

---

