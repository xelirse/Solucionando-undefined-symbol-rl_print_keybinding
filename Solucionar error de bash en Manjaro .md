You asked:
----------

Has dicho

Tengo este problema. ¿Se puede solucionar?

  

\[manjaro mnt\]# chroot /mnt /usr/bin/bash

/usr/bin/bash: symbol lookup error: /usr/bin/bash: undefined symbol: rl\_print\_keybinding

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

¡Uff! Ese error de `symbol lookup error` es el equivalente informático a intentar abrir una puerta y que la cerradura se deshaga en tus manos.

Lo que está pasando es una **desincronización de bibliotecas**. Específicamente, tu binario de `bash` está intentando llamar a una función (`rl_print_keybinding`) que debería estar en la biblioteca **readline**, pero la versión de `libreadline.so` que encuentra en `/mnt` es más antigua o incompatible con el binario de Bash.

Esto suele ocurrir en Arch/Manjaro tras una actualización interrumpida o si el sistema se quedó a medias entre versiones. **Sí, tiene solución**, pero como no puedes entrar vía `chroot`, tenemos que reparar la "casa" desde afuera.

Aquí tienes los pasos para arreglarlo usando el entorno de tu Live USB:

* * *

1\. Montar las particiones necesarias
-------------------------------------

Asegúrate de tener montada tu partición raíz en `/mnt`. Si tienes una partición separada para `/usr` o `/var`, móntalas también. No olvides los directorios dinámicos del sistema:

Bash

    mount --bind /dev /mnt/dev
    mount --bind /proc /mnt/proc
    mount --bind /sys /mnt/sys
    mount --bind /run /mnt/run

2\. Usar pacman desde el Live USB (La clave)
--------------------------------------------

Como el `bash` de tu sistema instalado está roto, usaremos el `pacman` del USB para reinstalar las bibliotecas básicas en la ruta de tu disco duro. Ejecuta esto:

Bash

    pacman --root /mnt --cachedir /mnt/var/cache/pacman/pkg -S readline bash

*   `--root /mnt`: Le dice a pacman que instale los paquetes en tu sistema dañado, no en el USB.
    
*   Si esto falla por problemas de red o firmas, intenta actualizar la base de datos primero: `pacman --root /mnt -Sy`.
    

3\. Sincronización total (Opcional pero recomendada)
----------------------------------------------------

Si el error persiste o aparecen otros símbolos faltantes, es probable que haya más paquetes desactualizados. Puedes forzar una actualización completa del sistema instalado:

Bash

    pacman --root /mnt -Syu

4\. Verificar y reintentar el chroot
------------------------------------

Una vez que `readline` y `bash` estén reinstalados, intenta entrar de nuevo:

Bash

    chroot /mnt /usr/bin/bash

* * *

**¿Por qué pasó esto?** Generalmente sucede cuando se actualiza `readline` pero no `bash`, o cuando usas `pacman -Sy` (sin la "u") e instalas algo nuevo, provocando una "actualización parcial", que es el pecado capital en distribuciones Rolling Release como Manjaro.

¿Te ha dado algún error específico el comando de `pacman --root` al intentar reinstalar?

Has parado esta respuesta

---

You asked:
----------

Has dicho

\[manjaro mnt\]# chroot /mnt /usr/bin/bash

/usr/bin/bash: symbol lookup error: /usr/bin/bash: undefined symbol: rl\_print\_keybinding

\[manjaro mnt\]# mount --bind /dev /mnt/dev

mount --bind /proc /mnt/proc

mount --bind /sys /mnt/sys

mount --bind /run /mnt/run

\[manjaro mnt\]# pacman --root /mnt --cachedir /mnt/var/cache/pacman/pkg -S readline bash

warning: readline-8.3.003-1 is up to date -- reinstalling

warning: bash-5.3.9-1 is up to date -- reinstalling

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

\[manjaro mnt\]# pacman --root /mnt -Syu

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

there is nothing to do

\[manjaro mnt\]# chroot /mnt /usr/bin/bash

/usr/bin/bash: symbol lookup error: /usr/bin/bash: undefined symbol: rl\_print\_keybinding

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Esto se ha puesto interesante. Lo que estamos viendo es que, aunque `pacman` dice que reinstaló los paquetes, el sistema sigue "viendo" la versión incorrecta de la biblioteca.

