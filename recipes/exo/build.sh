#!/bin/bash
# xfce — autotools (autogen si el tarball de git no trae configure) o meson si aplica.
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d"
if [ ! -f configure ] && [ -f autogen.sh ]; then NOCONFIGURE=1 ./autogen.sh; fi
if [ -f configure ]; then
  ./configure --prefix=/usr --sysconfdir=/etc --disable-static --disable-debug "$@"
  make -j"$(nproc)"
  DESTDIR="$DESTDIR" make install
else
  meson setup build --prefix=/usr --buildtype=release --libdir=lib --default-library=shared
  ninja -C build
  DESTDIR="$DESTDIR" ninja -C build install
fi
