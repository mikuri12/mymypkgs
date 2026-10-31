#!/bin/bash
# libpng 1.6.44 — autotools (los tarballs oficiales NO traen meson.build;
# verificado contra libpng-1.6.44.tar.xz de SourceForge). zlib ya esta
# instalado en el chroot (ORDER).
set -euo pipefail
cd /tmp/build/libpng-1.6.44
./configure --prefix=/usr --disable-static
make -j"$(nproc)"
make DESTDIR="$DESTDIR" install