El culpable más probable es que tienes **archivos huérfanos o duplicados** en `/usr/lib` que están desviando al sistema, o que la base de datos de `pacman` cree que tiene una versión (la 8.3) pero en el disco físico hay otra.

Aquí tienes el plan de rescate quirúrgico:

* * *

1\. Identificar el mentiroso (Librerías duplicadas)
---------------------------------------------------

A veces, durante una actualización fallida, se quedan archivos con nombres ligeramente distintos o en rutas que no deberían. Desde el Live USB (fuera del chroot), ejecuta esto para ver qué está pasando realmente en tu disco:

Bash

    ls -lh /mnt/usr/lib/libreadline.so*

**Lo que deberías ver:** Solo enlaces simbólicos apuntando a `libreadline.so.8.3`. **Lo que sospecho que verás:** Un caos de archivos `.so.8` y `.so.7` o archivos que no son enlaces simbólicos.

2\. El "Modo Fuerza Bruta" (Reinstalación limpia)
-------------------------------------------------

Como el `post-transaction hook` falló (vimos el error de `ldconfig`), la base de datos de enlaces está corrupta. Vamos a forzar a `pacman` a sobreescribir todo sin preguntar:

Bash

    pacman --root /mnt -S --overwrite '*' readline bash

3\. Arreglar los enlaces simbólicos manualmente
-----------------------------------------------

Ese error de `libssl.so.3 is not a symbolic link` es una señal de alerta roja. Significa que algo reemplazó un enlace por un archivo real o viceversa. Vamos a intentar que el sistema reconstruya su caché de librerías desde fuera:

Bash

    ldconfig -r /mnt

4\. La prueba de fuego (Sin chroot)
-----------------------------------

Antes de intentar el `chroot`, vamos a preguntarle al binario de tu disco qué librerías está intentando cargar y de dónde. Esto nos dirá la verdad:

Bash

    LD_TRACE_LOADED_OBJECTS=1 /mnt/usr/bin/bash

_Mira las líneas que mencionan `libreadline`. Si apuntan a una ruta que no empieza por `/mnt`, ahí está el problema de rutas._

* * *

Si nada de esto funciona: El "Trasplante de Órganos"
----------------------------------------------------

Si sigues bloqueado, es posible que el paquete descargado en el cache esté corrupto. Borra el cache y vuelve a intentar:

1.  `rm /mnt/var/cache/pacman/pkg/readline*`
    
2.  `pacman --root /mnt -Syw readline bash` (Esto solo descarga)
    
3.  `pacman --root /mnt -S readline bash` (Instala lo recién descargado)
    

**¿Qué te devolvió el comando `ls -lh /mnt/usr/lib/libreadline.so*`?** Eso nos dará la pista definitiva de qué archivo está bloqueando la entrada.

Has parado esta respuesta

---

You asked:
----------

Has dicho

\[manjaro mnt\]# ls -lh /mnt/usr/lib/libreadline.so\*

lrwxrwxrwx 1 root root   16 dic 10 22:01 /mnt/usr/lib/libreadline.so -> libreadline.so.8

lrwxrwxrwx 1 root root   18 dic 10 22:01 /mnt/usr/lib/libreadline.so.8 -> libreadline.so.8.3

\-rw-r--r-- 1 root root 351K mar 14 23:07 /mnt/usr/lib/libreadline.so.8.2

\-rwxr-xr-x 1 root root 360K dic 10 22:01 /mnt/usr/lib/libreadline.so.8.3

\[manjaro mnt\]# pacman --root /mnt -S --overwrite '\*' readline bash

warning: readline-8.3.003-1 is up to date -- reinstalling

warning: bash-5.3.9-1 is up to date -- reinstalling

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

\[manjaro mnt\]# ldconfig -r /mnt

ldconfig: /usr/lib/libssl.so.3 is not a symbolic link

  

ldconfig: /usr/lib/libcrypto.so.3 is not a symbolic link

  

\[manjaro mnt\]# LD\_TRACE\_LOADED\_OBJECTS=1 /mnt/usr/bin/bash

       linux-vdso.so.1 (0x00007f9fa1d93000)

       libreadline.so.8 => /usr/lib/libreadline.so.8 (0x00007f9fa1d05000)

       libc.so.6 => /usr/lib/libc.so.6 (0x00007f9fa1b14000)

       libncursesw.so.6 => /usr/lib/libncursesw.so.6 (0x00007f9fa1aa3000)

       /lib64/ld-linux-x86-64.so.2 (0x00007f9fa1d95000)

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

