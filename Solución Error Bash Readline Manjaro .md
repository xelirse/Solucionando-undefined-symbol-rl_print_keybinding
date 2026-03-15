You asked:
----------

Has dicho

Tengo este problema, ¿Se puede solucionar?

  

\[manjaro manjaro\]# sudo manjaro-chroot /mnt

/bin/sh: symbol lookup error: /bin/sh: undefined symbol: rl\_print\_keybinding

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Ese es un error bastante frustrante, pero no te preocupes, tiene solución. Básicamente, lo que está pasando es una **incompatibilidad de versiones** entre la librería `readline` y el binario de `bash` (o `/bin/sh`).

El error `undefined symbol: rl_print_keybinding` indica que el sistema está intentando usar una función de la librería que no existe en la versión que tienes instalada actualmente en la partición que intentas montar. Suele ocurrir tras una actualización interrumpida o un desajuste entre el sistema "vivo" (el USB) y el sistema instalado.

Aquí tienes los pasos para solucionarlo:

* * *

1\. No uses `manjaro-chroot` de entrada
---------------------------------------

Como el entorno de comandos de la partición de destino está "roto", el script automatizado falla. Vamos a hacerlo manualmente para forzar la actualización de las librerías.

2\. Monta tus particiones manualmente
-------------------------------------

Asegúrate de que tu sistema de archivos esté montado en `/mnt`. (Ajusta `sdaX` según sea tu partición raíz):

Bash

    sudo mount /dev/sdaX /mnt
    # Si tienes una partición de arranque separada:
    # sudo mount /dev/sdaY /mnt/boot

3\. Actualiza desde "fuera" usando `pacman`
-------------------------------------------

En lugar de entrar al sistema, usaremos el `pacman` del USB para arreglar el sistema en el disco. Ejecuta este comando:

Bash

    sudo pacman --sysroot /mnt -Syu readline bash

*   **`--sysroot /mnt`**: Le dice a pacman que opere sobre el sistema montado en `/mnt` usando los archivos del USB.
    
*   **`readline bash`**: Reinstala los paquetes críticos que están causando el conflicto de símbolos.
    

4\. Sincroniza y reintenta
--------------------------

Una vez que termine la instalación, intenta entrar de nuevo:

Bash

    sudo manjaro-chroot /mnt

Si logras entrar, te recomiendo ejecutar un `pacman -Syu` completo dentro del chroot para asegurar que no haya otros paquetes a medias.

* * *

¿Qué pasa si sigue fallando?
----------------------------

Si el error persiste, puede que la base de datos de pacman esté bloqueada. Borra el archivo de bloqueo e intenta el paso 3 otra vez:

Bash

    sudo rm /mnt/var/lib/pacman/db.lck

¿Sabes exactamente qué partición es tu raíz (`/`) o necesitas ayuda para identificarla con `lsblk`?

Has parado esta respuesta

---

You asked:
----------

Has dicho

\[manjaro manjaro\]# mount /dev/sda1 /mnt

\[manjaro manjaro\]# mount /dev/sda2 /mnt/boot

mount: /mnt/boot: fsconfig() failed: /dev/sda2: Can't lookup blockdev.

      dmesg(1) may have more information after failed mount system call.

\[manjaro manjaro\]# mount /dev/sda2 /mnt/^Cot

\[manjaro manjaro\]# sudo pacman --sysroot /mnt -Syu readline bash

error: config file /mnt/etc/pacman.conf could not be read: No such file or directory

\[manjaro manjaro\]# cat /mnt/etc/pacman.conf

cat: /mnt/etc/pacman.conf: No such file or directory

\[manjaro manjaro\]# sudo pacman --sysroot /mnt/@ -Syu readline bash

:: Synchronizing package databases...

core is up to date

extra is up to date

multilib is up to date

andontie-aur is up to date

archlinuxgr is up to date

archlinuxcn is up to date

extra-alucryd is up to date

arcanisrepo is up to date

