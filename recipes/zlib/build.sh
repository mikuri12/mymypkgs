#!/bin/bash
# zlib 1.3.1 — autotools, DESTDIR soportado (verificado en Makefile.in).
# El paquete va al staging; el workflow lo instala luego en el chroot.
set -euo pipefail
cd /tmp/build/zlib-1.3.1
./configure --prefix=/usr
make -j"$(nproc)"
make DESTDIR="$DESTDIR" install
