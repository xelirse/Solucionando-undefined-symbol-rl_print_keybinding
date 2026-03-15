You asked:
----------

Has dicho

Quiero un script que lo solucione.

  

\[manjaro mnt\]# chroot . busybox ash

chroot: fallo al ejecutar la orden «busybox»: No existe el fichero o el directorio

\[manjaro mnt\]# strace -s100 -ff chroot . busybox ash

execve("/usr/bin/chroot", \["chroot", ".", "busybox", "ash"\], 0x7ffc63499e48 /\* 23 vars \*/) = 0

brk(NULL)                               = 0x561508fce000

access("/etc/ld.so.preload", R\_OK)      = -1 ENOENT (No existe el fichero o el directorio)

openat(AT\_FDCWD, "/etc/ld.so.cache", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=181523, ...}) = 0

mmap(NULL, 181523, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f5e11b86000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/libc.so.6", O\_RDONLY|O\_CLOEXEC) = 3

read(3, "\\177ELF\\2\\1\\1\\3\\0\\0\\0\\0\\0\\0\\0\\0\\3\\0>\\0\\1\\0\\0\\0\\0y\\2\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0x\\234\\36\\0\\0\\0\\0\\0\\0\\0\\0\\

0@\\08\\0\\17\\0@\\0?\\0>\\0\\6\\0\\0\\0\\4\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0H\\3\\0\\0"..., 832) = 832

pread64(3, "\\6\\0\\0\\0\\4\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0\\10\\0\\0

\\0\\0\\0\\0\\0\\3\\0\\0\\0\\4\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0\\36\\0\\0\\0\\0\\0\\0\\0\\36\\0\\0\\0"...

, 840, 64) = 840

fstat(3, {st\_mode=S\_IFREG|0755, st\_size=2010168, ...}) = 0

mmap(NULL, 8192, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_ANONYMOUS, -1, 0) = 0x7f5e11b84000

pread64(3, "\\6\\0\\0\\0\\4\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0\\10\\0\\0

\\0\\0\\0\\0\\0\\3\\0\\0\\0\\4\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0\\36\\0\\0\\0\\0\\0\\0\\0\\36\\0\\0\\0"...

, 840, 64) = 840

mmap(NULL, 2034544, PROT\_READ, MAP\_PRIVATE|MAP\_DENYWRITE, 3, 0) = 0x7f5e11993000

mmap(0x7f5e119b7000, 1511424, PROT\_READ|PROT\_EXEC, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x24000) = 0x7f5e11

9b7000

mmap(0x7f5e11b28000, 319488, PROT\_READ, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x195000) = 0x7f5e11b28000

mmap(0x7f5e11b76000, 24576, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x1e2000) = 0x7f5e11

b76000

mmap(0x7f5e11b7c000, 31600, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_FIXED|MAP\_ANONYMOUS, -1, 0) = 0x7f5e11b7c000

close(3)                                = 0

mmap(NULL, 12288, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_ANONYMOUS, -1, 0) = 0x7f5e11990000

arch\_prctl(ARCH\_SET\_FS, 0x7f5e11990740) = 0

set\_tid\_address(0x7f5e11990d68)         = 29571

set\_robust\_list(0x7f5e11990a20, 24)     = 0

rseq(0x7f5e119906a0, 0x20, 0, 0x53053053) = 0

mprotect(0x7f5e11b76000, 16384, PROT\_READ) = 0

mprotect(0x5614e98da000, 4096, PROT\_READ) = 0

mprotect(0x7f5e11bef000, 8192, PROT\_READ) = 0

prlimit64(0, RLIMIT\_STACK, NULL, {rlim\_cur=8192\*1024, rlim\_max=RLIM64\_INFINITY}) = 0

getrandom("\\x71\\xb5\\x1e\\x5a\\xec\\xf2\\x54\\xb1", 8, GRND\_NONBLOCK) = 8

munmap(0x7f5e11b86000, 181523)          = 0

brk(NULL)                               = 0x561508fce000

brk(0x561508fef000)                     = 0x561508fef000

openat(AT\_FDCWD, "/usr/lib/locale/locale-archive", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=3062944, ...}) = 0

mmap(NULL, 3062944, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f5e116a4000

close(3)                                = 0

getcwd("/mnt", 1024)                    = 5

chroot(".")                             = 0

chdir("/")                              = 0

execve("/usr/local/sbin/busybox", \["busybox", "ash"\], 0x7ffdff61ea90 /\* 23 vars \*/) = -1 ENOENT (No existe el

fichero o el directorio)

execve("/usr/local/bin/busybox", \["busybox", "ash"\], 0x7ffdff61ea90 /\* 23 vars \*/) = -1 ENOENT (No existe el f

ichero o el directorio)

execve("/usr/bin/busybox", \["busybox", "ash"\], 0x7ffdff61ea90 /\* 23 vars \*/) = -1 ENOENT (No existe el fichero

o el directorio)

openat(AT\_FDCWD, "/usr/share/locale/locale.alias", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=2998, ...}) = 0

read(3, "# Locale name alias data base.\\n# Copyright (C) 1996-2026 Free Software Foundation, Inc.\\n#\\n# This p

ro"..., 4096) = 2998

read(3, "", 4096)                       = 0

close(3)                                = 0

openat(AT\_FDCWD, "/usr/share/locale/es\_ES.UTF-8/LC\_MESSAGES/gnulib.mo", O\_RDONLY) = -1 ENOENT (No existe el fi

chero o el directorio)

openat(AT\_FDCWD, "/usr/share/locale/es\_ES.utf8/LC\_MESSAGES/gnulib.mo", O\_RDONLY) = -1 ENOENT (No existe el fic

hero o el directorio)

openat(AT\_FDCWD, "/usr/share/locale/es\_ES/LC\_MESSAGES/gnulib.mo", O\_RDONLY) = -1 ENOENT (No existe el fichero

o el directorio)

openat(AT\_FDCWD, "/usr/share/locale/es.UTF-8/LC\_MESSAGES/gnulib.mo", O\_RDONLY) = -1 ENOENT (No existe el fiche

ro o el directorio)

openat(AT\_FDCWD, "/usr/share/locale/es.utf8/LC\_MESSAGES/gnulib.mo", O\_RDONLY) = -1 ENOENT (No existe el ficher

o o el directorio)

openat(AT\_FDCWD, "/usr/share/locale/es/LC\_MESSAGES/gnulib.mo", O\_RDONLY) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=31481, ...}) = 0

