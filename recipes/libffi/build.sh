#!/bin/bash
# libffi 3.5.2 — autotools (LFS 8.50; sin --with-gcc-arch=native, el runner
# no es el destino: -march=skylake ya va en CFLAGS globales).
set -euo pipefail
./configure --prefix=/usr --disable-static
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