¡Ahí está el impostor! Lo hemos pillado.

Fíjate bien en la salida de tu `ls`:

*   `libreadline.so.8.3` (360K, fecha de diciembre) -> Esta es la correcta.
    
*   `libreadline.so.8.2` (351K, fecha de **ayer 14 de marzo**) -> **Esta no debería estar ahí.**
    

Pero lo más importante es la salida de `LD_TRACE_LOADED_OBJECTS`. Cuando ejecutas el bash de `/mnt`, el sistema está ignorando las librerías de `/mnt` y está cargando las del **Live USB** (`/usr/lib/...` en lugar de `/mnt/usr/lib/...`). Por eso, aunque reinstales en el disco, el binario sigue intentando hablar con la librería "equivocada" del entorno vivo.

Vamos a forzar la mano del sistema. Sigue estos pasos en orden estricto:

1\. Eliminar el archivo sospechoso
----------------------------------

Ese archivo `.8.2` creado ayer está ensuciando el sistema y podría estar causando conflictos si algún enlace apunta a él.

Bash

    rm /mnt/usr/lib/libreadline.so.8.2

2\. Forzar el uso de las librerías de tu disco
----------------------------------------------

Para que `bash` use sus propias librerías (las de `/mnt`) y no las del USB, vamos a usar `LD_LIBRARY_PATH`. Esto debería permitirte entrar al `chroot` aunque el sistema esté "confundido":

Bash

    LD_LIBRARY_PATH=/mnt/usr/lib chroot /mnt /usr/bin/bash

3\. Si logras entrar: Reparación interna
----------------------------------------

Si el comando anterior te permite ver el prompt del chroot (`[root@manjaro /]#`), el hechizo se ha roto. Ahora, dentro del chroot, arregla el desastre de OpenSSL que vimos antes (los errores de `libssl.so.3`):

Bash

    # Ya dentro del chroot
    pacman -S openssl readline bash
    ldconfig

4\. Si NO logras entrar: El plan de emergencia (Symlinks manuales)
------------------------------------------------------------------

Si el paso 2 sigue dando error de símbolo, es que los enlaces simbólicos en `/mnt` están apuntando a donde no deben. Vamos a recrearlos a mano desde fuera:

Bash

    cd /mnt/usr/lib
    ln -sf libreadline.so.8.3 libreadline.so.8
    ln -sf libreadline.so.8.3 libreadline.so

Y muy importante, arregla los de SSL que `ldconfig` marcó como corruptos:

Bash

    # Asegúrate de que los archivos reales existan antes de hacer el link
    # (Usa ls para ver si la versión es 3 o 3.x)
    ln -sf libssl.so.3 /mnt/usr/lib/libssl.so
    ln -sf libcrypto.so.3 /mnt/usr/lib/libcrypto.so

**¿Qué pasa si ejecutas el comando del paso 2 (`LD_LIBRARY_PATH=...`)? ¿Te deja entrar finalmente a la consola?**

Has parado esta respuesta

---

You asked:
----------

Has dicho

Esto no funciona

LD\_LIBRARY\_PATH=/mnt/usr/lib chroot /mnt /usr/bin/bash

  

Pero esto sí.

LD\_LIBRARY\_PATH=/mnt/usr/lib chroot /mnt /usr/bin/zsh

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

¡Victoria parcial! Si `zsh` funciona, significa que el problema es **exclusivo de Bash** (o de cómo Bash interactúa con `readline`) y que el resto de tu sistema base está vivo.

El hecho de que `zsh` entre con `LD_LIBRARY_PATH` confirma que las librerías en `/mnt` están bien, pero los enlaces simbólicos o las rutas internas de Bash están "mareadas".

Aprovechemos que tienes una terminal dentro del sistema (`zsh`) para limpiar el desastre desde dentro. Sigue estos pasos **dentro del chroot de zsh**:

* * *

1\. Entra al chroot con zsh
---------------------------

Bash

    LD_LIBRARY_PATH=/mnt/usr/lib chroot /mnt /usr/bin/zsh

2\. Reparación de enlaces (ldconfig interno)
--------------------------------------------

Una vez dentro, el sistema debe reconocer sus propias librerías sin ayuda externa. Vamos a forzar la reconstrucción de los enlaces simbólicos y la caché de librerías:

Bash

    # Esto corregirá los errores de libssl y libcrypto que vimos antes
    ldconfig