mmap(NULL, 31481, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f5e11bab000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/gconv/gconv-modules.cache", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=27010, ...}) = 0

mmap(NULL, 27010, PROT\_READ, MAP\_SHARED, 3, 0) = 0x7f5e11ba4000

close(3)                                = 0

futex(0x7f5e11b7b6ec, FUTEX\_WAKE\_PRIVATE, 2147483647) = 0

openat(AT\_FDCWD, "/usr/share/locale/es\_ES.UTF-8/LC\_MESSAGES/coreutils.mo", O\_RDONLY) = -1 ENOENT (No existe el

fichero o el directorio)

openat(AT\_FDCWD, "/usr/share/locale/es\_ES.utf8/LC\_MESSAGES/coreutils.mo", O\_RDONLY) = -1 ENOENT (No existe el

fichero o el directorio)

openat(AT\_FDCWD, "/usr/share/locale/es\_ES/LC\_MESSAGES/coreutils.mo", O\_RDONLY) = -1 ENOENT (No existe el fiche

ro o el directorio)

openat(AT\_FDCWD, "/usr/share/locale/es.UTF-8/LC\_MESSAGES/coreutils.mo", O\_RDONLY) = -1 ENOENT (No existe el fi

chero o el directorio)

openat(AT\_FDCWD, "/usr/share/locale/es.utf8/LC\_MESSAGES/coreutils.mo", O\_RDONLY) = -1 ENOENT (No existe el fic

hero o el directorio)

openat(AT\_FDCWD, "/usr/share/locale/es/LC\_MESSAGES/coreutils.mo", O\_RDONLY) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=191771, ...}) = 0

mmap(NULL, 191771, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f5e11675000

close(3)                                = 0

fcntl(1, F\_GETFL)                       = 0x2 (flags O\_RDWR)

write(2, "chroot: ", 8chroot: )                 = 8

write(2, "fallo al ejecutar la orden \\302\\253busybox\\302\\273", 38fallo al ejecutar la orden «busybox») = 38

openat(AT\_FDCWD, "/usr/share/locale/es\_ES.UTF-8/LC\_MESSAGES/libc.mo", O\_RDONLY) = -1 ENOENT (No existe el fich

ero o el directorio)

openat(AT\_FDCWD, "/usr/share/locale/es\_ES.utf8/LC\_MESSAGES/libc.mo", O\_RDONLY) = -1 ENOENT (No existe el fiche

ro o el directorio)

openat(AT\_FDCWD, "/usr/share/locale/es\_ES/LC\_MESSAGES/libc.mo", O\_RDONLY) = -1 ENOENT (No existe el fichero o

el directorio)

openat(AT\_FDCWD, "/usr/share/locale/es.UTF-8/LC\_MESSAGES/libc.mo", O\_RDONLY) = -1 ENOENT (No existe el fichero

o el directorio)

openat(AT\_FDCWD, "/usr/share/locale/es.utf8/LC\_MESSAGES/libc.mo", O\_RDONLY) = -1 ENOENT (No existe el fichero

o el directorio)

openat(AT\_FDCWD, "/usr/share/locale/es/LC\_MESSAGES/libc.mo", O\_RDONLY) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=134695, ...}) = 0

