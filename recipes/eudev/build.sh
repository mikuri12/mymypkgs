#!/bin/bash
# eudev 3.2.15 — misma receta que mylfs/base/ch08.sh (bloque extras eudev):
# autotools, sin docs, hwdb update post-install vía trigger (mymy corre
# `udevadm hwdb --update` como hook; aquí solo se instala).
set -euo pipefail
rm -rf build && mkdir build && cd build
../configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
  --disable-manpages --disable-introspection \
  CPPFLAGS="-D_BSD_SOURCE -D_DEFAULT_SOURCE"
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
# reglas y binarios auxiliares que el libro instala a mano
install -v -m755 -d "$DESTDIR/etc/udev/rules.d" "$DESTDIR/usr/lib/udev/rules.d"