3\. Reinstalar Bash y Readline (Limpieza profunda)
--------------------------------------------------

Como `pacman` falló antes en los "hooks", vamos a hacerlo ahora que estamos "dentro". Esto asegurará que los scripts de post-instalación se ejecuten correctamente:

Bash

    pacman -Syu bash readline openssl --overwrite '*'

_Si te da error de internet, asegúrate de haber copiado el `resolv.conf` antes de entrar al chroot (desde fuera: `cp /etc/resolv.conf /mnt/etc/resolv.conf`)._

4\. La prueba de fuego
----------------------

Sin salir de `zsh`, intenta simplemente ejecutar `bash`:

Bash

    /usr/bin/bash --version

* * *

¿Por qué zsh sí y bash no?
--------------------------

Bash es extremadamente dependiente de la librería `readline` para su línea de comandos (autocompletado, historial). Zsh, aunque puede usarla, suele tener su propio sistema de manejo de línea de comandos (ZLE). El error `rl_print_keybinding` es una función específica de `readline` que el binario de tu `bash` busca y no encuentra porque está cargando una versión incompatible.

**Si el paso 3 (reinstalar) termina sin errores de "symbol lookup", ¡estás fuera de peligro!**

¿Te lanzó algún error el `pacman -Syu` dentro de zsh?

Has parado esta respuesta

---

You asked:
----------

Has dicho

pacman -Syu bash readline openssl --overwrite '\*'                                       root@manjaro

cd /

error: GPGME error: Invalid crypto engine

error: GPGME error: Invalid crypto engine

:: Synchronizing package databases...

core.db failed to download

extra is up to date

multilib is up to date

andontie-aur.db failed to download

error: failed retrieving file 'andontie-aur.db' from aur.andontie.net : Connection timed out after 10000 milli

seconds

error: failed retrieving file 'core.db' from ftp5.gwdg.de : Operation too slow. Less than 1 bytes/sec transfer

red the last 10 seconds

error: failed to synchronize all databases (download library error)

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Ese error de **GPGME** y el fallo de descarga confirman que el entorno `chroot` está "ciego" y con el sistema de firmas roto. Es normal: al entrar con `zsh` forzado por `LD_LIBRARY_PATH`, las variables de entorno no están configuradas y el sistema no sabe cómo validar los paquetes o conectar a la red.

No pierdas tiempo intentando arreglar la red dentro del `chroot` roto. Vamos a hacer la **"operación quirúrgica" definitiva desde fuera**, usando el `pacman` del Live USB pero de una forma más agresiva.

1\. Sal del chroot (importante)
-------------------------------

Escribe `exit` o pulsa `Ctrl+D` hasta volver al prompt del Live USB: `[manjaro mnt]#`.

2\. Preparar el terreno (Red y Firmas)
--------------------------------------

Para que el `pacman` externo pueda instalar cosas dentro de `/mnt`, necesita que el sistema de llaves del USB esté sano y que haya red:

Bash

    # Asegurar red (fuera del chroot)
    cp /etc/resolv.conf /mnt/etc/resolv.conf
    
    # Refrescar llaves del Live USB (por si acaso)
    pacman-key --init
    pacman-key --populate manjaro archlinux

3\. Reinstalación forzada desde fuera (Sin GPGME errors)
--------------------------------------------------------

Vamos a usar el binario de `pacman` del USB para sobreescribir los archivos corruptos en el disco. Usaremos `--dbpath` para asegurarnos de que use la base de datos del sistema instalado:

Bash

    pacman --root /mnt --dbpath /mnt/var/lib/pacman -S --overwrite '*' readline bash openssl

4\. Si el paso anterior sigue fallando por "download error":
------------------------------------------------------------

Es probable que el `pacman.conf` de tu sistema instalado tenga repositorios que ya no existen o están caídos. Usa el `pacman` del Live USB ignorando la configuración de `/mnt`:

Bash

    pacman --root /mnt -S --overwrite '*' readline bash openssl

5\. Arreglar el enlace de OpenSSL (El "Fantasma" de ldconfig)
-------------------------------------------------------------

Vimos antes que `libssl.so.3` no era un link. Vamos a forzarlo manualmente antes de intentar entrar de nuevo:

