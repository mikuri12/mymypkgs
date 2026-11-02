#!/bin/bash
# pixman 0.46.4 — meson. tests/demos son 'feature' en 0.46.4 (verificado
# contra meson.options del tarball): disabled OK. Solo SSE2/SSSE3 en x86_64.
set -euo pipefail
rm -rf build && rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D tests=disabled -D demos=disabled \
  -D mmx=disabled -D sse2=enabled -D ssse3=enabled \
  -D gtk=disabled -D libpng=disabled \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
