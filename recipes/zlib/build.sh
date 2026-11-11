#!/bin/bash
# zlib — autotools, DESTDIR soportado (verificado en Makefile.in).
# El dir de extracción depende de la versión: glob, no hardcode.
# El paquete va al staging; el workflow lo instala luego en el chroot.
set -euo pipefail
cd /tmp/build/zlib-*
./configure --prefix=/usr
make -j"$(nproc)"
make DESTDIR="$DESTDIR" install