Bash

    cd /mnt/usr/lib
    # Borramos el archivo que NO es un link
    rm -f libssl.so.3 libcrypto.so.3
    # Creamos los links correctos (ajusta la versión si ves que tienes una más nueva como 3.2 o 3.3)
    ln -s libssl.so.3.x.x libssl.so.3 
    ln -s libcrypto.so.3.x.x libcrypto.so.3
    # (Si no sabes la versión exacta, haz: ls libssl.so.* y usa la que termine en números)

* * *

El plan de escape final
-----------------------

Una vez ejecutado el punto 3 (la reinstalación de `bash` y `readline`), intenta entrar de la forma normal:

Bash

    chroot /mnt /usr/bin/bash

Si el comando del punto 3 te da algún error de **"target not found"** o sigue fallando la descarga, **pásame el contenido de tu `/mnt/etc/pacman.conf`** (solo las primeras líneas de los repositorios) para ver si hay algo mal configurado ahí.

¿Logró terminar la instalación el comando del paso 3?

Has parado esta respuesta

---

You asked:
----------

Has dicho

\[manjaro mnt\]# pacman --root /mnt -S --overwrite '\*' readline bash openssl

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

\[manjaro mnt\]# chroot /mnt /usr/bin/bash

/usr/bin/bash: symbol lookup error: /usr/bin/bash: undefined symbol: rl\_print\_keybinding

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Esto es una pesadilla circular: el `pacman` del Live USB intenta usar el `bash` de tu disco duro para ejecutar los scripts de instalación (hooks), y como ese `bash` sigue roto, la instalación nunca se "completa" realmente.

El problema real es que el sistema está confundido entre las librerías del **Live USB** y las de tu **disco duro**. Cuando ejecutas `pacman --root /mnt`, el entorno de ejecución sigue prefiriendo las rutas del USB.

Vamos a realizar una **limpieza quirúrgica manual** desde el Live USB (fuera del chroot). Si el instalador no puede arreglar los links, los arreglaremos nosotros.

1\. Eliminar el archivo intruso (otra vez)
------------------------------------------

Asegurémonos de que la versión vieja no esté interfiriendo.

Bash

    rm -f /mnt/usr/lib/libreadline.so.8.2

2\. Corregir los Enlaces Simbólicos a mano
------------------------------------------

Vimos que `ldconfig` se queja de que `libssl.so.3` no es un link. Vamos a forzar que todo apunte a la versión más nueva (la que instalamos recién).

Bash

    # Ir a la carpeta de librerías de tu disco
    cd /mnt/usr/lib
    
    # Arreglar Readline
    ln -sf libreadline.so.8.3 libreadline.so.8
    ln -sf libreadline.so.8 libreadline.so
    
    # Arreglar OpenSSL (Busca la versión exacta primero con ls libssl.so*)
    # Asumiendo que es la 3 (según tu log anterior)
    ln -sf libssl.so.3 libssl.so
    ln -sf libcrypto.so.3 libcrypto.so

3\. El truco maestro: El LD\_PRELOAD
------------------------------------

Si `bash` sigue dando el error de símbolo es porque, al intentar ejecutarse, está cargando una `libreadline` del Live USB que no tiene esa función. Vamos a obligarlo a usar la de tu disco duro **incluso antes de que empiece el chroot**:

Bash

    LD_PRELOAD=/mnt/usr/lib/libreadline.so.8.3 chroot /mnt /usr/bin/zsh

4\. Una vez dentro (con zsh)
----------------------------

Si logras entrar con el comando anterior, no intentes usar `pacman` todavía. Vamos a forzar que el sistema se reconozca a sí mismo:

Bash

    # Dentro del chroot
    export LD_LIBRARY_PATH=/usr/lib
    ldconfig
    # Ahora intenta ejecutar bash
    /usr/bin/bash --version

¿Por qué sigue fallando el `pacman --root`?
-------------------------------------------

Porque Manjaro/Arch usa un binario llamado `ldconfig` para gestionar las librerías. Al ejecutar `pacman --root`, el sistema intenta ejecutar el `ldconfig` de tu disco duro, pero ese `ldconfig` depende de `glibc` y otras librerías que podrían estar en conflicto con las del USB.

**Si el paso 3 (LD\_PRELOAD) te da un error de "wrong ELF class" o similar, significa que tu Live USB es de una arquitectura distinta o versión muy dispar, pero siendo Manjaro debería funcionar.**

¿Te permitió el `LD_PRELOAD` entrar finalmente a una consola funcional?

Has parado esta respuesta

---

You asked:
----------

Has dicho

\[manjaro mnt\]# pacman --root /mnt

