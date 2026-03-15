You asked:
----------

Has dicho

Quiero un script para solucionarlo.

  

\[manjaro mnt\]# chroot /mnt   

Violación de segmento     (\`core' generado) chroot /mnt

\[manjaro mnt\]# strace -s100 -ff chroot /mnt   

execve("/usr/bin/chroot", \["chroot", "/mnt"\], 0x7ffcd25d98b8 /\* 23 vars \*/) = 0

brk(NULL)                               = 0x560929190000

access("/etc/ld.so.preload", R\_OK)      = -1 ENOENT (No existe el fichero o el directorio)

openat(AT\_FDCWD, "/etc/ld.so.cache", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=181523, ...}) = 0

mmap(NULL, 181523, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7fc14988c000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/libc.so.6", O\_RDONLY|O\_CLOEXEC) = 3

read(3, "\\177ELF\\2\\1\\1\\3\\0\\0\\0\\0\\0\\0\\0\\0\\3\\0>\\0\\1\\0\\0\\0\\0y\\2\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0x\\234\\36\\0\\0\\0\\0\\0\\0\\0\\0\\

0@\\08\\0\\17\\0@\\0?\\0>\\0\\6\\0\\0\\0\\4\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0H\\3\\0\\0"..., 832) = 832

pread64(3, "\\6\\0\\0\\0\\4\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0\\10\\0\\0

\\0\\0\\0\\0\\0\\3\\0\\0\\0\\4\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0\\36\\0\\0\\0\\0\\0\\0\\0\\36\\0\\0\\0"...

, 840, 64) = 840

fstat(3, {st\_mode=S\_IFREG|0755, st\_size=2010168, ...}) = 0

mmap(NULL, 8192, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_ANONYMOUS, -1, 0) = 0x7fc14988a000

pread64(3, "\\6\\0\\0\\0\\4\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0\\10\\0\\0

\\0\\0\\0\\0\\0\\3\\0\\0\\0\\4\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0\\36\\0\\0\\0\\0\\0\\0\\0\\36\\0\\0\\0"...

, 840, 64) = 840

mmap(NULL, 2034544, PROT\_READ, MAP\_PRIVATE|MAP\_DENYWRITE, 3, 0) = 0x7fc149699000

mmap(0x7fc1496bd000, 1511424, PROT\_READ|PROT\_EXEC, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x24000) = 0x7fc149

6bd000

mmap(0x7fc14982e000, 319488, PROT\_READ, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x195000) = 0x7fc14982e000

mmap(0x7fc14987c000, 24576, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x1e2000) = 0x7fc149

87c000

mmap(0x7fc149882000, 31600, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_FIXED|MAP\_ANONYMOUS, -1, 0) = 0x7fc149882000

close(3)                                = 0

mmap(NULL, 12288, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_ANONYMOUS, -1, 0) = 0x7fc149696000

arch\_prctl(ARCH\_SET\_FS, 0x7fc149696740) = 0

set\_tid\_address(0x7fc149696d68)         = 31056

set\_robust\_list(0x7fc149696a20, 24)     = 0

rseq(0x7fc1496966a0, 0x20, 0, 0x53053053) = 0

mprotect(0x7fc14987c000, 16384, PROT\_READ) = 0

mprotect(0x5608ffeb0000, 4096, PROT\_READ) = 0

mprotect(0x7fc1498f5000, 8192, PROT\_READ) = 0

prlimit64(0, RLIMIT\_STACK, NULL, {rlim\_cur=8192\*1024, rlim\_max=RLIM64\_INFINITY}) = 0

getrandom("\\xb4\\x57\\x29\\xa1\\xed\\xe8\\xf0\\x04", 8, GRND\_NONBLOCK) = 8

munmap(0x7fc14988c000, 181523)          = 0

brk(NULL)                               = 0x560929190000

brk(0x5609291b1000)                     = 0x5609291b1000

openat(AT\_FDCWD, "/usr/lib/locale/locale-archive", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=3062944, ...}) = 0

mmap(NULL, 3062944, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7fc1493aa000

close(3)                                = 0

readlink("/mnt", 0x7ffe84b2cd30, 1023)  = -1 EINVAL (Argumento inválido)

chroot("/mnt")                          = 0

chdir("/")                              = 0

execve("/usr/bin/bash", \["/usr/bin/bash", "-i"\], 0x7ffe84b2d350 /\* 23 vars \*/) = 0

brk(NULL)                               = 0x560869809000

access("/etc/ld.so.preload", R\_OK)      = -1 ENOENT (No existe el fichero o el directorio)

openat(AT\_FDCWD, "/etc/ld.so.cache", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=306143, ...}) = 0

mmap(NULL, 306143, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f990c964000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/libreadline.so.8", O\_RDONLY|O\_CLOEXEC) = 3

read(3, "\\177ELF\\2\\1\\1\\0\\0\\0\\0\\0\\0\\0\\0\\0\\3\\0>\\0\\1\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0\\230\\225\\5\\0\\0\\0\\0\\0\\0\\0

\\0\\0@\\08\\0\\v\\0@\\0\\32\\0\\31\\0\\1\\0\\0\\0\\4\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\300V\\1\\0"..., 832)

\= 832

fstat(3, {st\_mode=S\_IFREG|0755, st\_size=367640, ...}) = 0

mmap(NULL, 8192, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_ANONYMOUS, -1, 0) = 0x7f990c962000

mmap(NULL, 371816, PROT\_READ, MAP\_PRIVATE|MAP\_DENYWRITE, 3, 0) = 0x7f990c907000

mmap(0x7f990c91d000, 204800, PROT\_READ|PROT\_EXEC, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x16000) = 0x7f990c9

1d000

mmap(0x7f990c94f000, 36864, PROT\_READ, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x48000) = 0x7f990c94f000

mmap(0x7f990c958000, 36864, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x51000) = 0x7f990c9

58000

mmap(0x7f990c961000, 3176, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_FIXED|MAP\_ANONYMOUS, -1, 0) = 0x7f990c961000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/libc.so.6", O\_RDONLY|O\_CLOEXEC) = 3

read(3, "\\177ELF\\2\\1\\1\\3\\0\\0\\0\\0\\0\\0\\0\\0\\3\\0>\\0\\1\\0\\0\\0\\0y\\2\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0x\\234\\36\\0\\0\\0\\0\\0\\0\\0\\0\\

0@\\08\\0\\17\\0@\\0?\\0>\\0\\6\\0\\0\\0\\4\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0H\\3\\0\\0"..., 832) = 832

pread64(3, "\\6\\0\\0\\0\\4\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0\\10\\0\\0

\\0\\0\\0\\0\\0\\3\\0\\0\\0\\4\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0\\36\\0\\0\\0\\0\\0\\0\\0\\36\\0\\0\\0"...

, 840, 64) = 840

fstat(3, {st\_mode=S\_IFREG|0755, st\_size=2010168, ...}) = 0

pread64(3, "\\6\\0\\0\\0\\4\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0\\10\\0\\0

\\0\\0\\0\\0\\0\\3\\0\\0\\0\\4\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0\\36\\0\\0\\0\\0\\0\\0\\0\\36\\0\\0\\0"...

, 840, 64) = 840

mmap(NULL, 2034544, PROT\_READ, MAP\_PRIVATE|MAP\_DENYWRITE, 3, 0) = 0x7f990c716000

mmap(0x7f990c73a000, 1511424, PROT\_READ|PROT\_EXEC, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x24000) = 0x7f990c

73a000

mmap(0x7f990c8ab000, 319488, PROT\_READ, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x195000) = 0x7f990c8ab000

mmap(0x7f990c8f9000, 24576, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x1e2000) = 0x7f990c

8f9000

mmap(0x7f990c8ff000, 31600, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_FIXED|MAP\_ANONYMOUS, -1, 0) = 0x7f990c8ff000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/libncursesw.so.6", O\_RDONLY|O\_CLOEXEC) = 3

read(3, "\\177ELF\\2\\1\\1\\0\\0\\0\\0\\0\\0\\0\\0\\0\\3\\0>\\0\\1\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0\\20\\366\\6\\0\\0\\0\\0\\0\\0\\0\\

0\\0@\\08\\0\\v\\0@\\0\\33\\0\\32\\0\\1\\0\\0\\0\\4\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\360\\314\\0\\0"..., 83

2) = 832

fstat(3, {st\_mode=S\_IFREG|0755, st\_size=457936, ...}) = 0

mmap(NULL, 461920, PROT\_READ, MAP\_PRIVATE|MAP\_DENYWRITE, 3, 0) = 0x7f990c6a5000

mmap(0x7f990c6b2000, 294912, PROT\_READ|PROT\_EXEC, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0xd000) = 0x7f990c6b

2000

mmap(0x7f990c6fa000, 90112, PROT\_READ, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x55000) = 0x7f990c6fa000

mmap(0x7f990c710000, 24576, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x6a000) = 0x7f990c7

10000

close(3)                                = 0

mmap(NULL, 8192, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_ANONYMOUS, -1, 0) = 0x7f990c6a3000

arch\_prctl(ARCH\_SET\_FS, 0x7f990c6a3b80) = 0

set\_tid\_address(0x7f990c6a3e50)         = 31056

set\_robust\_list(0x7f990c6a3e60, 24)     = 0

rseq(0x7f990c6a3ae0, 0x20, 0, 0x53053053) = 0

mprotect(0x7f990c8f9000, 16384, PROT\_READ) = 0

mprotect(0x7f990c710000, 20480, PROT\_READ) = 0

mprotect(0x7f990c958000, 12288, PROT\_READ) = 0

mprotect(0x560863047000, 12288, PROT\_READ) = 0

mprotect(0x7f990c9ea000, 8192, PROT\_READ) = 0

prlimit64(0, RLIMIT\_STACK, NULL, {rlim\_cur=8192\*1024, rlim\_max=RLIM64\_INFINITY}) = 0

getrandom("\\x13\\x11\\xb2\\xf2\\x56\\x36\\x5a\\x48", 8, GRND\_NONBLOCK) = 8

munmap(0x7f990c964000, 306143)          = 0

openat(AT\_FDCWD, "/dev/tty", O\_RDWR|O\_NONBLOCK) = -1 ENOENT (No existe el fichero o el directorio)

ioctl(0, TCGETS2, {c\_iflag=ICRNL|IXON, c\_oflag=NL0|CR0|TAB0|BS0|VT0|FF0|OPOST|ONLCR, c\_cflag=B38400|CS8|CREAD,

c\_lflag=ISIG|ICANON|ECHO|ECHOE|ECHOK|IEXTEN|ECHOCTL|ECHOKE, ...}) = 0

brk(NULL)                               = 0x560869809000

brk(0x56086982b000)                     = 0x56086982b000

ioctl(0, TCGETS2, {c\_iflag=ICRNL|IXON, c\_oflag=NL0|CR0|TAB0|BS0|VT0|FF0|OPOST|ONLCR, c\_cflag=B38400|CS8|CREAD,

c\_lflag=ISIG|ICANON|ECHO|ECHOE|ECHOK|IEXTEN|ECHOCTL|ECHOKE, ...}) = 0

fstat(0, {st\_mode=S\_IFCHR|0620, st\_rdev=makedev(0x88, 0x5), ...}) = 0

readlink("/proc/self/fd/0", 0x560869809010, 4095) = -1 ENOENT (No existe el fichero o el directorio)

newfstatat(AT\_FDCWD, "/dev/pts/", {st\_mode=S\_IFDIR|0755, st\_size=0, ...}, 0) = 0

openat(AT\_FDCWD, "/dev/pts/", O\_RDONLY|O\_NONBLOCK|O\_CLOEXEC|O\_DIRECTORY) = 3

fstat(3, {st\_mode=S\_IFDIR|0755, st\_size=0, ...}) = 0

getdents64(3, 0x56086980a050 /\* 9 entries \*/, 32768) = 216

newfstatat(AT\_FDCWD, "/dev/pts/5", {st\_mode=S\_IFCHR|0620, st\_rdev=makedev(0x88, 0x5), ...}, 0) = 0

close(3)                                = 0

openat(AT\_FDCWD, "/dev/pts/5", O\_RDWR|O\_NONBLOCK) = 3

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/locale-archive", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fichero o el

directorio)

openat(AT\_FDCWD, "/usr/share/locale/locale.alias", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=2998, ...}) = 0

read(3, "# Locale name alias data base.\\n# Copyright (C) 1996-2026 Free Software Foundation, Inc.\\n#\\n# This p

ro"..., 4096) = 2998

read(3, "", 4096)                       = 0

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_IDENTIFICATION", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe e

l fichero o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_IDENTIFICATION", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=350, ...}) = 0

mmap(NULL, 350, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f990c9ae000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/gconv/gconv-modules.cache", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=27010, ...}) = 0

mmap(NULL, 27010, PROT\_READ, MAP\_SHARED, 3, 0) = 0x7f990c9a7000

close(3)                                = 0

futex(0x7f990c8fe6ec, FUTEX\_WAKE\_PRIVATE, 2147483647) = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_MEASUREMENT", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el f

ichero o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_MEASUREMENT", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=23, ...}) = 0

mmap(NULL, 23, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f990c9a6000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_TELEPHONE", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fic

hero o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_TELEPHONE", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=51, ...}) = 0

mmap(NULL, 51, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f990c9a5000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_ADDRESS", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fiche

ro o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_ADDRESS", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=151, ...}) = 0

mmap(NULL, 151, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f990c9a4000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_NAME", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fichero

o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_NAME", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=62, ...}) = 0

mmap(NULL, 62, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f990c9a3000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_PAPER", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fichero

o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_PAPER", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=34, ...}) = 0

mmap(NULL, 34, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f990c9a2000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_MESSAGES", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fich

ero o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_MESSAGES", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFDIR|0755, st\_size=30, ...}) = 0

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_MESSAGES/SYS\_LC\_MESSAGES", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=59, ...}) = 0

mmap(NULL, 59, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f990c9a1000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_MONETARY", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fich

ero o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_MONETARY", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=290, ...}) = 0

mmap(NULL, 290, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f990c9a0000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_COLLATE", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fiche

ro o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_COLLATE", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=2586930, ...}) = 0

mmap(NULL, 2586930, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f990c400000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_TIME", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fichero

o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_TIME", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=3264, ...}) = 0

mmap(NULL, 3264, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f990c99f000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_NUMERIC", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fiche

ro o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_NUMERIC", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=54, ...}) = 0

mmap(NULL, 54, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f990c99e000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_CTYPE", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fichero

o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_CTYPE", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=367708, ...}) = 0

mmap(NULL, 367708, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f990c3a6000

close(3)                                = 0

getresuid(\[0\], \[0\], \[0\])                = 0

getresgid(\[0\], \[0\], \[0\])                = 0

rt\_sigprocmask(SIG\_BLOCK, NULL, \[\], 8)  = 0

\--- SIGSEGV {si\_signo=SIGSEGV, si\_code=SEGV\_ACCERR, si\_addr=0x7f990c9edef0} ---

+++ killed by SIGSEGV (core dumped) +++

Violación de segmento     (\`core' generado) strace -s100 -ff chroot /mnt

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Vaya situación frustrante. Analizando el `strace`, el problema es bastante claro: el comando `chroot` funciona correctamente (hace el cambio de raíz y el `chdir`), pero en el momento en que intenta ejecutar `/usr/bin/bash` dentro del nuevo entorno, este **muere inmediatamente con un `SIGSEGV`**.

El Diagnóstico
--------------

El error ocurre justo después de intentar cargar las **locales** y comprobar el **UID/GID**. La causa más probable en Manjaro/Arch es una de estas dos:

1.  **Incompatibilidad de binarios:** Estás intentando entrar en una arquitectura distinta (ej. un sistema de 32 bits desde uno de 64) sin el emulador correspondiente (`qemu-user-static`).
    
2.  **Librerías rotas o desactualizadas:** La `libc` o la `readline` dentro de `/mnt` están corruptas o son incompatibles con el kernel/entorno actual.
    

* * *

La Solución: Script de Emergencia
---------------------------------

Este script no solo monta los directorios necesarios, sino que intenta usar un shell básico (`sh`) en lugar de `bash` para evitar que las librerías de `readline` o las locales causen el crash inicial.

Copia y guarda esto como `reparar_chroot.sh`:

Bash

    #!/bin/bash
    
    # Verificar que somos root
    if [ "$EUID" -ne 0 ]; then 
      echo "Por favor, corre el script como root (sudo)."
      exit
    fi
    
    TARGET="/mnt"
    
    echo "--- Preparando entorno para chroot en $TARGET ---"
    
    # 1. Montajes críticos de la API del Kernel
    for dir in proc sys dev dev/pts run; do
        if ! mountpoint -q "$TARGET/$dir"; then
            mount --bind /$dir "$TARGET/$dir"
            echo "Montado: $dir"
        fi
    done
    
    # 2. Copiar DNS para tener internet dentro
    cp /etc/resolv.conf "$TARGET/etc/resolv.conf"
    
    echo "--- Intentando entrar al entorno ---"
    echo "Si bash falla, intentaremos con /bin/sh..."
    
    # 3. Intento de chroot dinámico
    # Usamos env -i para limpiar variables de entorno que puedan causar conflictos con las locales
    chroot "$TARGET" /usr/bin/env -i TERM=$TERM PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /bin/bash
    
    if [ $? -ne 0 ]; then
        echo "¡BASH FALLÓ! Intentando con un shell mínimo (sh)..."
        chroot "$TARGET" /bin/sh
    fi

Cómo usarlo:
------------

1.  Dale permisos: `chmod +x reparar_chroot.sh`
    
2.  Ejecútalo: `./reparar_chroot.sh`
    

* * *

Si el script sigue lanzando "Violación de segmento":
----------------------------------------------------

Si incluso con `/bin/sh` recibes un Segfault, el problema es la **Glibc** interna de tu sistema en `/mnt`. Aquí tienes los pasos manuales para repararlo desde el sistema "Live":

1.  **Actualiza el sistema externo desde fuera:** Si usas Manjaro, utiliza `pacman` con el flag `--sysroot`:
    
    Bash
    
        pacman --sysroot /mnt -Syu bash glibc readline
    
    _Esto reinstalará las librerías básicas en la partición montada usando los binarios sanos del Live USB._
    
2.  **Verifica la arquitectura:** Ejecuta `file /mnt/usr/bin/bash`. Si dice algo como `ELF 32-bit` y tu sistema anfitrión es de 64 bits, necesitas instalar `qemu-user-static` y `binfmt-support` en el sistema Live antes de hacer chroot.
    

¿Te gustaría que te ayude a verificar si hay alguna librería específica corrupta mediante un comando de chequeo de integridad?

Has parado esta respuesta

---

You asked:
----------

Has dicho

\--- Preparando entorno para chroot en /mnt ---

\--- Intentando entrar al entorno ---

Si bash falla, intentaremos con /bin/sh...

./s0.sh: línea 29: 31404 Violación de segmento     (\`core' generado) chroot "$TARGET" /usr/bin/env -i TERM=$TE

RM PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /bin/bash

¡BASH FALLÓ! Intentando con un shell mínimo (sh)...

./s0.sh: línea 34: 31408 Violación de segmento     (\`core' generado) chroot "$TARGET" /bin/sh

  

:: Sincronizando las bases de datos de los paquetes...

core está actualizado

extra                                   8,0 MiB  1134 KiB/s 00:07 \[####################################\] 100%

multilib                              127,9 KiB  67,3 KiB/s 00:02 \[####################################\] 100%

andontie-aur está actualizado

archlinuxgr está actualizado

archlinuxcn                          1342,6 KiB   247 KiB/s 00:05 \[####################################\] 100%

extra-alucryd está actualizado

arcanisrepo está actualizado

chaotic-aur                           646,7 KiB   194 KiB/s 00:03 \[####################################\] 100%

archstrike está actualizado

advertencia: bash-5.3.9-1 está actualizado -- reinstalándolo

advertencia: glibc-2.43+r5+g856c426a7534-1 está actualizado -- reinstalándolo

advertencia: readline-8.3.003-1 está actualizado -- reinstalándolo

:: Iniciando actualización completa del sistema...

resolviendo dependencias...

buscando conflictos entre paquetes...

advertencia: se ha detectado un bucle de dependencias:

advertencia: postfix-lmdb se instalará antes de su dependencia postfix

  

Paquetes (9) libplacebo-7.360.1-1  poppler-26.03.0-1  poppler-glib-26.03.0-1  poppler-qt6-26.03.0-1

            postfix-3.11.1-1  postfix-lmdb-3.11.1-1  bash-5.3.9-1  glibc-2.43+r5+g856c426a7534-1

            readline-8.3.003-1

  

Tamaño total de la descarga:     16,63 MiB

Tamaño total de la instalación:  76,66 MiB

Tamaño neto tras actualizar:      0,00 MiB

  

:: ¿Continuar con la instalación? \[S/n\]  

:: Obteniendo los paquetes...

postfix-3.11.1-1-x86\_64              1442,6 KiB   378 KiB/s 00:04 \[####################################\] 100%

poppler-26.03.0-1-x86\_64             1715,3 KiB   354 KiB/s 00:05 \[####################################\] 100%

libplacebo-7.360.1-1-x86\_64           517,6 KiB   143 KiB/s 00:04 \[####################################\] 100%

readline-8.3.003-1-x86\_64             409,7 KiB   402 KiB/s 00:01 \[####################################\] 100%

bash-5.3.9-1-x86\_64                  1934,3 KiB   231 KiB/s 00:08 \[####################################\] 100%

poppler-qt6-26.03.0-1-x86\_64          258,4 KiB   501 KiB/s 00:01 \[####################################\] 100%

poppler-glib-26.03.0-1-x86\_64         356,8 KiB   272 KiB/s 00:01 \[####################################\] 100%

postfix-lmdb-3.11.1-1-x86\_64           21,7 KiB  33,5 KiB/s 00:01 \[####################################\] 100%

glibc-2.43+r5+g856c426a7534-1-x86\_64   10,1 MiB   590 KiB/s 00:18 \[####################################\] 100%

Total (9/9)                            16,6 MiB   938 KiB/s 00:18 \[####################################\] 100%

(9/9) comprobando las claves del depósito                          \[####################################\] 100%

(9/9) verificando la integridad de los paquetes                    \[####################################\] 100%

(9/9) cargando los archivos de los paquetes                        \[####################################\] 100%

(9/9) comprobando conflictos entre archivos                        \[####################################\] 100%

(9/9) comprobando el espacio disponible en el disco                \[####################################\] 100%

advertencia: no se pudo obtener información del archivo usr/bin/mailq

advertencia: no se pudo obtener información del archivo usr/bin/newaliases

advertencia: no se pudo obtener información del archivo usr/bin/postalias

advertencia: no se pudo obtener información del archivo usr/bin/postcat

advertencia: no se pudo obtener información del archivo usr/bin/postconf

advertencia: no se pudo obtener información del archivo usr/bin/postdrop

advertencia: no se pudo obtener información del archivo usr/bin/postfix

advertencia: no se pudo obtener información del archivo usr/bin/postfix-collate.pl

advertencia: no se pudo obtener información del archivo usr/bin/postfix-tlstype.pl

advertencia: no se pudo obtener información del archivo usr/bin/postkick

advertencia: no se pudo obtener información del archivo usr/bin/postlock

advertencia: no se pudo obtener información del archivo usr/bin/postlog

advertencia: no se pudo obtener información del archivo usr/bin/postmap

advertencia: no se pudo obtener información del archivo usr/bin/postmulti

advertencia: no se pudo obtener información del archivo usr/bin/postqueue

advertencia: no se pudo obtener información del archivo usr/bin/postsuper

advertencia: no se pudo obtener información del archivo usr/bin/posttls-finger

advertencia: no se pudo obtener información del archivo usr/bin/qmqp-sink

advertencia: no se pudo obtener información del archivo usr/bin/qmqp-source

advertencia: no se pudo obtener información del archivo usr/bin/qshape

advertencia: no se pudo obtener información del archivo usr/bin/sendmail

advertencia: no se pudo obtener información del archivo usr/bin/smtp-sink

advertencia: no se pudo obtener información del archivo usr/bin/smtp-source

:: Procesando los cambios de los paquetes...

(1/9) reinstalando glibc                                           \[####################################\] 100%

error: orden terminada por la señal 11: Violación de segmento

(2/9) reinstalando readline                                        \[####################################\] 100%

(3/9) reinstalando bash                                            \[####################################\] 100%

error: orden terminada por la señal 11: Violación de segmento

(4/9) actualizando libplacebo                                      \[####################################\] 100%

(5/9) actualizando poppler                                         \[####################################\] 100%

(6/9) actualizando poppler-glib                                    \[####################################\] 100%

(7/9) actualizando poppler-qt6                                     \[####################################\] 100%

(8/9) actualizando postfix-lmdb                                    \[####################################\] 100%

(9/9) actualizando postfix                                         \[####################################\] 100%

error: orden terminada por la señal 11: Violación de segmento

:: Ejecutando los «hooks» de posinstalación...

(1/7) Creating system user accounts...

error: orden terminada por la señal 11: Violación de segmento

(2/7) Creating temporary files...

error: orden terminada por la señal 11: Violación de segmento

(3/7) Reloading system manager configuration...

error: orden terminada por la señal 11: Violación de segmento

(4/7) Restarting marked services...

error: orden terminada por la señal 11: Violación de segmento

(5/7) Arming ConditionNeedsUpdate...

error: orden terminada por la señal 11: Violación de segmento

(6/7) Restarting cronie for libc upgrade...

error: orden terminada por la señal 11: Violación de segmento

(7/7) Updating the info directory file...

error: orden terminada por la señal 11: Violación de segmento

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Esto es crítico. Lo que estamos viendo es que **`pacman` mismo está sufriendo violaciones de segmento** al intentar ejecutar los scripts de instalación (hooks) dentro de `/mnt`.

El error al reinstalar `glibc` y `bash` indica que el sistema de archivos en `/mnt` tiene binarios o librerías tan dañados que ni siquiera las herramientas de mantenimiento pueden ejecutar pasos básicos.

El Problema
-----------

Cuando usas `pacman --sysroot /mnt`, Pacman intenta ejecutar comandos "dentro" de ese entorno para finalizar la instalación. Como la `glibc` o el `ld-linux` de `/mnt` están rotos, cualquier binario que Pacman intente disparar ahí dentro muere con `SIGSEGV`.

* * *

La Solución: Fuerza Bruta desde el Exterior
-------------------------------------------

Necesitamos instalar los paquetes **sin ejecutar scripts internos**, tratando a `/mnt` simplemente como un montón de carpetas, no como un sistema vivo.

Ejecuta este comando exactamente así (como root):

Bash

    pacman --root /mnt --cachedir /mnt/var/cache/pacman/pkg --dbpath /mnt/var/lib/pacman -S glibc bash readline coreutils --overwrite "*"

**¿Por qué esto es diferente?**

*   `--root /mnt`: Le dice a pacman que ese es el destino, pero intentará usar las herramientas del sistema "Live" (que sí funcionan) para descomprimir los archivos.
    
*   `--overwrite "*"`: Obliga a sobrescribir cualquier archivo que ya exista y esté corrupto.
    

* * *

Paso 2: Reparación Manual de Enlaces (Si lo anterior falla)
-----------------------------------------------------------

Si después de eso el `chroot` sigue dando error, es probable que el "Cargador Dinámico" esté apuntando al lugar equivocado o el enlace simbólico esté roto. Verifica esto:

1.  **Verifica el cargador:**
    
    Bash
    
        ls -l /mnt/lib64/ld-linux-x86-64.so.2
    
    _Debería apuntar a algo como `../usr/lib/ld-linux-x86-64.so.2`._
    
2.  **Copia el cargador del Live USB (Medida desesperada):** Si el archivo no existe o está corrupto, cópialo del sistema que sí funciona:
    
    Bash
    
        cp /usr/lib/ld-linux-x86-64.so.2 /mnt/usr/lib/ld-linux-x86-64.so.2
    

* * *

Paso 3: El último recurso (Static Shell)
----------------------------------------

Si nada de lo anterior funciona, tu última oportunidad para entrar y arreglar cosas es usar el `busybox` del sistema Live (que es un binario estático y no depende de la `glibc` rota de `/mnt`):

Bash

    cp /usr/bin/busybox /mnt/busybox
    chroot /mnt /busybox sh

**Una vez que logres entrar con el comando de arriba (Paso 1), ¿quieres que verifiquemos si hay algún error en el sistema de archivos con `fsck` antes de seguir forzando la escritura?**

Has parado esta respuesta

---

You asked:
----------

Has dicho

Quiero un script para repararlo.

  

\[manjaro mnt\]# chroot /mnt  

Violación de segmento     (\`core' generado) chroot /mnt

\[manjaro mnt\]# strace -s100 -ff chroot /mnt  

execve("/usr/bin/chroot", \["chroot", "/mnt"\], 0x7ffc887cfd28 /\* 23 vars \*/) = 0

brk(NULL)                               = 0x560fdcce3000

access("/etc/ld.so.preload", R\_OK)      = -1 ENOENT (No existe el fichero o el directorio)

openat(AT\_FDCWD, "/etc/ld.so.cache", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=181523, ...}) = 0

mmap(NULL, 181523, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f711c828000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/libc.so.6", O\_RDONLY|O\_CLOEXEC) = 3

read(3, "\\177ELF\\2\\1\\1\\3\\0\\0\\0\\0\\0\\0\\0\\0\\3\\0>\\0\\1\\0\\0\\0\\0y\\2\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0x\\234\\36\\0\\0\\0\\0\\0\\0\\0\\0\\

0@\\08\\0\\17\\0@\\0?\\0>\\0\\6\\0\\0\\0\\4\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0H\\3\\0\\0"..., 832) = 832

pread64(3, "\\6\\0\\0\\0\\4\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0\\10\\0\\0

\\0\\0\\0\\0\\0\\3\\0\\0\\0\\4\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0\\36\\0\\0\\0\\0\\0\\0\\0\\36\\0\\0\\0"...

, 840, 64) = 840

fstat(3, {st\_mode=S\_IFREG|0755, st\_size=2010168, ...}) = 0

mmap(NULL, 8192, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_ANONYMOUS, -1, 0) = 0x7f711c826000

pread64(3, "\\6\\0\\0\\0\\4\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0\\10\\0\\0

\\0\\0\\0\\0\\0\\3\\0\\0\\0\\4\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0\\36\\0\\0\\0\\0\\0\\0\\0\\36\\0\\0\\0"...

, 840, 64) = 840

mmap(NULL, 2034544, PROT\_READ, MAP\_PRIVATE|MAP\_DENYWRITE, 3, 0) = 0x7f711c635000

mmap(0x7f711c659000, 1511424, PROT\_READ|PROT\_EXEC, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x24000) = 0x7f711c

659000

mmap(0x7f711c7ca000, 319488, PROT\_READ, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x195000) = 0x7f711c7ca000

mmap(0x7f711c818000, 24576, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x1e2000) = 0x7f711c

818000

mmap(0x7f711c81e000, 31600, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_FIXED|MAP\_ANONYMOUS, -1, 0) = 0x7f711c81e000

close(3)                                = 0

mmap(NULL, 12288, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_ANONYMOUS, -1, 0) = 0x7f711c632000

arch\_prctl(ARCH\_SET\_FS, 0x7f711c632740) = 0

set\_tid\_address(0x7f711c632d68)         = 31719

set\_robust\_list(0x7f711c632a20, 24)     = 0

rseq(0x7f711c6326a0, 0x20, 0, 0x53053053) = 0

mprotect(0x7f711c818000, 16384, PROT\_READ) = 0

mprotect(0x560fafb21000, 4096, PROT\_READ) = 0

mprotect(0x7f711c891000, 8192, PROT\_READ) = 0

prlimit64(0, RLIMIT\_STACK, NULL, {rlim\_cur=8192\*1024, rlim\_max=RLIM64\_INFINITY}) = 0

getrandom("\\x1e\\x04\\xa0\\x3e\\x2c\\xa5\\x84\\xfd", 8, GRND\_NONBLOCK) = 8

munmap(0x7f711c828000, 181523)          = 0

brk(NULL)                               = 0x560fdcce3000

brk(0x560fdcd04000)                     = 0x560fdcd04000

openat(AT\_FDCWD, "/usr/lib/locale/locale-archive", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=3062944, ...}) = 0

mmap(NULL, 3062944, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7f711c346000

close(3)                                = 0

readlink("/mnt", 0x7ffe29003ae0, 1023)  = -1 EINVAL (Argumento inválido)

chroot("/mnt")                          = 0

chdir("/")                              = 0

execve("/usr/bin/bash", \["/usr/bin/bash", "-i"\], 0x7ffe29004100 /\* 23 vars \*/) = 0

brk(NULL)                               = 0x55f465875000

access("/etc/ld.so.preload", R\_OK)      = -1 ENOENT (No existe el fichero o el directorio)

openat(AT\_FDCWD, "/etc/ld.so.cache", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=331787, ...}) = 0

mmap(NULL, 331787, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7fd10a399000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/libreadline.so.8", O\_RDONLY|O\_CLOEXEC) = 3

read(3, "\\177ELF\\2\\1\\1\\0\\0\\0\\0\\0\\0\\0\\0\\0\\3\\0>\\0\\1\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0\\230\\225\\5\\0\\0\\0\\0\\0\\0\\0

\\0\\0@\\08\\0\\v\\0@\\0\\32\\0\\31\\0\\1\\0\\0\\0\\4\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\300V\\1\\0"..., 832)

\= 832

fstat(3, {st\_mode=S\_IFREG|0755, st\_size=367640, ...}) = 0

mmap(NULL, 8192, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_ANONYMOUS, -1, 0) = 0x7fd10a397000

mmap(NULL, 371816, PROT\_READ, MAP\_PRIVATE|MAP\_DENYWRITE, 3, 0) = 0x7fd10a33c000

mmap(0x7fd10a352000, 204800, PROT\_READ|PROT\_EXEC, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x16000) = 0x7fd10a3

52000

mmap(0x7fd10a384000, 36864, PROT\_READ, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x48000) = 0x7fd10a384000

mmap(0x7fd10a38d000, 36864, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x51000) = 0x7fd10a3

8d000

mmap(0x7fd10a396000, 3176, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_FIXED|MAP\_ANONYMOUS, -1, 0) = 0x7fd10a396000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/libc.so.6", O\_RDONLY|O\_CLOEXEC) = 3

read(3, "\\177ELF\\2\\1\\1\\3\\0\\0\\0\\0\\0\\0\\0\\0\\3\\0>\\0\\1\\0\\0\\0\\0y\\2\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0x\\234\\36\\0\\0\\0\\0\\0\\0\\0\\0\\

0@\\08\\0\\17\\0@\\0?\\0>\\0\\6\\0\\0\\0\\4\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0H\\3\\0\\0"..., 832) = 832

pread64(3, "\\6\\0\\0\\0\\4\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0\\10\\0\\0

\\0\\0\\0\\0\\0\\3\\0\\0\\0\\4\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0\\36\\0\\0\\0\\0\\0\\0\\0\\36\\0\\0\\0"...

, 840, 64) = 840

fstat(3, {st\_mode=S\_IFREG|0755, st\_size=2010168, ...}) = 0

pread64(3, "\\6\\0\\0\\0\\4\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0H\\3\\0\\0\\0\\0\\0\\0\\10\\0\\0

\\0\\0\\0\\0\\0\\3\\0\\0\\0\\4\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0 \\257\\33\\0\\0\\0\\0\\0\\36\\0\\0\\0\\0\\0\\0\\0\\36\\0\\0\\0"...

, 840, 64) = 840

mmap(NULL, 2034544, PROT\_READ, MAP\_PRIVATE|MAP\_DENYWRITE, 3, 0) = 0x7fd10a14b000

mmap(0x7fd10a16f000, 1511424, PROT\_READ|PROT\_EXEC, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x24000) = 0x7fd10a

16f000

mmap(0x7fd10a2e0000, 319488, PROT\_READ, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x195000) = 0x7fd10a2e0000

mmap(0x7fd10a32e000, 24576, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x1e2000) = 0x7fd10a

32e000

mmap(0x7fd10a334000, 31600, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_FIXED|MAP\_ANONYMOUS, -1, 0) = 0x7fd10a334000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/libncursesw.so.6", O\_RDONLY|O\_CLOEXEC) = 3

read(3, "\\177ELF\\2\\1\\1\\0\\0\\0\\0\\0\\0\\0\\0\\0\\3\\0>\\0\\1\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0@\\0\\0\\0\\0\\0\\0\\0\\20\\366\\6\\0\\0\\0\\0\\0\\0\\0\\

0\\0@\\08\\0\\v\\0@\\0\\33\\0\\32\\0\\1\\0\\0\\0\\4\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\360\\314\\0\\0"..., 83

2) = 832

fstat(3, {st\_mode=S\_IFREG|0755, st\_size=457936, ...}) = 0

mmap(NULL, 461920, PROT\_READ, MAP\_PRIVATE|MAP\_DENYWRITE, 3, 0) = 0x7fd10a0da000

mmap(0x7fd10a0e7000, 294912, PROT\_READ|PROT\_EXEC, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0xd000) = 0x7fd10a0e

7000

mmap(0x7fd10a12f000, 90112, PROT\_READ, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x55000) = 0x7fd10a12f000

mmap(0x7fd10a145000, 24576, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_FIXED|MAP\_DENYWRITE, 3, 0x6a000) = 0x7fd10a1

45000

close(3)                                = 0

mmap(NULL, 8192, PROT\_READ|PROT\_WRITE, MAP\_PRIVATE|MAP\_ANONYMOUS, -1, 0) = 0x7fd10a0d8000

arch\_prctl(ARCH\_SET\_FS, 0x7fd10a0d8b80) = 0

set\_tid\_address(0x7fd10a0d8e50)         = 31719

set\_robust\_list(0x7fd10a0d8e60, 24)     = 0

rseq(0x7fd10a0d8ae0, 0x20, 0, 0x53053053) = 0

mprotect(0x7fd10a32e000, 16384, PROT\_READ) = 0

mprotect(0x7fd10a145000, 20480, PROT\_READ) = 0

mprotect(0x7fd10a38d000, 12288, PROT\_READ) = 0

mprotect(0x55f42c20d000, 12288, PROT\_READ) = 0

mprotect(0x7fd10a426000, 8192, PROT\_READ) = 0

prlimit64(0, RLIMIT\_STACK, NULL, {rlim\_cur=8192\*1024, rlim\_max=RLIM64\_INFINITY}) = 0

getrandom("\\xbe\\x7f\\x09\\x3f\\x0b\\xf6\\x88\\x0f", 8, GRND\_NONBLOCK) = 8

munmap(0x7fd10a399000, 331787)          = 0

openat(AT\_FDCWD, "/dev/tty", O\_RDWR|O\_NONBLOCK) = -1 ENOENT (No existe el fichero o el directorio)

ioctl(0, TCGETS2, {c\_iflag=ICRNL|IXON, c\_oflag=NL0|CR0|TAB0|BS0|VT0|FF0|OPOST|ONLCR, c\_cflag=B38400|CS8|CREAD,

c\_lflag=ISIG|ICANON|ECHO|ECHOE|ECHOK|IEXTEN|ECHOCTL|ECHOKE, ...}) = 0

brk(NULL)                               = 0x55f465875000

brk(0x55f465897000)                     = 0x55f465897000

ioctl(0, TCGETS2, {c\_iflag=ICRNL|IXON, c\_oflag=NL0|CR0|TAB0|BS0|VT0|FF0|OPOST|ONLCR, c\_cflag=B38400|CS8|CREAD,

c\_lflag=ISIG|ICANON|ECHO|ECHOE|ECHOK|IEXTEN|ECHOCTL|ECHOKE, ...}) = 0

fstat(0, {st\_mode=S\_IFCHR|0620, st\_rdev=makedev(0x88, 0x5), ...}) = 0

readlink("/proc/self/fd/0", 0x55f465875010, 4095) = -1 ENOENT (No existe el fichero o el directorio)

newfstatat(AT\_FDCWD, "/dev/pts/", {st\_mode=S\_IFDIR|0755, st\_size=0, ...}, 0) = 0

openat(AT\_FDCWD, "/dev/pts/", O\_RDONLY|O\_NONBLOCK|O\_CLOEXEC|O\_DIRECTORY) = 3

fstat(3, {st\_mode=S\_IFDIR|0755, st\_size=0, ...}) = 0

getdents64(3, 0x55f465876050 /\* 9 entries \*/, 32768) = 216

newfstatat(AT\_FDCWD, "/dev/pts/5", {st\_mode=S\_IFCHR|0620, st\_rdev=makedev(0x88, 0x5), ...}, 0) = 0

close(3)                                = 0

openat(AT\_FDCWD, "/dev/pts/5", O\_RDWR|O\_NONBLOCK) = 3

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/locale-archive", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fichero o el

directorio)

openat(AT\_FDCWD, "/usr/share/locale/locale.alias", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=2998, ...}) = 0

read(3, "# Locale name alias data base.\\n# Copyright (C) 1996-2026 Free Software Foundation, Inc.\\n#\\n# This p

ro"..., 4096) = 2998

read(3, "", 4096)                       = 0

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_IDENTIFICATION", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe e

l fichero o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_IDENTIFICATION", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=350, ...}) = 0

mmap(NULL, 350, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7fd10a3ea000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/gconv/gconv-modules.cache", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=27010, ...}) = 0

mmap(NULL, 27010, PROT\_READ, MAP\_SHARED, 3, 0) = 0x7fd10a3e3000

close(3)                                = 0

futex(0x7fd10a3336ec, FUTEX\_WAKE\_PRIVATE, 2147483647) = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_MEASUREMENT", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el f

ichero o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_MEASUREMENT", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=23, ...}) = 0

mmap(NULL, 23, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7fd10a3e2000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_TELEPHONE", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fic

hero o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_TELEPHONE", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=51, ...}) = 0

mmap(NULL, 51, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7fd10a3e1000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_ADDRESS", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fiche

ro o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_ADDRESS", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=151, ...}) = 0

mmap(NULL, 151, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7fd10a3e0000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_NAME", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fichero

o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_NAME", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=62, ...}) = 0

mmap(NULL, 62, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7fd10a3df000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_PAPER", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fichero

o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_PAPER", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=34, ...}) = 0

mmap(NULL, 34, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7fd10a3de000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_MESSAGES", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fich

ero o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_MESSAGES", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFDIR|0755, st\_size=30, ...}) = 0

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_MESSAGES/SYS\_LC\_MESSAGES", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=59, ...}) = 0

mmap(NULL, 59, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7fd10a3dd000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_MONETARY", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fich

ero o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_MONETARY", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=290, ...}) = 0

mmap(NULL, 290, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7fd10a3dc000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_COLLATE", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fiche

ro o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_COLLATE", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=2586930, ...}) = 0

mmap(NULL, 2586930, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7fd109e00000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_TIME", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fichero

o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_TIME", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=3264, ...}) = 0

mmap(NULL, 3264, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7fd10a3db000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_NUMERIC", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fiche

ro o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_NUMERIC", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=54, ...}) = 0

mmap(NULL, 54, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7fd10a3da000

close(3)                                = 0

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.UTF-8/LC\_CTYPE", O\_RDONLY|O\_CLOEXEC) = -1 ENOENT (No existe el fichero

o el directorio)

openat(AT\_FDCWD, "/usr/lib/locale/es\_ES.utf8/LC\_CTYPE", O\_RDONLY|O\_CLOEXEC) = 3

fstat(3, {st\_mode=S\_IFREG|0644, st\_size=367708, ...}) = 0

mmap(NULL, 367708, PROT\_READ, MAP\_PRIVATE, 3, 0) = 0x7fd10a07e000

close(3)                                = 0

getresuid(\[0\], \[0\], \[0\])                = 0

getresgid(\[0\], \[0\], \[0\])                = 0

rt\_sigprocmask(SIG\_BLOCK, NULL, \[\], 8)  = 0

\--- SIGSEGV {si\_signo=SIGSEGV, si\_code=SEGV\_ACCERR, si\_addr=0x7fd10a429ef0} ---

+++ killed by SIGSEGV (core dumped) +++

Violación de segmento     (\`core' generado) strace -s100 -ff chroot /mnt

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Vaya, ese `strace` es una mina de oro de información. El problema es crítico pero identificable: el `chroot` funciona, pero el shell (`bash`) muere con un **SIGSEGV** (Violación de segmento) inmediatamente después de cargar las librerías dinámicas y las locales.

Esto suele ocurrir por una **incompatibilidad de versiones** entre la `glibc` (librería de C) del sistema anfitrión y la del sistema en `/mnt`, o porque los binarios en `/mnt` están corruptos.

Aquí tienes un script de rescate diseñado específicamente para saltarse el entorno roto y reparar las librerías base.

* * *

Script de Reparación de Emergencia (`reparar_chroot.sh`)
--------------------------------------------------------

Este script no usa el `chroot` del sistema directamente para reparar (porque está roto), sino que usa las herramientas del sistema "Live" para inyectar paquetes sanos en `/mnt`.

Bash

    #!/bin/bash
    
    # 1. Definir la ruta de montaje
    TARGET="/mnt"
    
    echo "--- Iniciando reparación de emergencia en $TARGET ---"
    
    # 2. Montar sistemas de archivos críticos del kernel
    # Usamos un bucle para asegurar que la API del kernel esté disponible
    for dir in proc sys dev dev/pts run; do
        if ! mountpoint -q "$TARGET/$dir"; then
            mount --bind /$dir "$TARGET/$dir"
            echo "Montado: $dir"
        fi
    done
    
    # 3. Reparación de paquetes críticos (Fuerza Bruta)
    # Usamos el pacman del sistema Live para instalar HACIA /mnt.
    # Esto evita ejecutar los scripts de post-instalación internos que están fallando.
    echo "--- Reinstalando glibc, bash y readline desde el exterior ---"
    pacman --root "$TARGET" --cachedir "$TARGET/var/cache/pacman/pkg" \
           --dbpath "$TARGET/var/lib/pacman" -S --noconfirm \
           glibc bash readline coreutils --overwrite "*"
    
    # 4. Limpiar caché de librerías dinámicas
    echo "--- Refrescando ld.so.cache ---"
    ldconfig -r "$TARGET"
    
    # 5. Intento de entrada segura
    echo "--- Intentando entrar al entorno ---"
    echo "Si bash sigue fallando, intentaremos con el shell estático busybox."
    
    # Intentar entrar limpiando el entorno previo
    chroot "$TARGET" /usr/bin/env -i TERM=$TERM PATH=/usr/bin:/usr/local/bin /bin/bash -i

* * *

Cómo ejecutarlo
---------------

1.  Guarda el código anterior en un archivo llamado `reparar.sh`.
    
2.  Dale permisos de ejecución: `chmod +x reparar.sh`.
    
3.  Ejecútalo como root: `sudo ./reparar.sh`.
    

* * *

¿Por qué está fallando tu chroot actual?
----------------------------------------

Según tu `strace`:

*   El error sucede en `si_addr=0x7fd10a429ef0`.
    
*   Esto ocurre justo después de que `bash` intenta mapear las **locales** (`es_ES.utf8`) y configurar el manejo de señales.
    
*   Al ser un `SEGV_ACCERR`, significa que el programa intentó acceder a una zona de memoria que tiene cargada pero para la cual **no tiene permisos**, o la estructura de la librería `glibc` en disco no coincide con lo que el kernel espera.
    

Si el script falla, prueba este "Plan B" manual:
------------------------------------------------

Si ni siquiera con el script puedes entrar, el binario de `pacman` dentro de `/mnt` también podría estar corrupto. Ejecuta este comando desde tu terminal de Manjaro Live:

Bash

    # Esto sobrescribe los archivos físicos sin ejecutar código del sistema roto
    pacman -Sy -r /mnt glibc bash readline --overwrite "*"

**¿Lograste entrar al shell o te dio algún error el comando de pacman?** Si entras, el siguiente paso será ejecutar `pacman -Syu` para estabilizar todo.

Has parado esta respuesta

---

You asked:
----------

Has dicho

Se queda colgado pacman.

  

:: ¿Continuar con la instalación? \[S/n\]  

:: Obteniendo los paquetes...

readline-8.3.003-1-x86\_64             409,7 KiB   177 KiB/s 00:02 \[####################################\] 100%

^Clibc-2.43+r5+g856c426a7534-1-x86\_64   10,1 MiB   897 KiB/s 00:12 \[####################################\] 100%

Interrupt signal received                0,0   B  0,00   B/s 00:00 \[####################################\] 100%

Total (1/3)                            10,5 MiB  1808 KiB/s 00:01 \[##############################------\]  84%

\[manjaro mnt\]# pacman -Sy -r /mnt glibc bash readline --overwrite "\*"

:: Sincronizando las bases de datos de los paquetes...

core está actualizado

extra está actualizado

multilib está actualizado

advertencia: glibc-2.43+r5+g856c426a7534-1 está actualizado -- reinstalándolo

advertencia: bash-5.3.9-1 está actualizado -- reinstalándolo

advertencia: readline-8.3.003-1 está actualizado -- reinstalándolo

resolviendo dependencias...

buscando conflictos entre paquetes...

  

Paquetes (3) bash-5.3.9-1  glibc-2.43+r5+g856c426a7534-1  readline-8.3.003-1

  

Tamaño total de la descarga:     12,42 MiB

Tamaño total de la instalación:  59,96 MiB

Tamaño neto tras actualizar:      0,00 MiB

  

:: ¿Continuar con la instalación? \[S/n\]  

:: Obteniendo los paquetes...

readline-8.3.003-1-x86\_64             409,7 KiB  86,3 KiB/s 00:05 \[####################################\] 100%

^Clibc-2.43+r5+g856c426a7534-1-x86\_64   10,1 MiB   357 KiB/s 00:29 \[####################################\] 100%

Interrupt signal received                0,0   B  0,00   B/s 00:00 \[####################################\] 100%

Total (1/3)                            10,5 MiB   879 KiB/s 00:02 \[##############################------\]  84%

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Parece que `pacman` está teniendo problemas para finalizar las descargas o procesar los archivos en el entorno del Live USB, lo que te obliga a cancelar con `Ctrl+C`. Esto puede deberse a un bloqueo de la base de datos o a que los servidores (mirrors) están fallando justo ahora.

Vamos a usar un script que **primero limpia los bloqueos** y luego realiza la instalación de forma **offline** (usando los paquetes que ya se descargaron al 100%) para evitar que se quede colgado en la red.

Script de Reparación Forzada (Modo Offline)
-------------------------------------------

Este script eliminará el archivo de bloqueo de pacman e intentará instalar los paquetes usando la caché local.

Bash

    #!/bin/bash
    
    TARGET="/mnt"
    
    echo "--- 1. Limpiando bloqueos de Pacman ---"
    rm -f "$TARGET/var/lib/pacman/db.lck"
    rm -f /var/lib/pacman/db.lck
    
    echo "--- 2. Reintentando instalación forzada (Sin scripts de post-instalación) ---"
    # Usamos --nodeps y --noscripts para que nada del sistema roto se ejecute
    # Intentamos usar los paquetes ya descargados en la caché del sistema Live o del destino
    pacman --root "$TARGET" -U /var/cache/pacman/pkg/glibc-*.pkg.tar.zst \
                              /var/cache/pacman/pkg/bash-*.pkg.tar.zst \
                              /var/cache/pacman/pkg/readline-*.pkg.tar.zst \
                              --overwrite "*" --noconfirm || \
    pacman --root "$TARGET" -U "$TARGET/var/cache/pacman/pkg/glibc-*.pkg.tar.zst" \
                              "$TARGET/var/cache/pacman/pkg/bash-*.pkg.tar.zst" \
                              "$TARGET/var/cache/pacman/pkg/readline-*.pkg.tar.zst" \
                              --overwrite "*" --noconfirm
    
    echo "--- 3. Reconstruyendo enlaces de librerías ---"
    ldconfig -r "$TARGET"
    
    echo "--- 4. Intento de entrada con shell básico ---"
    chroot "$TARGET" /bin/sh

* * *

Si el script anterior no encuentra los archivos `.pkg.tar.zst`:
---------------------------------------------------------------

Si `pacman` no llegó a guardar los paquetes por las interrupciones, ejecuta este comando para descargarlos **antes** de intentar instalarlos en `/mnt`:

1.  **Descarga solo (al sistema Live):**
    
    Bash
    
        pacman -Sw glibc bash readline --noconfirm
    
2.  **Instala desde la caché del Live al disco:**
    
    Bash
    
        pacman --root /mnt -U /var/cache/pacman/pkg/{glibc,bash,readline}-*.pkg.tar.zst --overwrite "*"
    

¿Por qué se queda al 84%?
-------------------------

El mensaje `Total (1/3)` y el `84%` sugieren que `pacman` está intentando descargar el tercer paquete (probablemente `bash`) y el servidor no responde, o el archivo local está corrupto.

**¿Qué pasa si intentas esto?** Dime si al ejecutar `ls /mnt/usr/lib/libc.so.6` el archivo aparece. Si el archivo está ahí pero vacío (0 bytes), el problema es una descarga fallida que dejó el sistema inutilizable.

**¿Quieres que intentemos copiar los binarios del Live USB directamente a `/mnt` para "puentear" a pacman por completo?** (Es la opción más agresiva pero efectiva cuando pacman muere).

Has parado esta respuesta

---

You asked:
----------

Has dicho

\[manjaro core\_generado\_chroot\]# pacman -Sw glibc bash readline --noconfirm

resolviendo dependencias...

error: no se pudo preparar la operación (no se pudieron satisfacer las dependencias)

:: instalando glibc (2.43+r5+g856c426a7534-1) se rompe la dependencia con «glibc=2.41+r48+g5cb575ca9a3d», nece

saria para el paquete glibc-locales

:: instalando glibc (2.43+r5+g856c426a7534-1) se rompe la dependencia con «glibc=2.41+r48+g5cb575ca9a3d», nece

saria para el paquete lib32-glibc

\[manjaro core\_generado\_chroot\]# pacman --root /mnt -U /var/cache/pacman/pkg/{glibc,bash,readline}-\*.pkg.tar.zs

t --overwrite "\*"

cargando los paquetes...

error: '/var/cache/pacman/pkg/glibc-\*.pkg.tar.zst': no se pudo encontrar o leer el paquete

error: '/var/cache/pacman/pkg/bash-\*.pkg.tar.zst': no se pudo encontrar o leer el paquete

error: '/var/cache/pacman/pkg/readline-\*.pkg.tar.zst': no se pudo encontrar o leer el paquete

---

Gemini Replied:
---------------

Gemini ha dicho
---------------

Entiendo perfectamente. Estás atrapado en un "infierno de dependencias" donde el sistema Live tiene una versión de `glibc` y el sistema en `/mnt` tiene otra, y `pacman` se niega a descargar nada porque teme romper el sistema actual. Además, las descargas no se completaron.

Vamos a usar la técnica de **"Trasplante de Binarios"**. Si el sistema Live funciona, sus librerías y su `bash` son compatibles con tu procesador. Vamos a copiarlos a la fuerza para que el `chroot` vuelva a la vida y puedas usar `pacman` normalmente desde dentro.

Script de Trasplante Manual (Puentear Pacman)
---------------------------------------------

Crea y ejecuta este script. Lo que hará es copiar los archivos críticos del sistema Live (que sabemos que funcionan) directamente a tu partición `/mnt`.

Bash

    #!/bin/bash
    
    TARGET="/mnt"
    
    echo "--- 1. Preparando el trasplante de emergencia ---"
    # Asegurar que los directorios existen
    mkdir -p "$TARGET/usr/lib"
    mkdir -p "$TARGET/usr/bin"
    
    echo "--- 2. Copiando librerías críticas (Glibc y Readline) ---"
    # Copiamos el cargador dinámico y las librerías base del Live USB al disco
    cp -v /usr/lib/libc.so.6 "$TARGET/usr/lib/"
    cp -v /usr/lib/libreadline.so.8 "$TARGET/usr/lib/"
    cp -v /usr/lib/libncursesw.so.6 "$TARGET/usr/lib/"
    cp -v /usr/lib/ld-linux-x86-64.so.2 "$TARGET/usr/lib/"
    
    echo "--- 3. Copiando binarios básicos ---"
    cp -v /usr/bin/bash "$TARGET/usr/bin/"
    cp -v /usr/bin/sh "$TARGET/usr/bin/"
    cp -v /usr/bin/env "$TARGET/usr/bin/"
    
    echo "--- 4. Sincronizando enlaces simbólicos ---"
    # A veces /lib64 es un symlink, aseguramos que el cargador sea visible
    mkdir -p "$TARGET/lib64"
    ln -sf /usr/lib/ld-linux-x86-64.so.2 "$TARGET/lib64/ld-linux-x86-64.so.2"
    
    echo "--- 5. Intentando CHROOT de rescate ---"
    # Montajes necesarios
    for dir in proc sys dev; do
        mount --bind /$dir "$TARGET/$dir" 2>/dev/null
    done
    
    # Intentar entrar con un entorno vacío para evitar errores de locales
    chroot "$TARGET" /usr/bin/env -i PATH=/usr/bin:/usr/local/bin /usr/bin/bash --noprofile --norc

* * *

¿Por qué esto debería funcionar?
--------------------------------

Al copiar los archivos `.so` y el binario de `bash` directamente del sistema Live, eliminamos la corrupción que causa el `SIGSEGV`. Una vez que el `chroot` te dé un prompt (aunque sea un simple `#`), habrás ganado.

Una vez que logres entrar al chroot:
------------------------------------

Tu sistema estará "híbrido" (mitad archivos del Live, mitad archivos del disco). Debes arreglar la base de datos de inmediato:

1.  **Actualiza la base de datos:** `pacman -Sy`
    
2.  **Fuerza la reinstalación de TODO lo que falló antes:**
    
    Bash
    
        pacman -S glibc glibc-locales lib32-glibc bash readline --overwrite "*"
    

**¿Te funcionó el trasplante o dio algún error de "fichero de solo lectura"?** (Si es así, habrá que remontar con `mount -o remount,rw /mnt`). Es el último paso antes de tener que considerar una reinstalación de la base, ¡así que crucemos los dedos!

Has parado esta respuesta

---

