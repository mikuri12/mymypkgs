#!/bin/bash
# grim 1.4.0 — meson. Deps: pixman+libpng+libjpeg: pixman hay que compilar.
set -euo pipefail
PIXMAN=0.46.4
curl -fsSL --retry 3 -o pixman.tar.gz "https://gitlab.freedesktop.org/pixman/pixman/-/archive/pixman-${PIXMAN}/pixman-pixman-${PIXMAN}.tar.gz"
tar -xzf pixman.tar.gz && cd pixman-pixman-*
meson setup --prefix=/usr build --buildtype=release -D demos=disabled -D tests=disabled
ninja -C build && DESTDIR="$DESTDIR" ninja -C build install
cd ..
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
DESTDIR="$DESTDIR" ninja install
