#!/bin/bash
# slurp 1.5.0 — cairo YA extraído por build-pkg.sh.
set -euo pipefail
STAGING="$DESTDIR"   # staging del paquete; deps van al chroot real
unset DESTDIR       # ninja/make install heredan el export del build-pkg
cd /tmp/build/cairo-1.18.4
meson setup --prefix=/usr build --buildtype=release -D tests=disabled
ninja -C build && ninja -C build install
cd ..
cd /tmp/build/slurp-1.5.0
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
DESTDIR="$STAGING" ninja install