chaotic-aur                           646,5 KiB   263 KiB/s 00:02 \[####################################\] 100%

archstrike is up to date

warning: readline-8.3.003-1 is up to date -- reinstalling

warning: bash-5.3.9-1 is up to date -- reinstalling

:: Starting full system upgrade...

resolving dependencies...

looking for conflicting packages...

  

Packages (2) bash-5.3.9-1  readline-8.3.003-1

  

Total Installed Size:  11,06 MiB

Net Upgrade Size:       0,00 MiB

  

:: Proceed with installation? \[Y/n\]  

(2/2) checking keys in keyring                                     \[####################################\] 100%

(2/2) checking package integrity                                   \[####################################\] 100%

(2/2) loading package files                                        \[####################################\] 100%

(2/2) checking for file conflicts                                  \[####################################\] 100%

(2/2) checking available disk space                                \[####################################\] 100%

:: Processing package changes...

(1/2) reinstalling readline                                        \[####################################\] 100%

(2/2) reinstalling bash                                            \[####################################\] 100%

/usr/bin/bash: symbol lookup error: /usr/bin/bash: undefined symbol: rl\_print\_keybinding

error: command failed to execute correctly

ldconfig: /usr/lib/libssl.so.3 is not a symbolic link

  

ldconfig: /usr/lib/libcrypto.so.3 is not a symbolic link

  

:: Running post-transaction hooks...

(1/2) Arming ConditionNeedsUpdate...

/bin/sh: symbol lookup error: /bin/sh: undefined symbol: rl\_print\_keybinding

error: command failed to execute correctly

(2/2) Updating the info directory file...

/bin/sh: symbol lookup error: /bin/sh: undefined symbol: rl\_print\_keybinding

error: command failed to execute correctly

\[manjaro manjaro\]# sudo manjaro-chroot /mnt/@

/bin/sh: symbol lookup error: /bin/sh: undefined symbol: rl\_print\_keybinding

\[manjaro manjaro\]# lsblk

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

                                /mnt

                                /mnt

                                /mnt

sdb      8:16   1  28,8G  0 disk  

└─sdb1   8:17   1  28,8G  0 part /run/miso/img\_dev

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Esto se está poniendo interesante. El problema es que **Btrfs** está usando subvolúmenes (por eso ves `/mnt/@`) y, al intentar reinstalar, el sistema está mezclando las librerías del USB con las del disco, o simplemente no está sobreescribiendo la que está corrupta correctamente.

Además, los errores de `libssl.so.3` indican que tienes varios paquetes desactualizados o rotos que dependen entre sí.

Para solucionar esto de raíz, vamos a forzar la actualización de **todo el sistema** desde el exterior, pero asegurándonos de que `pacman` use las librerías del USB para trabajar, no las del sistema roto.

1\. Limpia los montajes actuales
--------------------------------

Primero, vamos a desmuntar todo para empezar de cero y evitar conflictos:

Bash

    sudo umount -R /mnt

2\. Monta el subvolumen correcto
--------------------------------

Según tu `lsblk`, tu sistema está en `sda1`. En Manjaro con Btrfs, la raíz suele ser el subvolumen `@`.

Bash

    sudo mount -o subvolumen=@ /dev/sda1 /mnt

3\. La solución "Fuerza Bruta" (Actualización externa total)
------------------------------------------------------------

Como el `bash` de tu disco está roto, no podemos ejecutar los "hooks" (scripts post-instalación). Vamos a intentar actualizar la base del sistema usando el binario de pacman del USB de forma estricta:

Bash

    sudo pacman --sysroot /mnt -Syu readline bash openssl

**Si eso vuelve a dar el error de `symbol lookup error` durante los hooks, haz lo siguiente:**

Vamos a copiar manualmente la librería `libreadline` del USB (que sabemos que funciona) al sistema dañado para "puentear" el error y permitir que los scripts se ejecuten:

Bash

    # Copiamos la librería buena del USB al disco
    sudo cp /usr/lib/libreadline.so.8.2 /mnt/usr/lib/libreadline.so.8
    # (Nota: Verifica la versión exacta en /usr/lib/ si el comando falla por nombre de archivo)

4\. Reparación profunda con pacstrap (Recomendado)
--------------------------------------------------

Si lo anterior falla, usaremos `pacstrap` (una herramienta de instalación de Arch/Manjaro) que es mucho más robusta para estos casos de "rescate":

Bash

    sudo pacstrap /mnt base bash readline openssl

_Esto reinstalará los paquetes base ignorando los scripts rotos del sistema de destino hasta que los archivos físicos estén en su sitio._

* * *

El paso final (Crucial)
-----------------------

Una vez que el comando termine sin errores de "symbol lookup":

1.  Intenta entrar: `sudo manjaro-chroot /mnt /bin/bash`
    
2.  Si entras, ejecuta: `pacman -Syu` para terminar de arreglar el resto del sistema.
    

**¿Te dio algún error específico el comando `pacstrap` o la copia manual de la librería?**

Has parado esta respuesta

---

You asked:
----------

Has dicho

\[manjaro manjaro\]# sudo mount -o subvolumen=@ /dev/sda1 /mnt

mount: /mnt: fsconfig() failed: btrfs: Unknown parameter 'subvolumen'.

      dmesg(1) may have more information after failed mount system call.

\[manjaro manjaro\]# sudo pacman --sysroot /mnt -Syu readline bash openssl

error: config file /mnt/etc/pacman.conf could not be read: No such file or directory

\[manjaro manjaro\]# # Copiamos la librería buena del USB al disco

sudo cp /usr/lib/libreadline.so.8.2 /mnt/usr/lib/libreadline.so.8

\# (Nota: Verifica la versión exacta en /usr/lib/ si el comando falla por nombre de archivo)

cp: cannot stat '/usr/lib/libreadline.so.8.2': No such file or directory

\[manjaro manjaro\]# sudo pacstrap /mnt base bash readline openssl

sudo: pacstrap: command not found

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Parece que tenemos un par de errores de sintaxis y de archivos que están bloqueando el camino, pero los errores de "No such file or directory" nos confirman que **no estamos apuntando a la raíz real** de tu sistema.

Aquí están las correcciones exactas para que los comandos funcionen:

1\. Corregir el comando de montaje (Btrfs)
------------------------------------------

El parámetro correcto es `subvol` (sin la "e" y "n" al final). Además, como tu `lsblk` mostraba muchos `/mnt` repetidos, primero limpia el desorden:

Bash

    sudo umount -R /mnt
    sudo mount -t btrfs -o subvol=@ /dev/sda1 /mnt

_Si esto falla, intenta solo `sudo mount /dev/sda1 /mnt` y verifica si dentro de `/mnt` ves carpetas como `etc`, `usr`, `bin`. Si no las ves, es que están dentro de una carpeta llamada `@`._

2\. Verificar la versión de Readline en el USB
----------------------------------------------

El error del `cp` fue porque la versión en el USB es más nueva (probablemente 8.3). Vamos a buscar el nombre exacto:

Bash

    ls /usr/lib/libreadline.so.*

**Copia el archivo que termine en número (ejemplo `8.3`) hacia el disco dañado:** _(Asumiendo que es 8.3 según tu log anterior)_:

Bash

    sudo cp /usr/lib/libreadline.so.8.3 /mnt/usr/lib/libreadline.so.8

3\. Instalar herramientas de rescate (Pacstrap)
-----------------------------------------------

El USB de Manjaro no siempre trae `pacstrap` por defecto, pero puedes instalarlo en la memoria RAM del USB para usarlo:

Bash

    sudo pacman -Sy arch-install-scripts

Ahora que ya tienes la herramienta, intenta la reparación:

Bash

    sudo pacstrap /mnt base bash readline openssl

4\. El "Plan C" si pacstrap falla
---------------------------------

Si `pacstrap` sigue quejándose, usaremos el `pacman` del USB pero apuntando manualmente al archivo de configuración del USB (ya que el del disco no lo encuentra):

Bash

    sudo pacman --root /mnt --config /etc/pacman.conf -Syu bash readline openssl

* * *

**¿Qué hacer si `ls /usr/lib/libreadline.so.*` te devuelve un número distinto al que puse arriba?** Usa exactamente el número que te salga en la parte de `cp`. Una vez que esa librería esté en `/mnt/usr/lib/libreadline.so.8`, el error de `symbol lookup` debería desaparecer y dejarte entrar con `manjaro-chroot`.

¿Pudiste identificar la versión exacta de la librería con el comando `ls`?

Has parado esta respuesta

---

You asked:
----------

Has dicho

\[manjaro manjaro\]# sudo pacstrap /mnt base bash readline openssl --overwrite="\*"

\==> Creating install root at /mnt

\==> Installing packages to /mnt

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

warning: bash-5.3.9-1 is up to date -- reinstalling

warning: readline-8.3.003-1 is up to date -- reinstalling

warning: openssl-3.6.1-1 is up to date -- reinstalling

resolving dependencies...

:: There are 4 providers available for libxtables.so=12-64:

:: Repository core

  1) iptables  2) iptables-nft

:: Repository archlinuxcn

  3) iptables-fullconenat  4) iptables-fullconenat-nft

  

Enter a number (default=1):  

looking for conflicting packages...

  

Packages (17) iproute2-6.19.0-2  iptables-1:1.8.11-2  iputils-20250605-1  libmnl-1.0.5-2

             libnetfilter\_conntrack-1.0.9-2  libnfnetlink-1.0.2-2  libnftnl-1.3.1-1  libnl-3.12.0-1

             libpcap-1.10.6-1  licenses-20240728-1  pciutils-3.14.0-1  psmisc-23.7-1

             systemd-sysvcompat-259.5-1  base-3-3  bash-5.3.9-1  openssl-3.6.1-1  readline-8.3.003-1

  

Total Installed Size:  34,94 MiB

Net Upgrade Size:      11,94 MiB

  

:: Proceed with installation? \[Y/n\]  

(17/17) checking keys in keyring                                   \[####################################\] 100%

(17/17) checking package integrity                                 \[####################################\] 100%

(17/17) loading package files                                      \[####################################\] 100%

(17/17) checking for file conflicts                                \[####################################\] 100%

(17/17) checking available disk space                              \[####################################\] 100%

:: Processing package changes...

( 1/17) reinstalling readline                                      \[####################################\] 100%

( 2/17) reinstalling bash                                          \[####################################\] 100%

/usr/bin/bash: symbol lookup error: /usr/bin/bash: undefined symbol: rl\_print\_keybinding

error: command failed to execute correctly

( 3/17) reinstalling openssl                                       \[####################################\] 100%

( 4/17) installing pciutils                                        \[####################################\] 100%

Optional dependencies for pciutils

   which: for update-pciids \[installed\]

   grep: for update-pciids \[installed\]

   curl: for update-pciids \[installed\]

( 5/17) installing psmisc                                          \[####################################\] 100%

( 6/17) installing licenses                                        \[####################################\] 100%

( 7/17) installing systemd-sysvcompat                              \[####################################\] 100%

( 8/17) installing iputils                                         \[####################################\] 100%

( 9/17) installing libmnl                                          \[####################################\] 100%

(10/17) installing libnftnl                                        \[####################################\] 100%

(11/17) installing libnl                                           \[####################################\] 100%

(12/17) installing libpcap                                         \[####################################\] 100%

(13/17) installing libnfnetlink                                    \[####################################\] 100%

(14/17) installing libnetfilter\_conntrack                          \[####################################\] 100%

(15/17) installing iptables                                        \[####################################\] 100%

warning: /mnt/etc/ethertypes installed as /mnt/etc/ethertypes.pacnew

(16/17) installing iproute2                                        \[####################################\] 100%

Optional dependencies for iproute2

   db: userspace arp daemon \[installed\]

   linux-atm: ATM support

   python: for routel \[installed\]

(17/17) installing base                                            \[####################################\] 100%

Optional dependencies for base

   linux: bare metal support

ldconfig: /usr/lib/libssl.so.3 is not a symbolic link

  

ldconfig: /usr/lib/libcrypto.so.3 is not a symbolic link

  

:: Running post-transaction hooks...

(1/3) Reloading system manager configuration...

/bin/sh: symbol lookup error: /bin/sh: undefined symbol: rl\_print\_keybinding

error: command failed to execute correctly

(2/3) Arming ConditionNeedsUpdate...

/bin/sh: symbol lookup error: /bin/sh: undefined symbol: rl\_print\_keybinding

error: command failed to execute correctly

(3/3) Updating the info directory file...

/bin/sh: symbol lookup error: /bin/sh: undefined symbol: rl\_print\_keybinding

error: command failed to execute correctly

\[manjaro manjaro\]# sudo pacstrap /mnt base linux-atm --overwrite="\*"

\==> Creating install root at /mnt

\==> Installing packages to /mnt

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

warning: base-3-3 is up to date -- reinstalling

resolving dependencies...

looking for conflicting packages...

  

Packages (2) base-3-3  linux-atm-2.5.2-9

  

Total Download Size:   0,29 MiB

Total Installed Size:  1,17 MiB

  

:: Proceed with installation? \[Y/n\]  

:: Retrieving packages...

linux-atm-2.5.2-9-x86\_64               15,4 KiB  16,7 KiB/s 00:17 \[#-----------------------------------\]   5%

(2/2) checking keys in keyring                                     \[####################################\] 100%

(2/2) checking package integrity                                   \[####################################\] 100%

(2/2) loading package files                                        \[####################################\] 100%

(2/2) checking for file conflicts                                  \[####################################\] 100%

(2/2) checking available disk space                                \[####################################\] 100%

:: Processing package changes...

(1/2) reinstalling base                                            \[####################################\] 100%

(2/2) installing linux-atm                                         \[####################################\] 100%

Optional dependencies for linux-atm

   flex: for atmsigd \[installed\]

ldconfig: /usr/lib/libssl.so.3 is not a symbolic link

  

ldconfig: /usr/lib/libcrypto.so.3 is not a symbolic link

  

:: Running post-transaction hooks...

(1/2) Arming ConditionNeedsUpdate...

/bin/sh: symbol lookup error: /bin/sh: undefined symbol: rl\_print\_keybinding

error: command failed to execute correctly

(2/2) Updating linux initcpios...

bash: symbol lookup error: bash: undefined symbol: rl\_print\_keybinding

error: command failed to execute correctly

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Vaya, este error es persistente. Lo que está pasando es que `pacstrap` instala los archivos nuevos, pero al momento de ejecutar los "scripts" de configuración, intenta usar el `bash` o `sh` que ya están en el sistema montado, y como la librería `readline` está desajustada, fallan.

Tenemos que hacer una **"cirugía manual"** para que el sistema deje de intentar usar la versión rota. Sigue estos pasos exactos:

1\. El truco de la librería (Puentear el error)
-----------------------------------------------

Necesitamos que cualquier programa que busque `rl_print_keybinding` lo encuentre. Vamos a copiar la librería física del USB (que está sana) directamente sobre el archivo que el sistema roto está intentando leer.

Primero, busca el nombre exacto de la librería en tu USB:

Bash

    ls /usr/lib/libreadline.so.8*

_(Supongamos que sale `libreadline.so.8.3`)_. Ahora, fuerza la copia hacia tu disco:

Bash

    sudo cp /usr/lib/libreadline.so.8.* /mnt/usr/lib/libreadline.so.8

2\. Arreglar los enlaces simbólicos de OpenSSL
----------------------------------------------

Vimos en tu log errores sobre `libssl.so.3` no siendo un enlace simbólico. Vamos a arreglar eso manualmente también para evitar más errores de `ldconfig`:

Bash

    sudo rm /mnt/usr/lib/libssl.so.3 /mnt/usr/lib/libcrypto.so.3
    sudo ln -s libssl.so.3.x.x /mnt/usr/lib/libssl.so.3
    sudo ln -s libcrypto.so.3.x.x /mnt/usr/lib/libcrypto.so.3

_(Nota: Usa el tabulador para completar el nombre real de los archivos `.so` que terminen en números más largos en esa carpeta)._

3\. Forzar reinstalación sin ejecutar hooks
-------------------------------------------

Ahora que pusimos el "parche" manual, vamos a usar `pacman` de una forma que solo extraiga los archivos, para asegurar que los binarios en disco sean los correctos antes de intentar entrar:

Bash

    sudo pacman --root /mnt --cachedir /mnt/var/cache/pacman/pkg -S readline bash openssl --overwrite "*"

4\. Prueba de fuego
-------------------

Si los comandos anteriores terminaron sin el error de "symbol lookup", intenta entrar al entorno:

Bash

    sudo manjaro-chroot /mnt /usr/bin/bash

* * *

**Si logras entrar:** El primer comando que debes ejecutar dentro es: `pacman -Syu` Esto terminará de normalizar todo el sistema y regenerar los `initcpios` que fallaron antes.

**¿Te permitió el comando `cp` del paso 1 copiar el archivo o te dio algún error de "Read-only file system"?**

Has parado esta respuesta

---

You asked:
----------

Has dicho

\[manjaro manjaro\]# ls /usr/lib/libreadline.so.8\*

/usr/lib/libreadline.so.8  /usr/lib/libreadline.so.8.3

\[manjaro manjaro\]# sudo cp /usr/lib/libreadline.so.8.\* /mnt/usr/lib/libreadline.so.8

\[manjaro manjaro\]# sudo rm /mnt/usr/lib/libssl.so.3 /mnt/usr/lib/libcrypto.so.3

sudo ln -s libssl.so.3.x.x /mnt/usr/lib/libssl.so.3

sudo ln -s libcrypto.so.3.x.x /mnt/usr/lib/libcrypto.so.3

\[manjaro manjaro\]# sudo pacman --root /mnt --cachedir /mnt/var/cache/pacman/pkg -S readline bash openssl --ove

rwrite "\*"

warning: readline-8.3.003-1 is up to date -- reinstalling

warning: bash-5.3.9-1 is up to date -- reinstalling

warning: openssl-3.6.1-1 is up to date -- reinstalling

resolving dependencies...

looking for conflicting packages...

  

Packages (3) bash-5.3.9-1  openssl-3.6.1-1  readline-8.3.003-1

  

Total Installed Size:  23,00 MiB

Net Upgrade Size:       0,00 MiB

  

:: Proceed with installation? \[Y/n\] ç

\[manjaro manjaro\]# sudo pacman --root /mnt --cachedir /mnt/var/cache/pacman/pkg -S readline bash openssl --ove

rwrite "\*"

warning: readline-8.3.003-1 is up to date -- reinstalling

warning: bash-5.3.9-1 is up to date -- reinstalling

warning: openssl-3.6.1-1 is up to date -- reinstalling

resolving dependencies...

looking for conflicting packages...

  

Packages (3) bash-5.3.9-1  openssl-3.6.1-1  readline-8.3.003-1

  

Total Installed Size:  23,00 MiB

Net Upgrade Size:       0,00 MiB

  

:: Proceed with installation? \[Y/n\]  

(3/3) checking keys in keyring                                     \[####################################\] 100%

(3/3) checking package integrity                                   \[####################################\] 100%

(3/3) loading package files                                        \[####################################\] 100%

(3/3) checking for file conflicts                                  \[####################################\] 100%

(3/3) checking available disk space                                \[####################################\] 100%

:: Processing package changes...

(1/3) reinstalling readline                                        \[####################################\] 100%

(2/3) reinstalling bash                                            \[####################################\] 100%

/usr/bin/bash: symbol lookup error: /usr/bin/bash: undefined symbol: rl\_print\_keybinding

error: command failed to execute correctly

(3/3) reinstalling openssl                                         \[####################################\] 100%

ldconfig: /usr/lib/libssl.so.3 is not a symbolic link

  

ldconfig: /usr/lib/libcrypto.so.3 is not a symbolic link

  

:: Running post-transaction hooks...

(1/2) Arming ConditionNeedsUpdate...

/bin/sh: symbol lookup error: /bin/sh: undefined symbol: rl\_print\_keybinding

error: command failed to execute correctly

(2/2) Updating the info directory file...

/bin/sh: symbol lookup error: /bin/sh: undefined symbol: rl\_print\_keybinding

error: command failed to execute correctly

\[manjaro manjaro\]# sudo manjaro-chroot /mnt /usr/bin/bash

/usr/bin/bash: symbol lookup error: /usr/bin/bash: undefined symbol: rl\_print\_keybinding

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Esto es realmente persistente. El problema es que, aunque copiamos la librería, el comando `pacman --root /mnt` (o los hooks) vuelve a pasar por encima de nuestro "parche" o simplemente el sistema sigue buscando el símbolo en una versión que no corresponde.

Como el `bash` de tu sistema está totalmente roto, vamos a usar una técnica de **"sustitución total"**. Vamos a usar el `bash` del USB (que sabemos que funciona) para entrar al sistema y arreglarlo desde dentro.

1\. Re-aplicar el parche manual (esta vez más agresivo)
-------------------------------------------------------

Vamos a asegurarnos de que la librería esté exactamente donde `bash` la busca y que sea la del USB:

Bash

    # Copiamos la librería 8.3 pero la nombramos exactamente como la que da error
    sudo cp /usr/lib/libreadline.so.8.3 /mnt/usr/lib/libreadline.so.8
    sudo cp /usr/lib/libreadline.so.8.3 /mnt/usr/lib/libreadline.so.8.3

2\. Entrar al chroot usando el Shell del USB
--------------------------------------------

Si el `bash` de `/mnt` no funciona, no podemos usarlo para entrar. Vamos a decirle a `chroot` que use el shell que sí funciona (el del Live USB):

Bash

    # Primero montamos los sistemas de archivos necesarios
    for i in dev proc sys run; do sudo mount --bind /$i /mnt/$i; done
    
    # Intentamos entrar forzando el uso de /bin/sh (que debería usar la lib que copiamos)
    sudo chroot /mnt /bin/sh

3\. Si logras entrar (verás un prompt `#` simple)
-------------------------------------------------

Si logras ver el prompt, significa que el parche manual funcionó temporalmente. Ahora, **dentro del chroot**, vamos a forzar la actualización ignorando los scripts que fallan:

Bash

    # Dentro del chroot:
    export LD_LIBRARY_PATH=/usr/lib
    pacman -Syu --overwrite "*"

4\. ¿Qué pasa si nada de esto funciona? (Plan Final: Reemplazo manual de binarios)
----------------------------------------------------------------------------------

Si sigues recibiendo el error de `symbol lookup error` incluso intentando entrar, es porque el enlace dinámico está roto en el disco. Haz lo siguiente desde **fuera** (en la terminal de Manjaro del USB):

Bash

    # Copiamos el ejecutable de bash y sh directamente del USB al disco
    sudo cp /usr/bin/bash /mnt/usr/bin/bash
    sudo cp /usr/bin/sh /mnt/usr/bin/sh
    # Copiamos TODA la librería readline del USB al disco
    sudo cp /usr/lib/libreadline.so.8* /mnt/usr/lib/

Después de copiar esos archivos manualmente del USB al disco, intenta de nuevo: `sudo manjaro-chroot /mnt`

**¿Lograste entrar con el comando `sudo chroot /mnt /bin/sh` después de copiar las librerías?**

Has parado esta respuesta

---

You asked:
----------

Has dicho

\[manjaro manjaro\]# # Copiamos la librería 8.3 pero la nombramos exactamente como la que da error

sudo cp /usr/lib/libreadline.so.8.3 /mnt/usr/lib/libreadline.so.8

sudo cp /usr/lib/libreadline.so.8.3 /mnt/usr/lib/libreadline.so.8.3

\[manjaro manjaro\]# # Primero montamos los sistemas de archivos necesarios

for i in dev proc sys run; do sudo mount --bind /$i /mnt/$i; done

  

\# Intentamos entrar forzando el uso de /bin/sh (que debería usar la lib que copiamos)

sudo chroot /mnt /bin/sh

/bin/sh: symbol lookup error: /bin/sh: undefined symbol: rl\_print\_keybinding

\[manjaro manjaro\]# # Dentro del chroot:

export LD\_LIBRARY\_PATH=/usr/lib

pacman -Syu --overwrite "\*"

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

\[manjaro manjaro\]# # Copiamos el ejecutable de bash y sh directamente del USB al disco

sudo cp /usr/bin/bash /mnt/usr/bin/bash

sudo cp /usr/bin/sh /mnt/usr/bin/sh

\# Copiamos TODA la librería readline del USB al disco

sudo cp /usr/lib/libreadline.so.8\* /mnt/usr/lib/

\[manjaro manjaro\]# sudo manjaro-chroot /mnt

/bin/sh: symbol lookup error: /bin/sh: undefined symbol: rl\_print\_keybinding

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Esto es realmente inusual. Si ya copiaste físicamente los archivos del USB al disco y el error persiste, significa que el sistema está cargando una librería desde otra ubicación o que hay un desajuste profundo en la caché de librerías (`ld.so.cache`).

Vamos a forzar al sistema a usar la librería "buena" de forma absoluta y a solucionar ese error de `libpamac` que bloquea la actualización.

1\. El último recurso para entrar al Chroot
-------------------------------------------

Vamos a forzar la carga de la librería sana del USB incluso antes de que el binario de `/bin/sh` empiece a ejecutarse. Ejecuta esto desde el USB:

Bash

    # Forzamos la carga de la librería usando LD_PRELOAD
    sudo LD_PRELOAD=/usr/lib/libreadline.so.8.3 chroot /mnt /usr/bin/bash

2\. Si logras entrar: Soluciona el bloqueo de Pacman
----------------------------------------------------

Una vez dentro, el error de `libpamac` ocurre porque Manjaro está intentando actualizar `pacman` a la versión 7, pero las herramientas de Pamac (el gestor gráfico) aún no son compatibles con esa versión específica de la librería `libalpm`.

**La solución es desinstalar temporalmente Pamac para permitir que el sistema se repare:**

Bash

    # Dentro del chroot:
    pacman -Rdd libpamac pamac-cli pamac-gtk (u otros paquetes de pamac que den error)
    pacman -Syu --overwrite "*"

3\. Si sigues sin poder entrar (El "Plan Nuclear")
--------------------------------------------------

Si el error de `symbol lookup` persiste incluso con `LD_PRELOAD`, vamos a limpiar la caché de librerías del sistema dañado desde fuera. Ejecuta esto en la terminal del USB:

Bash

    # Borramos la caché de librerías vieja del disco
    sudo rm /mnt/etc/ld.so.cache
    
    # Regeneramos la caché apuntando al sistema montado
    sudo ldconfig -r /mnt
    
    # Re-intentamos entrar
    sudo manjaro-chroot /mnt

¿Por qué sigue fallando `manjaro-chroot`?
-----------------------------------------

`manjaro-chroot` es un script que automatiza montajes. Si falla, intenta la entrada manual más básica:

Bash

    sudo chroot /mnt /usr/bin/bash --noprofile --norc

**Si logras ver cualquier tipo de prompt (`#` o similar), lo primero es borrar Pamac y actualizar como puse en el paso 2.** ¿Hubo algún cambio con el comando `ldconfig -r`?

* * *

**Siguiente paso:** Si logras entrar, ¿quieres que te ayude a reinstalar `pamac` correctamente una vez que el sistema esté estable?

Has parado esta respuesta

---

You asked:
----------

Has dicho

 root / 

 # Forzamos la carga de la librería usando LD\_PRELOAD

sudo LD\_PRELOAD=/usr/lib/libreadline.so.8.3 chroot /mnt /usr/bin/bash

sudo: unable to allocate pty: No such device

 root / 

 # Dentro del chroot:

pacman -Rdd libpamac pamac-cli pamac-gtk (u otros paquetes de pamac que den error)

pacman -Syu --overwrite "\*"

bash: syntax error near unexpected token \`('

error: GPGME error: Invalid crypto engine

error: GPGME error: Invalid crypto engine

:: Synchronizing package databases...

core is up to date

extra is up to date

multilib is up to date

andontie-aur                          140.7 KiB  85.4 KiB/s 00:02 \[####################################\] 100%

archlinuxgr.db failed to download

archlinuxcn is up to date

extra-alucryd is up to date

arcanisrepo                            49.7 KiB  8.46 KiB/s 00:06 \[####################################\] 100%

chaotic-aur                           646.5 KiB  56.2 KiB/s 00:12 \[####################################\] 100%

archstrike is up to date

error: failed retrieving file 'archlinuxgr.db' from archlinuxgr.tiven.org : Connection timed out after 10000 m

illiseconds

error: failed to synchronize all databases (unexpected error)

 root / 

 # Borramos la caché de librerías vieja del disco

sudo rm /mnt/etc/ld.so.cache

  

\# Regeneramos la caché apuntando al sistema montado

sudo ldconfig -r /mnt

  

\# Re-intentamos entrar

sudo manjaro-chroot /mnt

sudo: unable to allocate pty: No such device

sudo: unable to allocate pty: No such device

sudo: unable to allocate pty: No such device

 root / 

 sudo chroot /mnt /usr/bin/bash --noprofile --norc

sudo: unable to allocate pty: No such device

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

El error `sudo: unable to allocate pty: No such device` suele aparecer cuando los sistemas de archivos virtuales (`/dev`, `/dev/pts`) no están correctamente montados o cuando el entorno "Live" ha perdido el rastro de sus terminales (ptys) debido a tantos intentos de montaje y desmontaje.

Estamos muy cerca, pero el sistema está "bloqueado" por la falta de estos nodos. Vamos a limpiar todo y entrar de una manera más directa.

1\. Limpieza total de montajes
------------------------------

Ejecuta esto para asegurarte de que no haya montajes "fantasma":

Bash

    sudo umount -R /mnt

2\. Montaje manual limpio (Btrfs)
---------------------------------

Montaremos la raíz y los sistemas necesarios sin usar scripts automatizados:

Bash

    sudo mount -t btrfs -o subvol=@ /dev/sda1 /mnt
    for i in dev dev/pts proc sys run; do sudo mount --bind /$i /mnt/$i; done

3\. Entrar SIN `sudo` (Ya eres root en el USB)
----------------------------------------------

Como el prompt indica que ya eres `root` (el símbolo `#` al final), no uses `sudo` para el chroot, ya que `sudo` intenta abrir una terminal (pty) y eso es lo que está fallando:

Bash

    chroot /mnt /usr/bin/bash

* * *

4\. Si logras entrar: Reparar Pacman y GPGME
--------------------------------------------

Si entras, verás que `pacman` da errores de **GPGME**. Esto es común cuando el sistema está muy desactualizado. Sigue estos pasos exactos **dentro** del chroot:

1.  **Quitar el bloqueo de Pamac:**
    
    Bash
    
        pacman -Rdd libpamac pamac-cli pamac-gtk
    
2.  **Reparar las llaves y actualizar el sistema base:** Como tienes problemas de red o de GPG, intentaremos actualizar ignorando las firmas momentáneamente solo para recuperar la base (esto es seguro porque ya descargaste los paquetes antes):
    
    Bash
    
        pacman -Syu --overwrite "*" --noconfirm
    

5\. ¿Y si el error de red `archlinuxgr.db` persiste?
----------------------------------------------------

Ese repositorio (`archlinuxgr`) está caído o tardando demasiado. Edita el archivo de configuración para desactivarlo temporalmente y que `pacman` pueda avanzar:

Bash

    # Dentro o fuera del chroot
    nano /mnt/etc/pacman.conf

Busca la sección `[archlinuxgr]` y ponle una `#` al principio de cada línea para comentarlo. Luego reintenta el `pacman -Syu`.

* * *

**Resumen de la estrategia:** Si el `chroot` normal sigue fallando por el error de `pty`, el problema no es tu disco, es el sistema USB que se ha quedado sin "terminales". Si eso pasa, **reinicia el Live USB**, monta solo con el comando del paso 2 y entra directamente.

¿Te funcionó el `chroot /mnt /usr/bin/bash` sin usar el `sudo` delante?

Has parado esta respuesta

---

You asked:
----------

Has dicho

Nano con el archivo vacío.

  

 root / 

 sudo umount -R /mnt

sudo: unable to allocate pty: No such device

 root / 

 sudo mount -t btrfs -o subvol=@ /dev/sda1 /mnt

for i in dev dev/pts proc sys run; do sudo mount --bind /$i /mnt/$i; done

sudo: unable to allocate pty: No such device

sudo: unable to allocate pty: No such device

sudo: unable to allocate pty: No such device

sudo: unable to allocate pty: No such device

sudo: unable to allocate pty: No such device

sudo: unable to allocate pty: No such device

 root / 

 chroot /mnt /usr/bin/bash

chroot: failed to run command '/usr/bin/bash': No such file or directory

 root / 

 pacman -Rdd libpamac pamac-cli pamac-gtk

error: GPGME error: Invalid crypto engine

error: GPGME error: Invalid crypto engine

error: target not found: libpamac

error: target not found: pamac-cli

error: target not found: pamac-gtk

 root / 

 pacman -Syu --overwrite "\*" --noconfirmç

pacman: unrecognized option '--noconfirmç'

 root / 

 pacman -Syu --overwrite "\*" --noconfirm

pacman: unrecognized option '--noconfirm�'

 root / 

 pacman -Syu --overwrite "\*" --noconfirm  

pacman: unrecognized option '--noconfim'

 root / 

 pacman -Syu --overwrite "\*" --noconfirm

error: GPGME error: Invalid crypto engine

error: GPGME error: Invalid crypto engine

:: Synchronizing package databases...

core is up to date

extra is up to date

multilib is up to date

andontie-aur                          140.7 KiB   107 KiB/s 00:01 \[####################################\] 100%

archlinuxgr is up to date

archlinuxcn                          1342.6 KiB   414 KiB/s 00:03 \[####################################\] 100%

extra-alucryd is up to date

arcanisrepo                            49.7 KiB  27.6 KiB/s 00:02 \[####################################\] 100%

chaotic-aur is up to date

archstrike is up to date

error: GPGME error: Invalid crypto engine

error: GPGME error: Invalid crypto engine

error: failed to synchronize all databases (unexpected error)

 root / 

 # Dentro o fuera del chroot

nano /mnt/etc/pacman.conf

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

El hecho de que `nano /mnt/etc/pacman.conf` esté vacío y el `chroot` diga "No such file or directory" es la señal definitiva: **No estamos montando la partición donde está tu sistema.**

Cuando usas Btrfs con subvolúmenes (común en Manjaro), el sistema no está en la "raíz" del disco `sda1`, sino dentro de una carpeta interna llamada `@`. Si al montar no ves archivos, es que estamos apuntando al lugar equivocado.

Hagamos un reset total para encontrar tus archivos. Sigue estos pasos:

1\. Identifica dónde está el sistema realmente
----------------------------------------------

Ejecuta esto para ver qué hay dentro de `sda1`:

Bash

    sudo mkdir /tmp/check
    sudo mount /dev/sda1 /tmp/check
    ls /tmp/check

*   **Si ves una carpeta llamada `@`**: Tu sistema está ahí.
    
*   **Si ves carpetas como `etc`, `home`, `usr`**: Tu sistema está en la raíz.
    

2\. Montaje correcto y forzado
------------------------------

Vamos a desmontar lo que esté mal y montar bien. Si viste la carpeta `@` en el paso anterior, usa estos comandos:

Bash

    sudo umount -R /mnt
    # Montamos el subvolumen @ en /mnt
    sudo mount -t btrfs -o subvol=@ /dev/sda1 /mnt
    
    # Verificación CRUCIAL: ¿Ves tus archivos ahora?
    ls /mnt/etc/pacman.conf

**Si el comando `ls` anterior NO muestra el archivo, no sigas.** Si lo muestra, continúa con los amarres de sistema:

Bash

    for i in dev dev/pts proc sys run; do sudo mount --bind /$i /mnt/$i; done

3\. Solucionar el error de GPGME (Invalid crypto engine)
--------------------------------------------------------

Este error ocurre porque las librerías de encriptación del USB y del disco están chocando. Como ya eres `root`, no uses `sudo` (para evitar el error de `pty`). Intentaremos reparar las llaves del USB primero para que `pacman` pueda trabajar:

Bash

    # Limpia el llavero del USB
    rm -rf /etc/pacman.d/gnupg
    pacman-key --init
    pacman-key --populate manjaro archlinux

4\. Reparación externa (Sin entrar al chroot)
---------------------------------------------

Ya que el `chroot` te da problemas de símbolos, vamos a usar el `pacman` del USB para inyectar los paquetes necesarios en el disco, apuntando manualmente al archivo de configuración que ahora sí debería existir:

Bash

    pacman --root /mnt --config /mnt/etc/pacman.conf -Syu bash readline openssl --overwrite "*"

* * *

¿Qué hacer si `nano /mnt/etc/pacman.conf` sigue saliendo vacío?
---------------------------------------------------------------

Si sigue vacío tras montar con `subvol=@`, es posible que Manjaro haya usado otro nombre de subvolumen. Ejecuta esto para ver la lista real: `sudo btrfs subvolume list /tmp/check`

Busca el que tenga el nombre del sistema (a veces es `@root` o simplemente un ID).

**¿Qué te salió al hacer el `ls /tmp/check` del paso 1?** Eso nos dirá exactamente dónde está escondido tu Manjaro. Con esa información, el siguiente paso será entrar por fin y borrar `pamac` para desbloquear la actualización.

Has parado esta respuesta

---

You asked:
----------

Has dicho

 root / 

 susudo mkdir /tmp/check

sudo mount /dev/sda1 /tmp/check

ls /tmp/check

sudo: unable to allocate pty: No such device

sudo: unable to allocate pty: No such device

ls: cannot access '/tmp/check': No such file or directory

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

El error `sudo: unable to allocate pty: No such device` junto con el hecho de que no encuentres los directorios que acabas de crear indica que el entorno **Live USB** está colapsando. Esto ocurre porque el sistema de archivos temporal (en RAM) se ha quedado sin "nodos" para abrir terminales o ha tenido un error crítico de montaje.

**No podemos seguir reparando sobre un sistema Live que no puede ejecutar comandos básicos.**

Paso 1: Reinicia el Live USB
----------------------------

Es necesario empezar de cero para limpiar los errores de `pty`. Reinicia el ordenador, arranca desde el USB de Manjaro otra vez y **no toques nada** hasta que veas el escritorio o la terminal.

Paso 2: Identificación Real (Sin scripts automáticos)
-----------------------------------------------------

Una vez reiniciado, abre la terminal y haz exactamente esto (ahora eres `root` por defecto en la terminal de Manjaro, si no, usa `su` una sola vez):

Bash

    # 1. Mira tus particiones
    lsblk -f

Busca `/dev/sda1`. En la columna `FSTYPE` debe decir `btrfs`.

Paso 3: Montaje de rescate "Limpio"
-----------------------------------

Si es Btrfs, vamos a buscar el subvolumen `@`.

Bash

    # Crea el punto de montaje
    mkdir /mnt/manjaro
    
    # Monta la raíz (sda1) en una carpeta temporal para ver qué hay dentro
    mount /dev/sda1 /tmp
    ls /tmp

**Aquí hay dos posibilidades:**

1.  **Ves una carpeta llamada `@`**: Tu sistema está ahí. Ejecuta:
    
    Bash
    
        umount /tmp
        mount -o subvol=@ /dev/sda1 /mnt/manjaro
    
2.  **Ves carpetas como `etc`, `usr`, `bin` directamente**: Tu sistema no usa subvolúmenes. Ejecuta:
    
    Bash
    
        umount /tmp
        mount /dev/sda1 /mnt/manjaro
    

Paso 4: La reparación definitiva
--------------------------------

Una vez montado correctamente (comprueba con `ls /mnt/manjaro/etc/pacman.conf`), usa el pacman del USB para arreglar el disco:

Bash

    # Reparar las librerías críticas de una vez
    pacman --root /mnt/manjaro --config /mnt/manjaro/etc/pacman.conf -S bash readline openssl --overwrite "*"

Paso 5: El problema de Pamac y Pacman 7
---------------------------------------

Cuando intentes lo anterior, te dará el error de `libpamac`. Como todavía no puedes entrar al chroot, vamos a borrar pamac desde fuera:

Bash

    pacman --root /mnt/manjaro --config /mnt/manjaro/etc/pacman.conf -Rdd libpamac pamac-cli pamac-gtk

* * *

**¿Por qué el archivo aparecía vacío antes?** Porque al darte el error de `pty`, el comando `mount` fallaba silenciosamente y estabas intentando leer una carpeta `/mnt` que en realidad estaba vacía.

**¿Qué hacer ahora?** Reinicia el USB y dime qué ves al hacer el `ls /tmp` del **Paso 3**. Eso nos confirmará si el sistema está en `@` o en la raíz.

Has parado esta respuesta

---