mmap(NULL, 134695, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f5e11654000

close(3)                                = 0

write(2, ": No existe el fichero o el directorio", 38: No existe el fichero o el directorio) = 38

write(2, "\\n", 1

)                       = 1

close(1)                                = 0

close(2)                                = 0

exit\_group(127)                         = ?

+++ exited with 127 +++

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

El problema que muestra tu `strace` es muy común al usar `chroot`: el comando `chroot` cambia la raíz del sistema al directorio actual (`.`), pero **dentro de ese nuevo entorno no existe el ejecutable `busybox`** (o sus librerías).

Las líneas clave son estas: `execve("/usr/bin/busybox", ["busybox", "ash"], ...) = -1 ENOENT`

Esto significa que `chroot` busca `/mnt/usr/bin/busybox` y no lo encuentra. Para que funcione, el binario debe estar físicamente dentro de la estructura de carpetas de `/mnt`.

Aquí tienes un script en Bash para preparar el entorno y entrar correctamente.

* * *

Script de Preparación y Chroot
------------------------------

Guarda este código como `entrar_chroot.sh`, dale permisos con `chmod +x entrar_chroot.sh` y ejecútalo como **root**.

Bash

    #!/bin/bash
    
    # Definir la ruta del punto de montaje
    TARGET="/mnt"
    
    echo "--- Preparando entorno chroot en $TARGET ---"
    
    # 1. Verificar si busybox existe en el sistema anfitrión
    BUSYBOX_PATH=$(which busybox)
    
    if [ -z "$BUSYBOX_PATH" ]; then
        echo "Error: busybox no está instalado en el sistema anfitrión."
        exit 1
    fi
    
    # 2. Crear directorios básicos en el destino si no existen
    mkdir -p $TARGET/bin $TARGET/usr/bin $TARGET/sbin $TARGET/proc $TARGET/sys $TARGET/dev $TARGET/run
    
    # 3. Copiar busybox al entorno chroot (usamos la versión estática si es posible)
    # Lo ideal es copiarlo a /bin/busybox dentro del chroot
    cp "$BUSYBOX_PATH" "$TARGET/bin/busybox"
    chmod +x "$TARGET/bin/busybox"
    
    # 4. Montar sistemas de archivos necesarios para que el entorno sea funcional
    echo "Montando sistemas de archivos virtuales..."
    mount --bind /dev $TARGET/dev
    mount --bind /dev/pts $TARGET/dev/pts
    mount --proc proc $TARGET/proc
    mount --bind /sys $TARGET/sys
    mount --bind /run $TARGET/run
    
    # 5. Ejecutar el chroot
    echo "Entrando al chroot..."
    chroot $TARGET /bin/busybox ash
    
    # 6. Al salir, intentar desmontar (opcional, para limpieza)
    echo "Saliendo del chroot. Desmontando..."
    umount $TARGET/dev/pts 2>/dev/null
    umount $TARGET/dev 2>/dev/null
    umount $TARGET/proc 2>/dev/null
    umount $TARGET/sys 2>/dev/null
    umount $TARGET/run 2>/dev/null

* * *

¿Por qué fallaba antes?
-----------------------

1.  **Ruta del binario:** Cuando haces `chroot . busybox ash`, el sistema busca `busybox` dentro de los directorios `$PATH` **relativos a la nueva raíz**. Si en `/mnt/usr/bin/` no hay nada, fallará.
    
2.  **Librerías (Dependencias):** Si tu `busybox` no es **estático** (compilado con todas sus librerías dentro), al entrar al chroot no encontrará `/lib/libc.so.6` y similares, lanzando el mismo error de "No existe el fichero".
    
    *   _Nota:_ El script de arriba copia el binario, pero si no es estático, podrías necesitar copiar también `/lib` y `/lib64`.
        

Una alternativa rápida (sin script)
-----------------------------------

Si solo quieres una línea rápida y tienes el binario en el host, puedes forzar la ruta absoluta dentro del chroot:

Bash

    # Asegúrate de que el archivo existe en el destino
    cp /usr/bin/busybox /mnt/bin/
    
    # Ejecuta especificando la ruta completa dentro de la nueva raíz
    chroot /mnt /bin/busybox ash

¿Te gustaría que añadiera una comprobación automática de librerías `ldd` al script para asegurar que `busybox` funcione aunque no sea estático?

Has parado esta respuesta

---

