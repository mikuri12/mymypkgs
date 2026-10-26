#!/bin/bash
# fuzzel 1.15.0 — deps (tllist, fcft) YA extraídas por build-pkg.sh.
set -euo pipefail
cd /tmp/build/tllist
meson setup --prefix=/usr build --buildtype=release
ninja -C build && DESTDIR="$DESTDIR" ninja -C build install
cd ..
cd /tmp/build/fcft
meson setup --prefix=/usr build --buildtype=release -D docs=disabled -D examples=disabled
ninja -C build && DESTDIR="$DESTDIR" ninja -C build install
cd ..
cd /tmp/build/fuzzel-1.15.0
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release -D docs=disabled -D man=disabled ..
ninja
DESTDIR="$DESTDIR" ninja install