error: no operation specified (use -h for help)

\[manjaro mnt\]# rm -f /mnt/usr/lib/libreadline.so.8.2

\[manjaro mnt\]# # Ir a la carpeta de librerías de tu disco

cd /mnt/usr/lib

  

\# Arreglar Readline

ln -sf libreadline.so.8.3 libreadline.so.8

ln -sf libreadline.so.8 libreadline.so

  

\# Arreglar OpenSSL (Busca la versión exacta primero con ls libssl.so\*)

\# Asumiendo que es la 3 (según tu log anterior)

ln -sf libssl.so.3 libssl.so

ln -sf libcrypto.so.3 libcrypto.so

\[manjaro lib\]# LD\_PRELOAD=/mnt/usr/lib/libreadline.so.8.3 chroot /mnt /usr/bin/zsh

ERROR: ld.so: object '/mnt/usr/lib/libreadline.so.8.3' from LD\_PRELOAD cannot be preloaded (cannot open shared

object file): ignored.

ERROR: ld.so: object '/mnt/usr/lib/libreadline.so.8.3' from LD\_PRELOAD cannot be preloaded (cannot open shared

object file): ignored.

ERROR: ld.so: object '/mnt/usr/lib/libreadline.so.8.3' from LD\_PRELOAD cannot be preloaded (cannot open shared

object file): ignored.

ERROR: ld.so: object '/mnt/usr/lib/libreadline.so.8.3' from LD\_PRELOAD cannot be preloaded (cannot open shared

object file): ignored.

/ > # Dentro del chroot                                                                          root@manjaro

export LD\_LIBRARY\_PATH=/usr/lib

ldconfig

\# Ahora intenta ejecutar bash

/usr/bin/bash --version

zsh: bad pattern: #

ERROR: ld.so: object '/mnt/usr/lib/libreadline.so.8.3' from LD\_PRELOAD cannot be preloaded (cannot open shared

object file): ignored.

ERROR: ld.so: object '/mnt/usr/lib/libreadline.so.8.3' from LD\_PRELOAD cannot be preloaded (cannot open shared

object file): ignored.

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

¡Tranquilo! Aunque veas esos errores de `LD_PRELOAD`, **estás dentro**. El mensaje de error dice que no puede precargar la librería porque, una vez que entras al `chroot`, la ruta `/mnt/usr/lib...` deja de existir (para el sistema ahora es simplemente `/usr/lib`).

Pero lo importante es que tienes el prompt `/ > #`. **Estamos en zsh dentro de tu sistema dañado.**

Sigue estos pasos exactos para limpiar el desastre de una vez por todas:

1\. Configurar el entorno interno
---------------------------------

Dentro de esa terminal donde estás ahora (el chroot de zsh), ejecuta:

Bash

    unset LD_PRELOAD
    export LD_LIBRARY_PATH=/usr/lib

2\. Arreglar los enlaces internos
---------------------------------

Ahora que el sistema "se ve a sí mismo", vamos a obligar a que se reconozca. Ignora los mensajes de error si aparecen, lo importante es que el comando termine:

Bash

    ldconfig

3\. Reinstalar Bash y Readline correctamente
--------------------------------------------

Ahora que estamos dentro, los "hooks" de pacman deberían funcionar porque estamos usando las rutas reales del sistema. Vamos a forzar la reinstalación:

Bash

    pacman -S bash readline openssl --overwrite '*'

4\. La prueba definitiva
------------------------

Si el comando anterior termina (aunque dé algún aviso), intenta llamar a bash:

Bash

    /usr/bin/bash

* * *

¿Qué pasa si `pacman` vuelve a dar el error de GPGME?
-----------------------------------------------------

Si `pacman` sigue quejándose de "GPGME error" o "Invalid crypto engine" dentro del chroot, es porque el sistema de firmas está bloqueado por la falta de entropía o librerías desincronizadas. En ese caso, haz esto **dentro del chroot**:

1.  **Desactiva temporalmente la verificación de firmas** (solo para esta emergencia): Edita el archivo: `nano /etc/pacman.conf` Busca la línea `SigLevel = Required DatabaseOptional` y cámbiala por `SigLevel = Never`.
    
2.  Ejecuta de nuevo: `pacman -S bash readline openssl --overwrite '*'`
    
3.  **IMPORTANTE**: Una vez que `bash` funcione, vuelve a dejar `pacman.conf` como estaba (`SigLevel = Required DatabaseOptional`).
    

