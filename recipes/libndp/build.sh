#!/bin/bash
# libndp 1.9 — autotools. El tarball del tag de GitHub NO trae ./configure:
# autogen.sh corre autoreconf (autoconf/automake/libtool ya en el rootfs base, ch08).
# Hard dep de NetworkManager 1.56: meson.build hace dependency(libndp)
# incondicional (meson_options.txt 1.56 no define opcion libndp).
set -euo pipefail
./autogen.sh
./configure --prefix=/usr --disable-static
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
