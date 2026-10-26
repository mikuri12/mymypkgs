#!/bin/bash
# grim 1.4.0 — pixman YA extraído por build-pkg.sh.
set -euo pipefail
cd pixman-pixman-*
meson setup --prefix=/usr build --buildtype=release -D demos=disabled -D tests=disabled
ninja -C build && DESTDIR="$DESTDIR" ninja -C build install
cd ..
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
DESTDIR="$DESTDIR" ninja install