**¿Lograste ejecutar el `pacman -S` dentro del chroot sin que se cortara?** Si llegas a ver que termina de reinstalar Bash, ¡habremos ganado!

Has parado esta respuesta

---

You asked:
----------

Has dicho

Funcionó.

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

¡Qué alivio! Ese error de `symbol lookup` es de los que más dolor de cabeza dan porque rompe la herramienta que necesitas para arreglarlo.

Ahora que ya tienes acceso a **Bash** y el sistema reconoce las funciones de **Readline**, no bajes la guardia todavía. El sistema ha pasado por un "traumatismo" de librerías y es mejor asegurarse de que todo esté en orden antes de reiniciar.

Aquí tienes los últimos pasos para dejar el sistema impecable:

1\. Reconstruir la caché de librerías (LDCONFIG)
------------------------------------------------

Asegúrate de que no queden más advertencias de enlaces simbólicos (como los de OpenSSL):

Bash

    ldconfig

2\. Sincronización final
------------------------

Es vital que el sistema esté completamente actualizado para evitar que otras aplicaciones (como el entorno de escritorio) tengan errores similares:

Bash

    pacman -Syu

3\. Limpiar y Restaurar (Si editaste el conf)
---------------------------------------------

Si cambiaste el `SigLevel` a `Never` en `/etc/pacman.conf`, **devuélvelo ahora a su estado original** (`Required DatabaseOptional`) para que tu sistema siga siendo seguro.

* * *

¿Por qué ocurrió realmente?
---------------------------

El archivo `libreadline.so.8.2` con fecha de ayer era el culpable. Probablemente, una actualización se interrumpió o instalaste un paquete antiguo manualmente que sobreescribió el enlace simbólico, obligando a Bash (que esperaba la versión 8.3) a intentar leer una librería vieja que no tenía la función `rl_print_keybinding`.

**¿Te gustaría que revisemos si el cargador de arranque (GRUB) o el kernel necesitan una actualización antes de que reinicies el equipo?** Solo para estar 100% seguros de que cargará a la primera.

Has parado esta respuesta

---

You asked:
----------

Has dicho

sudo apt autoremove

sudo: unable to allocate pty: No such device

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

¡Vaya puntería! Justo cuando arreglamos un problema de librerías, te encuentras con un error de **comunicación con la terminal**.

El error `sudo: unable to allocate pty: No such device` significa que el sistema no puede crear una "pseudo-terminal" (pty) para ejecutar el comando. Esto suele pasar por dos razones en un entorno de **chroot**:

1.  No se montó el sistema de archivos `/dev/pts`.
    
2.  El kernel del Live USB y el sistema en el disco tienen una discrepancia en cómo manejan las terminales.
    

Como estás en **Manjaro** (que usa `pacman`), el comando `apt autoremove` no funcionará (ese es para Debian/Ubuntu), pero el error del `pty` es lo que realmente nos bloquea.

Cómo solucionarlo (desde fuera del chroot)
------------------------------------------

Sal del chroot (si sigues dentro) con `exit` y ejecuta estos montajes críticos que faltaban:

Bash

    # Asegúrate de que /dev/pts esté montado
    mount --bind /dev/pts /mnt/dev/pts
    
    # También es recomendable montar el sistema de archivos de memoria compartida
    mount --bind /dev/shm /mnt/dev/shm

El equivalente de "autoremove" en Manjaro
-----------------------------------------

Una vez que vuelvas a entrar al chroot (`chroot /mnt /usr/bin/bash`), si lo que quieres es limpiar paquetes huérfanos (los que no son necesarios por ninguna dependencia), el comando correcto en Manjaro es:

Bash

    pacman -Rs $(pacman -Qdtq)

_(Nota: Si no hay paquetes huérfanos, el comando dará un error de "target not found", lo cual es normal)._

* * *

Un consejo final
----------------

Ese error de `pty` a veces ocurre si intentas usar `sudo` dentro de un `chroot`. En un entorno `chroot`, **ya eres root por defecto**, así que no necesitas anteponer `sudo` a los comandos. De hecho, `sudo` suele fallar en chroot si no están todos los sistemas de archivos virtuales montados perfectamente.

**¿Intentaste usar `sudo` por costumbre o realmente necesitas ejecutar algo como otro usuario?** Si ya estás en el prompt `#`, dale directo al comando sin el `sudo`.

Has parado esta respuesta

---

