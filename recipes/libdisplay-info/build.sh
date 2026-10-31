#!/bin/bash
# libdisplay-info 3.2.0 — meson. Leer meson_options del tarball antes de -D.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D tests=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
