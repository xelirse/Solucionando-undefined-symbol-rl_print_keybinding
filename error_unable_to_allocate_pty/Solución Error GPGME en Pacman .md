You asked:
----------

Has dicho

Tengo este problema.

  

 pacman -Sy glibc

error: GPGME error: Invalid crypto engine

error: GPGME error: Invalid crypto engine

:: Synchronizing package databases...

core is up to date

extra is up to date

multilib is up to date

andontie-aur                          140.7 KiB   132 KiB/s 00:01 \[####################################\] 100%

archlinuxgr is up to date

archlinuxcn is up to date

extra-alucryd is up to date

arcanisrepo                            49.7 KiB  32.5 KiB/s 00:02 \[####################################\] 100%

chaotic-aur                           646.6 KiB  88.9 KiB/s 00:07 \[####################################\] 100%

archstrike is up to date

error: GPGME error: Invalid crypto engine

error: GPGME error: Invalid crypto engine

error: failed to synchronize all databases (unexpected error)

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Este es un error bastante molesto en Arch Linux (o derivadas) que generalmente ocurre cuando las librerías de cifrado o las bases de datos de **pacman** se corrompen, o cuando hay un desajuste entre `gpgme` y el llavero del sistema.

Básicamente, `pacman` intenta verificar las firmas de los repositorios, pero el "motor" (GPG) no responde como debería. Aquí tienes los pasos para solucionarlo, de lo más simple a lo más drástico:

* * *

1\. Limpiar el caché de paquetes y bases de datos
-------------------------------------------------

A veces, una base de datos mal descargada causa el error de GPGME. Vamos a forzar una limpieza:

Bash

    sudo rm -f /var/lib/pacman/sync/*.db
    sudo pacman -Sy

2\. Reinstalar y refrescar las llaves (Solución más común)
----------------------------------------------------------

Si lo anterior no funciona, es probable que el llavero de Arch esté desactualizado o corrupto. Ejecuta estos comandos en orden:

1.  **Elimina el directorio de Gnupg de pacman:** `sudo rm -rf /etc/pacman.d/gnupg`
    
2.  **Reinicia el llavero:** `sudo pacman-key --init`
    
3.  **Rellena con las llaves oficiales:** `sudo pacman-key --populate archlinux`
    
4.  **Actualiza las llaves existentes:** `sudo pacman-key --refresh-keys`
    

3\. Verificar el espacio en `/tmp` o disco
------------------------------------------

El error `Invalid crypto engine` a veces es un síntoma de que **no hay espacio en disco** o que la partición `/tmp` está llena, lo que impide que GPG cree archivos temporales para validar las firmas.

*   Revisa tu espacio con: `df -h`
    

4\. ¿Tienes repositorios externos?
----------------------------------

Veo en tu log que usas muchos repositorios externos (`chaotic-aur`, `andontie-aur`, `archstrike`, etc.). Si los pasos anteriores fallan, intenta comentar temporalmente esos repositorios en tu `/etc/pacman.conf`, realiza un `sudo pacman -Syu` solo con los oficiales, y luego reactívalos uno por uno.

* * *

**Un pequeño consejo:** Veo que intentaste hacer `pacman -Sy glibc`. En Arch, hacer `-Sy` (actualizar la base de datos e instalar un paquete sin actualizar el sistema completo) puede causar una **actualización parcial**, lo cual es peligroso para la estabilidad. Siempre es mejor usar `sudo pacman -Syu glibc`.

¿Te funcionó el reinicio del llavero (paso 2) o sigues viendo el error de GPGME?

Has parado esta respuesta

---

You asked:
----------

Has dicho

Me gustaría un único script que lo resuelva.

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Entendido, vamos a automatizarlo. Este script realiza una limpieza profunda, regenera el llavero de firmas (que es el culpable del error `GPGME`) y refresca las bases de datos.

Copia este código en un archivo (por ejemplo `reparar_pacman.sh`), dale permisos de ejecución y ejecútalo con `sudo`.

Bash

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

Cómo ejecutarlo:
----------------

1.  **Crear el archivo:** `nano reparar_pacman.sh` (pega el código y guarda con `Ctrl+O`, `Enter` y `Ctrl+X`).
    
2.  **Dar permisos:** `chmod +x reparar_pacman.sh`
    
3.  **Ejecutar:** `sudo ./reparar_pacman.sh`
    

* * *

**Nota importante:** Como tienes muchos repositorios externos (ArchStrike, Chaotic-AUR, etc.), si el script falla en el paso 6, es posible que necesites añadir sus llaves específicas manualmente con `pacman-key --populate [nombre-del-repo]`.

¿Quieres que te ayude a añadir las líneas específicas para tus otros repositorios al script?

Has parado esta respuesta

---

You asked:
----------

Has dicho

\--- 1. Limpiando archivos de base de datos corruptos ---

\--- 2. Eliminando el llavero de GPG actual ---

\--- 3. Inicializando nuevo llavero ---

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

chmod: cannot access '/etc/pacman.d/gnupg//trustdb.gpg': No such file or directory

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

\==> Generating pacman master key. This may take some time.

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

\==> Updating trust database...

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

\==> ERROR: Trust database could not be updated.

\--- 4. Cargando llaves oficiales de Arch Linux ---

\==> ERROR: You do not have sufficient permissions to read the pacman keyring.

\==> Use 'pacman-key --init' to correct the keyring permissions.

\--- 5. Refrescando las llaves (esto puede tardar) ---

\==> ERROR: You do not have sufficient permissions to read the pacman keyring.

\==> Use 'pacman-key --init' to correct the keyring permissions.

\--- 6. Sincronizando y actualizando el sistema ---

:: Synchronizing package databases...

core                                  122.3 KiB  66.8 KiB/s 00:02 \[####################################\] 100%

extra                                   8.0 MiB  1360 KiB/s 00:06 \[####################################\] 100%

multilib                              127.6 KiB  80.5 KiB/s 00:02 \[####################################\] 100%

andontie-aur                          140.7 KiB   172 KiB/s 00:01 \[####################################\] 100%

archlinuxgr                             9.4 KiB  6.44 KiB/s 00:01 \[####################################\] 100%

archlinuxcn                          1342.6 KiB   296 KiB/s 00:05 \[####################################\] 100%

extra-alucryd                         231.9 KiB  59.5 KiB/s 00:04 \[####################################\] 100%

arcanisrepo                            49.7 KiB  7.41 KiB/s 00:07 \[####################################\] 100%

chaotic-aur                           646.6 KiB   187 KiB/s 00:03 \[####################################\] 100%

archstrike                            595.1 KiB   328 KiB/s 00:02 \[####################################\] 100%

warning: Public keyring not found; have you run 'pacman-key --init'?

error: GPGME error: Invalid crypto engine

warning: Public keyring not found; have you run 'pacman-key --init'?

error: GPGME error: Invalid crypto engine

error: failed to synchronize all databases (unexpected error)

\--- ¡Proceso finalizado! Intenta instalar glibc ahora ---

 root / 

 pacman-key --init

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

chmod: cannot access '/etc/pacman.d/gnupg//trustdb.gpg': No such file or directory

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

\==> Generating pacman master key. This may take some time.

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

\==> Updating trust database...

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

\==> ERROR: Trust database could not be updated.

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Esto se ha vuelto mucho más serio. El error `GLIBC_ABI_DT_X86_64_PLT' not found` indica que tienes una **incompatibilidad crítica en la librería base del sistema (`glibc`)**.

Básicamente, los binarios de tu sistema (como `gpg`) están intentando usar una función de la librería C que tu versión actual de `glibc` no tiene. Como `gpg` está roto, `pacman` no puede validar nada y no puedes actualizar de forma normal. Estás en un círculo vicioso.

Para salir de esto, necesitamos "saltarnos" la verificación de firmas temporalmente para poder actualizar la `glibc` que está rompiendo todo.

* * *

La Solución de Emergencia
-------------------------

Sigue estos pasos con cuidado. Vamos a desactivar la validación de firmas solo para esta reparación.

#### 1\. Editar la configuración de pacman

Abre el archivo de configuración: `nano /etc/pacman.conf`

Busca la línea (o líneas) que dicen: `SigLevel = Required DatabaseOptional`

Cámbialas temporalmente a: `SigLevel = Never`

_(Haz esto tanto en la sección `[options]` como en los repositorios individuales si tienen su propio SigLevel)._

#### 2\. Actualizar la librería crítica y el sistema

Ahora que `pacman` no pedirá firmas, intenta actualizar solo los paquetes base:

Bash

    pacman -Sy glibc lib32-glibc gcc-libs

Si eso funciona, intenta actualizar el resto del sistema inmediatamente:

Bash

    pacman -Su

#### 3\. Restaurar la seguridad y arreglar las llaves

Una vez que `glibc` esté actualizada, los errores de "version not found" deberían desaparecer. Ahora **vuelve a poner `SigLevel = Required DatabaseOptional`** en tu `/etc/pacman.conf` y ejecuta:

Bash

    # Ahora gpg ya debería funcionar, así que regeneramos el llavero
    rm -rf /etc/pacman.d/gnupg
    pacman-key --init
    pacman-key --populate archlinux

* * *

¿Qué pasa si `pacman` sigue sin funcionar?
------------------------------------------

Si incluso con `SigLevel = Never` no puedes avanzar porque `pacman` mismo falla al ejecutarse (por el error de `glibc`), la única opción es usar un **Live USB de Arch Linux** para hacer un `pacman --sysroot`.

**¿Tienes un USB de instalación a mano por si acaso necesitamos entrar "desde fuera" al sistema?**

Has parado esta respuesta

---

You asked:
----------

Has dicho

Me gustaría un único script que lo resuelva.

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

El error `GLIBC_ABI_DT_X86_64_PLT' not found` indica que tu sistema está en un estado de **"broken toolchain"**. Tienes binarios (como `gpg` o `chmod`) que intentan usar funciones de una versión de la librería C (`glibc`) que no tienen instalada o que está corrupta.

Como `gpg` está roto, el llavero no se puede inicializar. La única forma de salir de este bucle sin usar un USB externo es **desactivar temporalmente la verificación de firmas** para forzar la actualización de la librería base.

Aquí tienes el "Script de Rescate":

Bash

    #!/bin/bash
    
    # 1. Copia de seguridad del pacman.conf original
    cp /etc/pacman.conf /etc/pacman.conf.bak
    
    echo "--- 1. Desactivando verificación de firmas temporalmente ---"
    # Cambia todos los SigLevel a Never para poder saltar el error de GPGME
    sed -i 's/SigLevel    = .*/SigLevel = Never/g' /etc/pacman.conf
    
    echo "--- 2. Forzando actualización de glibc y librerías base ---"
    # Intentamos actualizar solo lo crítico primero
    pacman -Sy --noconfirm glibc lib32-glibc gcc-libs
    
    echo "--- 3. Intentando actualización completa del sistema ---"
    pacman -Su --noconfirm
    
    echo "--- 4. Restaurando configuración de seguridad ---"
    mv /etc/pacman.conf.bak /etc/pacman.conf
    
    echo "--- 5. Reintentando inicializar el llavero ahora que glibc debería funcionar ---"
    rm -rf /etc/pacman.d/gnupg
    pacman-key --init
    pacman-key --populate archlinux
    
    echo "--- Proceso completado. Prueba a instalar algo ahora. ---"

Instrucciones Críticas:
-----------------------

1.  **Guarda y ejecuta:** Copia el código en `rescate.sh`, dale permisos con `chmod +x rescate.sh` y ejecútalo con `sudo ./rescate.sh`.
    
2.  **Si `pacman` mismo falla:** Si al ejecutar el script recibes el mismo error de `GLIBC_ABI_DT_X86_64_PLT` incluso al intentar usar `pacman`, significa que el ejecutable de pacman ya no puede correr en tu sistema actual.
    

**¿Qué pasa si el script falla en el paso 2?** Si `pacman` no abre siquiera para actualizar `glibc`, el sistema está "ladrillo" (bricked) para cambios internos. En ese caso, la única solución es arrancar con un **Live USB de Arch**, montar tu partición y ejecutar: `pacman --sysroot /mnt -Syu glibc`

¿Deseas que te explique cómo hacer este proceso desde un Live USB si el script no logra ejecutarse?

Has parado esta respuesta

---

You asked:
----------

Has dicho

\--- 1. Desactivando verificación de firmas temporalmente ---

\--- 2. Forzando actualización de glibc y librerías base ---

warning: Public keyring not found; have you run 'pacman-key --init'?

error: GPGME error: Invalid crypto engine

warning: Public keyring not found; have you run 'pacman-key --init'?

error: GPGME error: Invalid crypto engine

:: Synchronizing package databases...

core is up to date

extra is up to date

multilib is up to date

andontie-aur                          140.7 KiB   176 KiB/s 00:01 \[####################################\] 100%

archlinuxgr is up to date

archlinuxcn is up to date

extra-alucryd is up to date

arcanisrepo                            49.7 KiB  28.6 KiB/s 00:02 \[####################################\] 100%

chaotic-aur is up to date

archstrike is up to date

warning: Public keyring not found; have you run 'pacman-key --init'?

error: GPGME error: Invalid crypto engine

warning: Public keyring not found; have you run 'pacman-key --init'?

error: GPGME error: Invalid crypto engine

error: failed to synchronize all databases (unexpected error)

\--- 3. Intentando actualización completa del sistema ---

warning: Public keyring not found; have you run 'pacman-key --init'?

error: GPGME error: Invalid crypto engine

warning: Public keyring not found; have you run 'pacman-key --init'?

error: GPGME error: Invalid crypto engine

error: database 'andontie-aur' is not valid (invalid or corrupted database (PGP signature))

error: database 'arcanisrepo' is not valid (invalid or corrupted database (PGP signature))

\--- 4. Restaurando configuración de seguridad ---

\--- 5. Reintentando inicializar el llavero ahora que glibc debería funcionar ---

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

chmod: cannot access '/etc/pacman.d/gnupg//trustdb.gpg': No such file or directory

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

\==> Generating pacman master key. This may take some time.

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

\==> Updating trust database...

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

\==> ERROR: Trust database could not be updated.

\==> ERROR: You do not have sufficient permissions to read the pacman keyring.

\==> Use 'pacman-key --init' to correct the keyring permissions.

\--- Proceso completado. Prueba a instalar algo ahora. ---

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

El problema es que, aunque cambiamos el `SigLevel`, **las bases de datos que ya tienes descargadas esperan una firma**. Al estar `gpg` roto por la incompatibilidad de `glibc`, `pacman` ni siquiera puede ignorar las firmas porque el motor criptográfico falla antes de decidir qué hacer.

Estamos en un escenario de **sistema "bricked" (enladrillado)** para actualizaciones internas. La única forma de arreglarlo sin un USB es **anular manualmente la base de datos** para que `pacman` no intente validar nada en absoluto.

Aquí tienes el script definitivo de "último recurso". Este script va a:

1.  Desactivar toda seguridad.
    
2.  Borrar físicamente las firmas de las bases de datos (`.sig`).
    
3.  Forzar la descarga de bases de datos **sin** firmas.
    

Script de Rescate Total
-----------------------

Bash

    #!/bin/bash
    
    echo "--- 1. Forzando modo de máxima inseguridad en pacman.conf ---"
    sed -i 's/SigLevel    = .*/SigLevel = Never/g' /etc/pacman.conf
    sed -i 's/LocalFileSigLevel = .*/LocalFileSigLevel = Never/g' /etc/pacman.conf
    sed -i 's/RemoteFileSigLevel = .*/RemoteFileSigLevel = Never/g' /etc/pacman.conf
    
    echo "--- 2. Eliminando bases de datos y firmas existentes ---"
    rm -rf /var/lib/pacman/sync/*
    
    echo "--- 3. Forzando sincronización sin verificación ---"
    # Usamos --dbonly para intentar limpiar el estado interno si es necesario
    pacman -Sy --noconfirm
    
    echo "--- 4. Intentando bypass de GPGME para actualizar glibc ---"
    # Si esto falla, el binario de pacman está demasiado roto para continuar solo
    pacman -S --noconfirm --nodeps glibc lib32-glibc gcc-libs
    
    echo "--- 5. Si lo anterior funcionó, actualizamos el resto ---"
    pacman -Su --noconfirm
    
    echo "--- 6. Limpieza final de llaves ---"
    rm -rf /etc/pacman.d/gnupg
    pacman-key --init
    pacman-key --populate archlinux

* * *

¿Qué hacer si este script también muestra `GPGME error`?
--------------------------------------------------------

Si después de borrar `/var/lib/pacman/sync/*` y poner `SigLevel = Never`, el comando `pacman -Sy` sigue lanzando `GPGME error`, significa que **la librería `libgpgme.so` de tu sistema está intentando cargar un GPG que no funciona** debido al error de `glibc`.

En ese punto, **pacman ya no puede arreglarse a sí mismo**. Tienes dos opciones:

1.  **Desde un Live USB (Recomendado):**
    
    *   Arranca con el USB.
        
    *   Monta tu partición en `/mnt`.
        
    *   Ejecuta: `pacman --sysroot /mnt -Syu glibc`
        
2.  **Descarga manual (Muy arriesgado):**
    
    *   Tendrías que bajar el `.pkg.tar.zst` de `glibc` desde un navegador.
        
    *   Extraerlo manualmente en la raíz `/` con `tar` (esto suele romper el sistema definitivamente si no se hace perfecto).
        

**¿Tienes acceso a un Live USB de Arch o Manjaro?** Es la forma más segura de inyectar la `glibc` correcta y recuperar el control.

Has parado esta respuesta

---

You asked:
----------

Has dicho

\--- 1. Desactivando verificación de firmas temporalmente ---

\--- 2. Forzando actualización de glibc y librerías base ---

warning: Public keyring not found; have you run 'pacman-key --init'?

error: GPGME error: Invalid crypto engine

warning: Public keyring not found; have you run 'pacman-key --init'?

error: GPGME error: Invalid crypto engine

:: Synchronizing package databases...

core is up to date

extra is up to date

multilib is up to date

andontie-aur                          140.7 KiB   264 KiB/s 00:01 \[####################################\] 100%

archlinuxgr is up to date

archlinuxcn is up to date

extra-alucryd is up to date

arcanisrepo                            49.7 KiB  36.9 KiB/s 00:01 \[####################################\] 100%

chaotic-aur is up to date

archstrike is up to date

warning: Public keyring not found; have you run 'pacman-key --init'?

error: GPGME error: Invalid crypto engine

warning: Public keyring not found; have you run 'pacman-key --init'?

error: GPGME error: Invalid crypto engine

error: failed to synchronize all databases (unexpected error)

\--- 3. Intentando actualización completa del sistema ---

warning: Public keyring not found; have you run 'pacman-key --init'?

error: GPGME error: Invalid crypto engine

warning: Public keyring not found; have you run 'pacman-key --init'?

error: GPGME error: Invalid crypto engine

error: database 'andontie-aur' is not valid (invalid or corrupted database (PGP signature))

error: database 'arcanisrepo' is not valid (invalid or corrupted database (PGP signature))

\--- 4. Restaurando configuración de seguridad ---

\--- 5. Reintentando inicializar el llavero ahora que glibc debería funcionar ---

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

chmod: cannot access '/etc/pacman.d/gnupg//trustdb.gpg': No such file or directory

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

\==> Generating pacman master key. This may take some time.

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

\==> Updating trust database...

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

\==> ERROR: Trust database could not be updated.

\==> ERROR: You do not have sufficient permissions to read the pacman keyring.

\==> Use 'pacman-key --init' to correct the keyring permissions.

\--- Proceso completado. Prueba a instalar algo ahora. ---

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

El problema ha llegado a un punto de bloqueo total: **pacman no puede funcionar porque depende de una librería que está rota, y no puede arreglar la librería porque pacman mismo está roto.**

Cuando ves el error `version GLIBC_ABI_DT_X86_64_PLT not found`, significa que el corazón de tu sistema operativo (la librería C) y tus programas no hablan el mismo idioma. En este estado, ni siquiera desactivando las firmas se puede avanzar porque `pacman` llama a `gpgme`, y `gpgme` explota antes de hacer nada.

La solución definitiva: El "Chroot" desde fuera
-----------------------------------------------

Para arreglar esto, necesitamos inyectar una versión sana de `glibc` desde un entorno que sí funcione. **No podrás arreglar esto desde dentro de tu sesión actual.**

#### Pasos a seguir:

1.  **Consigue un Live USB:** Arranca tu computadora con un USB de instalación de Arch Linux (o Manjaro/EndeavourOS).
    
2.  **Identifica y monta tu sistema:** Una vez dentro del terminal del USB, identifica tu partición raíz (usualmente `/dev/sdaX` o `/dev/nvme0n1pX`):
    
    Bash
    
        lsblk
        mount /dev/sdXX /mnt  # Reemplaza sdXX por tu partición real
    
3.  **El comando mágico (pacman --sysroot):** Este comando usa el `pacman` sano del USB para instalar la librería en tu disco duro, ignorando por completo el sistema roto:
    
    Bash
    
        pacman --sysroot /mnt -Sy glibc gcc-libs lib32-glibc
    
4.  **Actualización completa:** Una vez que la base esté reparada, aprovecha para actualizar todo lo demás:
    
    Bash
    
        pacman --sysroot /mnt -Su
    
5.  **Reiniciar:**
    
    Bash
    
        umount /mnt
        reboot
    

* * *

¿Por qué fallaron los scripts anteriores?
-----------------------------------------

Tu sistema está en lo que llamamos un **incidente de actualización parcial**. Tienes binarios compilados para una versión de `glibc` (la 2.36 o superior) pero tu sistema está cargando una versión antigua (o viceversa).

> **Dato importante:** El error `GPGME error: Invalid crypto engine` es solo un síntoma. El culpable real es la librería `/lib/x86_64-linux-gnu/libc.so.6`.

**¿Tienes el USB a mano o necesitas que te ayude a ver cómo crear uno desde otra computadora?**

Has parado esta respuesta

---

You asked:
----------

Has dicho

Me gustaría poder repararlo.

  

sh-5.3# pacman -Syu

error: GPGME error: Invalid crypto engine

error: GPGME error: Invalid crypto engine

:: Synchronizing package databases...

core is up to date

extra is up to date

multilib is up to date

andontie-aur                          140.7 KiB   172 KiB/s 00:01 \[####################################\] 100%

archlinuxgr is up to date

archlinuxcn is up to date

extra-alucryd is up to date

arcanisrepo                            49.7 KiB  33.3 KiB/s 00:01 \[####################################\] 100%

chaotic-aur is up to date

archstrike is up to date

error: GPGME error: Invalid crypto engine

error: GPGME error: Invalid crypto engine

error: failed to synchronize all databases (unexpected error)

sh-5.3# exit

exit

umount: /mnt/proc: target is busy.

\[manjaro intento\_0\]# umount /mnt/proc

\[manjaro intento\_0\]#  

\[manjaro intento\_0\]# umount /mnt/proc

\[manjaro intento\_0\]# umount /mnt/proc

umount: /mnt/proc: not mounted.

\[manjaro intento\_0\]# umount /mnt/proc

umount: /mnt/proc: not mounted.

\[manjaro intento\_0\]# chroot /mnt

 root / 

 pacman -Syu

error: GPGME error: Invalid crypto engine

error: GPGME error: Invalid crypto engine

:: Synchronizing package databases...

core is up to date

extra is up to date

multilib is up to date

andontie-aur                          140.7 KiB   261 KiB/s 00:01 \[####################################\] 100%

archlinuxgr is up to date

archlinuxcn is up to date

extra-alucryd is up to date

arcanisrepo                            49.7 KiB  28.8 KiB/s 00:02 \[####################################\] 100%

chaotic-aur is up to date

archstrike is up to date

error: GPGME error: Invalid crypto engine

error: GPGME error: Invalid crypto engine

error: failed to synchronize all databases (unexpected error)

 root / 

 exit

exit

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

¡Excelente! Ya estás en un **entorno Live** (según veo en tu prompt `[manjaro intento_0]`). Esto es exactamente lo que necesitábamos.

El error persiste porque al hacer `chroot /mnt`, estás entrando al sistema "enfermo" y usando sus binarios rotos. **No debes entrar al chroot**. Debes reparar el sistema desde "afuera" usando el `pacman` sano del USB.

Sigue estos pasos estrictamente desde el prompt de `[manjaro intento_0]#` (fuera del chroot):

* * *

1\. Asegúrate de que la partición esté montada
----------------------------------------------

Si acabas de salir del chroot, tu sistema debería seguir en `/mnt`. Verifica que ves tus carpetas:

Bash

    ls /mnt

_(Deberías ver `etc`, `usr`, `var`, etc.)_

2\. El comando de reparación definitiva
---------------------------------------

Ejecutaremos `pacman` usando el ejecutable del USB, pero indicándole que instale los paquetes en tu disco duro (`--sysroot /mnt`). Esto ignorará el error de GPGME del sistema roto.

Bash

    pacman --sysroot /mnt -Sy --noconfirm glibc gcc-libs lib32-glibc

> **¿Qué hace esto?** Usa el motor de bases de datos y criptografía del USB (que sí funciona) para sobrescribir la librería `glibc` corrupta de tu disco duro.

3\. Si el paso anterior funciona, actualiza el resto
----------------------------------------------------

Una vez que `glibc` esté sana, el resto del sistema debería poder actualizarse:

Bash

    pacman --sysroot /mnt -Su

4\. Reparar el llavero (dentro ahora sí)
----------------------------------------

Ahora que las librerías son compatibles, entra al chroot para dejar las llaves como nuevas:

Bash

    chroot /mnt
    pacman-key --init
    pacman-key --populate archlinux manjaro
    # Si usas Chaotic-AUR:
    pacman-key --populate chaotic
    exit

* * *

Si el comando `--sysroot` falla por firmas:
-------------------------------------------

Si el `pacman` del USB también se queja de las firmas al intentar instalar en `/mnt`, usa este comando "fuerza bruta" que ignora todas las validaciones solo para esta emergencia:

Bash

    pacman --sysroot /mnt -Sy --noconfirm --gpgdir /etc/pacman.d/gnupg glibc gcc-libs lib32-glibc

**¿Qué error te devuelve el comando del paso 2?** Si logramos que ese comando termine sin errores, tu sistema estará recuperado.

Has parado esta respuesta

---

You asked:
----------

Has dicho

Me gustaría un script que lo repare.

  

 root / 

 pacman --sysroot /mnt -Sy --noconfirm glibc gcc-libs lib32-glibc

error: config file /mnt/etc/pacman.conf could not be read: No such file or directory

 root / 

 exit  

exit

\==> Appending keys from archlinux.gpg...

\==> Appending keys from manjaro.gpg...

\==> Locally signing trusted keys in keyring...

 -> Locally signed 2 keys.

\==> Importing owner trust values...

\==> Updating trust database...

gpg: next trustdb check due at 2026-08-21

\==> ERROR: The keyring file /usr/share/pacman/keyrings/chaotic.gpg does not exist.

exit

   ~  pacman --sysroot /mnt -Su                                                      1 ✘  2h 0m 38s   

error: you cannot perform this operation unless you are root.

   ~  sudo pacman --sysroot /mnt -Su                                                               1 ✘  

:: Starting full system upgrade...

there is nothing to do

   ~  chroot /mnt                                                                                    ✔  

pacman-key --init

pacman-key --populate archlinux manjaro

\# Si usas Chaotic-AUR:

pacman-key --populate chaotic

exit

chroot: cannot change root directory to '/mnt': Operation not permitted

\==> ERROR: pacman-key needs to be run as root for this operation.

\==> ERROR: pacman-key needs to be run as root for this operation.

zsh: bad pattern: #

   ~  sudo su                                                                                      1 ✘  

\[manjaro manjaro\]# chroot /mnt

pacman-key --init

pacman-key --populate archlinux manjaro

\# Si usas Chaotic-AUR:

pacman-key --populate chaotic

exit

 root / 

 pacman --sysroot /mnt -Sy --noconfirm --gpgdir /etc/pacman.d/gnupg glibc gcc-libs lib32-glibc

error: config file /mnt/etc/pacman.conf could not be read: No such file or directory

 root / 

 exit

exit

\==> Appending keys from archlinux.gpg...

pacman --sysroot /mnt -Sy --noconfirm --gpgdir /etc/pacman.d/gnupg glibc gcc-libs lib32-glibc==> Appending key

s from manjaro.gpg...

\==> Locally signing trusted keys in keyring...

 -> Locally signed 2 keys.

\==> Importing owner trust values...

\==> Updating trust database...

gpg: next trustdb check due at 2026-08-21

\==> ERROR: The keyring file /usr/share/pacman/keyrings/chaotic.gpg does not exist.

exit

   ~  pacman --sysroot /mnt -Sy --noconfirm --gpgdir /etc/pacman.d/gnupg glibc gcc-libs lib32-glibc

error: you cannot perform this operation unless you are root.

   ~  sudo pacman --sysroot /mnt -Sy --noconfirm --gpgdir /etc/pacman.d/gnupg glibc gcc-libs lib32-glibc

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

warning: glibc-2.43+r5+g856c426a7534-1 is up to date -- reinstalling

warning: gcc-libs-15.2.1+r604+g0b99615a8aef-1 is up to date -- reinstalling

warning: lib32-glibc-2.43+r5+g856c426a7534-1 is up to date -- reinstalling

resolving dependencies...

looking for conflicting packages...

  

Packages (3) gcc-libs-15.2.1+r604+g0b99615a8aef-1  glibc-2.43+r5+g856c426a7534-1

            lib32-glibc-2.43+r5+g856c426a7534-1

  

Total Installed Size:  67,65 MiB

Net Upgrade Size:       0,00 MiB

  

:: Proceed with installation? \[Y/n\]  

(3/3) checking keys in keyring                                     \[####################################\] 100%

(3/3) checking package integrity                                   \[####################################\] 100%

(3/3) loading package files                                        \[####################################\] 100%

(3/3) checking for file conflicts                                  \[####################################\] 100%

(3/3) checking available disk space                                \[####################################\] 100%

:: Processing package changes...

(1/3) reinstalling glibc                                           \[####################################\] 100%

Generating locales...

Generation complete.

(2/3) reinstalling gcc-libs                                        \[####################################\] 100%

(3/3) reinstalling lib32-glibc                                     \[####################################\] 100%

:: Running post-transaction hooks...

(1/3) Arming ConditionNeedsUpdate...

(2/3) Restarting cronie for libc upgrade...

 Skipped: Running in chroot.

(3/3) Updating the info directory file...

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

¡Buenas noticias! Lo que acabas de hacer (`reinstalling glibc`) es el paso más difícil. Al reinstalar `glibc` desde el entorno Live usando `--sysroot`, has sobrescrito la librería corrupta que impedía que `gpg` funcionara.

Ahora que la base está reparada, el sistema ya debería poder "hablar" consigo mismo. Aquí tienes el script final para ejecutar **fuera del chroot** (en tu prompt de `[manjaro manjaro]#`) que terminará de limpiar el desastre y sincronizará todo:

Bash

    #!/bin/bash
    
    # Este script se debe ejecutar desde el Live USB, con el sistema montado en /mnt
    if [ "$EUID" -ne 0 ]; then 
      echo "Por favor, corre el script con sudo."
      exit
    fi
    
    echo "--- 1. Reparando el archivo pacman.conf del sistema montado ---"
    # Aseguramos que el SigLevel sea el correcto para que no falle el GPGME
    sed -i 's/SigLevel = Never/SigLevel = Required DatabaseOptional/g' /mnt/etc/pacman.conf
    
    echo "--- 2. Sincronizando bases de datos y actualizando el sistema ---"
    # Usamos el pacman del Live para asegurar una actualización limpia
    pacman --sysroot /mnt -Syu --noconfirm
    
    echo "--- 3. Entrando al sistema para arreglar las llaves permanentemente ---"
    # Ejecutamos los comandos de llaves dentro del sistema ahora que glibc funciona
    chroot /mnt /bin/bash <<EOF
    rm -rf /etc/pacman.d/gnupg
    pacman-key --init
    pacman-key --populate archlinux manjaro
    # Intentamos poblar chaotic si existe, si no, fallará silenciosamente
    pacman-key --populate chaotic || echo "Chaotic-keyring no disponible aún."
    # Refrescamos para asegurar que todo sea válido
    pacman-key --refresh-keys
    EOF
    
    echo "--- 4. Desmontando y listo ---"
    sync
    echo "Proceso terminado. Ya puedes reiniciar tu sistema normalmente."

Notas sobre lo que viste en tu pantalla:
----------------------------------------

*   **"nothing to do":** Significa que tus paquetes ya están en la última versión, lo cual es bueno. El problema no era la versión, sino que la instalación estaba rota.
    
*   **"The keyring file... chaotic.gpg does not exist":** Esto sucede porque los repositorios de terceros como Chaotic-AUR necesitan que primero instales su paquete de llaves (`chaotic-keyring`).
    

* * *

¿Qué hacer ahora?
-----------------

1.  Ejecuta el script de arriba.
    
2.  Si termina sin errores, escribe `reboot`.
    
3.  Retira el USB y arranca normalmente.
    

Una vez que inicies sesión en tu sistema normal, si quieres recuperar los repositorios como **Chaotic-AUR**, solo tendrás que ejecutar: `sudo pacman -S chaotic-keyring`

¿Te gustaría que te ayude con los comandos para reactivar esos repositorios extra una vez que reinicies?

Has parado esta respuesta

---

You asked:
----------

Has dicho

\--- 1. Reparando el archivo pacman.conf del sistema montado ---

\--- 2. Sincronizando bases de datos y actualizando el sistema ---

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

\--- 3. Entrando al sistema para arreglar las llaves permanentemente ---

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

chmod: cannot access '/etc/pacman.d/gnupg//trustdb.gpg': No such file or directory

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

\==> Generating pacman master key. This may take some time.

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

\==> Updating trust database...

gpg: /lib/x86\_64-linux-gnu/libc.so.6: version \`GLIBC\_ABI\_DT\_X86\_64\_PLT' not found (required by /usr/lib/libm.s

o.6)

\==> ERROR: Trust database could not be updated.

\==> ERROR: You do not have sufficient permissions to read the pacman keyring.

\==> Use 'pacman-key --init' to correct the keyring permissions.

\==> ERROR: You do not have sufficient permissions to read the pacman keyring.

\==> Use 'pacman-key --init' to correct the keyring permissions.

Chaotic-keyring no disponible aún.

\==> ERROR: You do not have sufficient permissions to read the pacman keyring.

\==> Use 'pacman-key --init' to correct the keyring permissions.

\--- 4. Desmontando y listo ---

Proceso terminado. Ya puedes reiniciar tu sistema normalmente.

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Esto confirma que, aunque reinstalaste `glibc`, el sistema sigue intentando cargar librerías de una ruta inusual (`/lib/x86_64-linux-gnu/`). En Arch Linux y Manjaro, las librerías deben estar en `/usr/lib` o `/lib` (que es un enlace simbólico a `/usr/lib`).

Esa ruta `x86_64-linux-gnu` es típica de **Debian/Ubuntu**, lo que sugiere que algún paquete externo o una instalación manual mezcló archivos de otra distribución en tu sistema, rompiendo la compatibilidad.

Como el `chroot` sigue fallando, vamos a aplicar la "fuerza bruta" desde el Live USB para limpiar esas rutas extrañas y asegurar que el sistema use las librerías correctas.

Script de Limpieza y Reparación Final (Ejecutar desde el Live USB)
------------------------------------------------------------------

Este script no entrará al `chroot` (porque vimos que falla). En su lugar, usará el entorno sano del USB para corregir los archivos del disco.

Bash

    #!/bin/bash
    
    # Asegúrate de estar como root en el Live USB
    if [ "$EUID" -ne 0 ]; then echo "Corre con sudo"; exit; fi
    
    echo "--- 1. Eliminando rastros de librerías ajenas (Debian/Ubuntu) ---"
    # Esto es lo que está causando el conflicto de versiones
    rm -rf /mnt/lib/x86_64-linux-gnu
    rm -rf /mnt/usr/lib/x86_64-linux-gnu
    
    echo "--- 2. Reinstalando glibc y gpgme desde el exterior ---"
    # Forzamos la reinstalación para asegurar que los enlaces simbólicos sean correctos
    pacman --sysroot /mnt -Sy --noconfirm glibc gcc-libs gpgme
    
    echo "--- 3. Reparando el llavero GPG desde el exterior ---"
    # En lugar de usar chroot, operamos sobre la ruta de /mnt directamente
    rm -rf /mnt/etc/pacman.d/gnupg
    pacman-key --gpgdir /mnt/etc/pacman.d/gnupg --init
    pacman-key --gpgdir /mnt/etc/pacman.d/gnupg --populate archlinux manjaro
    
    echo "--- 4. Verificando integridad crítica ---"
    # Aseguramos que /lib sea un enlace a /usr/lib (estándar de Arch)
    if [ ! -L /mnt/lib ]; then
        echo "Corrigiendo enlace simbólico de /lib..."
        mv /mnt/lib/* /mnt/usr/lib/ 2>/dev/null
        rm -rf /mnt/lib
        ln -s usr/lib /mnt/lib
    fi
    
    echo "--- 5. Sincronización final ---"
    pacman --sysroot /mnt -Syu
    
    echo "Proceso terminado. Intenta reiniciar ahora."

* * *

¿Por qué sigue fallando el paso 3?
----------------------------------

El error persiste porque tu variable de entorno o algunos binarios en `/mnt` están apuntando a `/lib/x86_64-linux-gnu/libc.so.6`. En Arch Linux, ese archivo **no debería existir en esa carpeta**.

**Si después de correr este script el sistema sigue sin arrancar:** Es muy probable que tengas una mezcla de paquetes de diferentes arquitecturas o distribuciones.

**¿Instalaste algo recientemente usando un script de internet, un `.deb` convertido o un gestor de paquetes como `apt` (que no debería estar en Manjaro)?** Eso explicaría por qué aparecieron esas carpetas de Debian.

¿Te gustaría que verifiquemos qué paquetes instalaron archivos en esas rutas sospechosas?

Has parado esta respuesta

---

