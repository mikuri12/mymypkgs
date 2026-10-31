#!/bin/bash
# fuzzel 1.15.0 — deps (tllist, fcft) YA extraídas por build-pkg.sh.
set -euo pipefail
STAGING="$DESTDIR"   # staging del paquete; deps van al chroot real
unset DESTDIR       # ninja/make install heredan el export del build-pkg
cd /tmp/build/tllist
meson setup --prefix=/usr build --buildtype=release
ninja -C build && ninja -C build install
cd ..
cd /tmp/build/fcft
meson setup --prefix=/usr build --buildtype=release -D docs=disabled -D examples=false
ninja -C build && ninja -C build install
cd ..
cd /tmp/build/fuzzel-1.15.0
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release -D png-backend=libpng ..
ninja
DESTDIR="$STAGING" ninja install
