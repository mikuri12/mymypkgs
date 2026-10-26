#!/bin/bash
# slurp 1.5.0 — meson (usa cairo: compilar como dep embebida).
set -euo pipefail
CAIRO=1.18.4
curl -fsSL --retry 3 -o cairo.tar.xz "https://cairographics.org/releases/cairo-${CAIRO}.tar.xz"
tar -xJf cairo.tar.xz && cd cairo-*
meson setup --prefix=/usr build --buildtype=release -D tests=disabled
ninja -C build && DESTDIR="$DESTDIR" ninja -C build install
cd ..
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
DESTDIR="$DESTDIR" ninja install
