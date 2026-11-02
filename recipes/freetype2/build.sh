#!/bin/bash
# freetype 2.13.3 — meson. Opciones reales (meson_options.txt): brotli/bzip2/
# harfbuzz/mmap/png/tests son feature; zlib es combo (enabled/disabled/auto).
# En el chroot solo hay zlib y libpng: brotli/bzip2/harfbuzz NO.
set -euo pipefail
rm -rf build && rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D zlib=enabled \
  -D bzip2=disabled \
  -D brotli=disabled \
  -D harfbuzz=disabled \
  -D png=enabled \
  -D mmap=disabled \
  -D tests=disabled \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
