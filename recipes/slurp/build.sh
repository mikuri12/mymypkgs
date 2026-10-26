#!/bin/bash
# slurp 1.5.0 — cairo YA extraído por build-pkg.sh.
set -euo pipefail
cd cairo-*
meson setup --prefix=/usr build --buildtype=release -D tests=disabled
ninja -C build && DESTDIR="$DESTDIR" ninja -C build install
cd ..
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
DESTDIR="$DESTDIR" ninja install
