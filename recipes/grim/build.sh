#!/bin/bash
# grim 1.4.0 — pixman YA extraído por build-pkg.sh.
set -euo pipefail
cd /tmp/build/pixman-pixman-0.46.4
meson setup --prefix=/usr build --buildtype=release -D demos=disabled -D tests=disabled
ninja -C build && ninja -C build install
cd ..
cd /tmp/build/grim-1.4.0
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
DESTDIR="$DESTDIR" ninja install
